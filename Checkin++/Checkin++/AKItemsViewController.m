//
//  AKItemsViewController.m
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKItemsViewController.h"
#import "FBConnect.h"

static NSString *kAppURL = @"https://blooming-water-4048.herokuapp.com/items.php";

@interface AKItemsViewController () <FBRequestDelegate>

- (void)_initiateObjectsDownload;
@property(nonatomic, retain) FBRequest *downloadRequest;

@end

@implementation AKItemsViewController
@synthesize downloadRequest = _downloadRequest;

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
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"itemCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // publish the call

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
