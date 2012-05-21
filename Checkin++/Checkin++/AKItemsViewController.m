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

static NSString *kAppURL = @"https://blooming-water-4048.herokuapp.com/items.php";

@interface AKItemsViewController () <FBRequestDelegate, UIAlertViewDelegate>

- (void)_sendObjectsDownloadRequest;
- (void)_sendObjectCreateRequest;
- (void)_sendPublishRequestWithItemId:(NSString *)itemId;

@property(nonatomic, retain) FBRequest *downloadRequest;
@property(nonatomic, retain) FBRequest *createRequest;
@property(nonatomic, retain) FBRequest *publishRequest;
@property(nonatomic, retain) AKSearchView *searchView;

@end

@implementation AKItemsViewController
@synthesize downloadRequest = _downloadRequest;
@synthesize createRequest = _createRequest;
@synthesize publishRequest = _publishRequest;
@synthesize searchView = _searchView;

#pragma mark - Lifecycle

- (id)initWithFacebook:(Facebook *)facebook place:(AKPlace*)place questionType:(AKQuestionType)questionType
{
  if (self = [super initWithStyle:UITableViewStylePlain]) {
    _facebook = [facebook retain];
    _place = [place retain];
    _questionType = questionType;
  }
  return self;
}

- (void)dealloc
{
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
  // publish the open graph story
  AKItem *item = [_items objectAtIndex:indexPath.row];

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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"Thanks for playing"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
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

@end
