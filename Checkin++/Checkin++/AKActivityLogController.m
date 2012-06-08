//
//  AKActivityLogController.m
//  Checkin++
//
//  Created by Albert Sun on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKActivityLogController.h"
#import "AKStory.h"
#import "AKStoryCell.h"

static NSString *kAppURL = @"https://blooming-water-4048.herokuapp.com/activity.php";

@interface AKActivityLogController () <FBRequestDelegate, UIAlertViewDelegate>

- (void)_sendObjectsDownloadRequest;

@property(nonatomic, retain) FBRequest *downloadRequest;

@end

@implementation AKActivityLogController
@synthesize downloadRequest = _downloadRequest;

- (id)initWithFacebook:(Facebook *)facebook initialStory:(AKStory *)initialStory
{
  if (self = [super initWithStyle:UITableViewStylePlain]) {
    _facebook = [facebook retain];
    if (initialStory != nil) {
      _items = [[NSArray alloc] initWithObjects:initialStory, nil];
    }
    [self _sendObjectsDownloadRequest];
  }
  return self;
}

- (void)dealloc
{
  [_facebook release];
  [_items release];

  [super dealloc];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.title = @"Activity Log";
  self.tableView.rowHeight = 60;
}

- (void)_sendObjectsDownloadRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _facebook.accessToken, @"access_token",
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
        for (NSDictionary *story in result){
            [items addObject:[[AKStory alloc] initWithJSON:story]];
        }
        self.downloadRequest = nil;
        [_items release];
        _items = items;
        [self.tableView reloadData];
  }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"storyCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[AKStoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }

  AKStory *story = [_items objectAtIndex:indexPath.row];
  ((AKStoryCell *)cell).storyString = story.storyString;

  return cell;
}

@end
