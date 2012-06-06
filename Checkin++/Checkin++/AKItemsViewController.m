//
//  AKItemsViewController.m
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKItemsViewController.h"
#import "FBConnect.h"
#import "AKItem.h"
#import "AKSearchView.h"
#import "AKStory.h"
#import "AKActivityLogController.h"

static NSString *kAppURL = @"https://blooming-water-4048.herokuapp.com/items.php";

// This is sort of temporary, maybe these should come down from the server?
static NSString* kQ1VerbString = @"ate a";
static NSString* kQ2VerbString = @"flew to";
static NSString* kQ3VerbString = @"visited";
static NSString* kQ4VerbString = @"stayed";
static NSString* kQ5VerbString = @"drank a";
static NSString* kQ6VerbString = @"watched";
static NSString* kQ7VerbString = @"played";

static NSString* kQ1TitleString = @"Eating what?";
static NSString* kQ2TitleString = @"Going where?";
static NSString* kQ3TitleString = @"Visiting where?";
static NSString* kQ4TitleString = @"Staying where?";
static NSString* kQ5TitleString = @"Drinking what?";
static NSString* kQ6TitleString = @"Watching what?";
static NSString* kQ7TitleString = @"Playing what?";

@interface AKItemsViewController () <FBRequestDelegate, UIAlertViewDelegate>

- (void)_sendObjectsDownloadRequest;
- (void)_sendObjectCreateRequest;
- (void)_sendPublishRequestWithItemId:(NSString *)itemId;
- (void)_buildStoryAndShowActivityLog;

@property(nonatomic, retain) FBRequest *downloadRequest;
@property(nonatomic, retain) FBRequest *createRequest;
@property(nonatomic, retain) FBRequest *publishRequest;
@property(nonatomic, retain) AKSearchView *searchView;
@property(nonatomic, copy) NSString *chosenItemName;

@end

@implementation AKItemsViewController
@synthesize downloadRequest = _downloadRequest;
@synthesize createRequest = _createRequest;
@synthesize publishRequest = _publishRequest;
@synthesize searchView = _searchView;
@synthesize chosenItemName = _chosenItemName;

#pragma mark - Lifecycle

- (id)initWithFacebook:(Facebook *)facebook place:(AKPlace*)place questionType:(AKQuestionType)questionType
{
  if (self = [super initWithStyle:UITableViewStylePlain]) {
    _facebook = [facebook retain];
    _place = [place retain];
    _questionType = questionType;
    // Blech, need to refactor these
    _verbs = [[NSArray alloc] initWithObjects:kQ1VerbString, kQ2VerbString, kQ3VerbString, kQ4VerbString, kQ5VerbString,
              kQ6VerbString, kQ7VerbString, nil];
    _titles = [[NSArray alloc] initWithObjects:kQ1TitleString, kQ2TitleString, kQ3TitleString, kQ4TitleString,
               kQ5TitleString, kQ6TitleString, kQ7TitleString, nil];
  }
  return self;
}

- (void)dealloc
{
  [_titles release];
  [_verbs release];
  [_chosenItemName release];
  [_place release];
  [_facebook release];
  [_downloadRequest release];
  [_createRequest release];
  [_publishRequest release];
  [_searchView release];

  [super dealloc];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // TODO: refactor this
  self.title = [_titles objectAtIndex:_questionType - 1];

  CGRect searchViewFrame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
  AKSearchView *searchView = [[AKSearchView alloc] initWithFrame:searchViewFrame];
  searchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textFieldDidChange:)
                                               name:UITextFieldTextDidChangeNotification
                                             object:searchView.textField];
  self.searchView = searchView;
  [searchView release];
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                             initWithTitle:@"Post"
                                             style:UIBarButtonItemStyleBordered
                                             target:self
                                             action:@selector(_didTapPost:)]
                                            autorelease];;

  self.tableView.tableHeaderView = self.searchView;

  [self _sendObjectsDownloadRequest];
}

- (void)viewDidUnload
{
  self.searchView = nil;

  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"itemCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }

  AKItem *item = [_items objectAtIndex:indexPath.row];
  cell.textLabel.text = item.name;

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  AKItem *item = [_items objectAtIndex:indexPath.row];
  self.chosenItemName = item.name;
  // publish the open graph story
  [self _sendPublishRequestWithItemId:item.itemId];
}

