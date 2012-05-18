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

static NSString *kAppURL = @"https://blooming-water-4048.herokuapp.com/items.php";

@interface AKItemsViewController () <FBRequestDelegate, UIAlertViewDelegate>

- (void)_initiateObjectsDownload;

@property(nonatomic, retain) FBRequest *downloadRequest;
@property(nonatomic, retain) FBRequest *publishRequest;

@end

@implementation AKItemsViewController
@synthesize downloadRequest = _downloadRequest;
@synthesize publishRequest = _publishRequest;

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
  [_publishRequest release];

  [super dealloc];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self _initiateObjectsDownload];
}

- (void)viewDidUnload
{
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

  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _facebook.accessToken, @"access_token",
                                 item.questionType, @"question_type",
                                 _place.fbid, @"page_id",
                                 item.itemId, @"item_id",
                                 @"1", @"publish",
                                 nil];
  FBRequest *request = [FBRequest getRequestWithParams:params
                                            httpMethod:@"POST"
                                              delegate:self
                                            requestURL:kAppURL];
  [self.publishRequest.connection cancel];
  self.publishRequest = request;
  [request connect];
}

#pragma mark - FBRequestDelegate

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{

}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{

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

#pragma mark - Private

- (void)_initiateObjectsDownload
{
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%d", _questionType], @"question_type",
                                 _place.fbid, @"page_id",
                                 nil];
  FBRequest *request = [FBRequest getRequestWithParams:params
                                            httpMethod:@"GET"
                                              delegate:self
                                            requestURL:kAppURL];
  [self.downloadRequest.connection cancel];
  self.downloadRequest = request;
  [request connect];
}

@end
