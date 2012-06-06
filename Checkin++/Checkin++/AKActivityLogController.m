//
//  AKActivityLogController.m
//  Checkin++
//
//  Created by Albert Sun on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKActivityLogController.h"
#import "AKStory.h"

@implementation AKActivityLogController

- (id)initWithFacebook:(Facebook *)facebook initialStory:(AKStory *)initialStory
{
  if (self = [super initWithStyle:UITableViewStylePlain]) {
    _facebook = [facebook retain];
    if (initialStory != nil) {
      _items = [[NSArray alloc] initWithObjects:initialStory, nil];
    }
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
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }

  AKStory *story = [_items objectAtIndex:indexPath.row];
  cell.textLabel.text = [story.storyString string]; // TODO: make this colored, and line-wrap the cell

  return cell;
}

@end