#pragma mark - FBRequestDelegate

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  NSLog(@"Request failed: %@", error);
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
  if (request == self.downloadRequest) {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *item in result){
      [items addObject:[[AKItem alloc] initWithJSON:item]];
    }
    self.downloadRequest = nil;
    [_items release];
    _items = items;
    [self.tableView reloadData];
  } else if (request == self.createRequest) {
    NSString *itemId = [result objectForKey:@"item_id"];

    [self _sendPublishRequestWithItemId:itemId];
    self.createRequest = nil;

  } else if (request == self.publishRequest) {
    [self _buildStoryAndShowActivityLog];
  }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - NSNotificationCenter

- (void)textFieldDidChange:(NSNotification *)notification
{
  self.addButtonVisible = (self.searchView.textField.text.length > 0);
 [self _sendObjectsDownloadRequest];
}

#pragma mark - Properties

- (BOOL)addButtonVisible
{
  return _addButtonVisible;
}

- (void)setAddButtonVisible:(BOOL)addButtonVisible
{
  if (addButtonVisible != _addButtonVisible) {
    _addButtonVisible = addButtonVisible;
    if (_addButtonVisible) {
      self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                                 initWithTitle:@"Add Item"
                                                 style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(_didTapAdd:)]
                                                autorelease];
    } else {
      self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                                 initWithTitle:@"Post"
                                                 style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(_didTapPost:)]
                                                autorelease];;
    }
  }
}

#pragma mark - Private

- (void)_sendObjectsDownloadRequest
{
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%d", _questionType], @"question_type",
                                 _place.fbid, @"page_id",
                                 self.searchView.textField.text, @"query",
                                 nil];
  FBRequest *request = [FBRequest getRequestWithParams:params
                                            httpMethod:@"GET"
                                              delegate:self
                                            requestURL:kAppURL];
  [self.downloadRequest.connection cancel];
  self.downloadRequest = request;
  [request connect];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)_sendObjectCreateRequest
{
  self.chosenItemName = self.searchView.textField.text;
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%d", _questionType], @"question_type",
                                 _place.fbid, @"page_id",
                                 self.searchView.textField.text, @"name",
                                 nil];
  FBRequest *request = [FBRequest getRequestWithParams:params
                                            httpMethod:@"POST"
                                              delegate:self
                                            requestURL:kAppURL];
  [self.createRequest.connection cancel];
  self.createRequest = request;
  [request connect];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)_sendPublishRequestWithItemId:(NSString *)itemId
{
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _facebook.accessToken, @"access_token",
                                 [NSString stringWithFormat:@"%d", _questionType], @"question_type",
                                 _place.fbid, @"page_id",
                                 itemId, @"item_id",
                                 @"1", @"publish",
                                 nil];
  FBRequest *request = [FBRequest getRequestWithParams:params
                                            httpMethod:@"POST"
                                              delegate:self
                                            requestURL:kAppURL];
  [self.publishRequest.connection cancel];
  self.publishRequest = request;
  [request connect];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)_sendPublishRequestWithoutItemId
{
  self.chosenItemName = nil;
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _facebook.accessToken, @"access_token",
                                 [NSString stringWithFormat:@"%d", _questionType], @"question_type",
                                 _place.fbid, @"page_id",
                                 @"1", @"publish",
                                 nil];
  FBRequest *request = [FBRequest getRequestWithParams:params
                                            httpMethod:@"POST"
                                              delegate:self
                                            requestURL:kAppURL];
  [self.publishRequest.connection cancel];
  self.publishRequest = request;
  [request connect];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)_didTapPost:(id)sender
{
    [self _sendPublishRequestWithoutItemId];
}

- (void)_didTapAdd:(id)sender
{
  [self _sendObjectCreateRequest];
}

- (void)_buildStoryAndShowActivityLog
{
  // Builds a local story and opens activity log controller with the story
  // We may want to consider skipping creating the story ourself and just fetch from server instead
  AKStory *story = [[AKStory alloc] initWithActor:@"I"
                                         verbName:[_verbs objectAtIndex:_questionType - 1] /* TODO: refactor */
                                        placeName:_place.name
                                       objectName:self.chosenItemName];

  UITableViewController* controller = [[AKActivityLogController alloc] initWithFacebook:_facebook
                                                                           initialStory:story];
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
}

@end
