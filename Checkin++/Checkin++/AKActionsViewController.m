//
//  AKActionsViewController.m
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKActionsViewController.h"
#import "AKItemsViewController.h"

@interface AKActionsViewController () {
  NSArray* _questions;
}

@end

static NSString* kQ1String = @"Eating lunch";
static NSString* kQ2String = @"Eating dinner";
static NSString* kQ3String = @"Flying to";
static NSString* kQ4String = @"Visiting";
static NSString* kQ5String = @"Staying at";
static NSString* kQ6String = @"Drinking";
static NSString* kQ7String = @"Watching";

@implementation AKActionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFacebook:(Facebook *)facebook place:(AKPlace *) place
{
  if (self = [super initWithStyle:UITableViewStylePlain]) {
    _place = [place retain];
    _facebook = [facebook retain];
    _questions = [[NSArray alloc] initWithObjects: kQ1String, kQ2String, kQ3String, kQ4String, kQ5String, kQ6String, kQ7String, nil];
  }
  return self;
}

- (void)dealloc {
  [_facebook release];
  [_place release];
  [_questions release];
  [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_questions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"actionCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }

  NSString* question = (NSString*)[_questions objectAtIndex: indexPath.row];
  cell.textLabel.text = question;
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Warning: this is hacky as hell
  AKQuestionType questionType = indexPath.row + 1;

  UITableViewController* controller = [[AKItemsViewController alloc] initWithFacebook:_facebook
                                                                                place:_place
                                                                         questionType:questionType];
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
}

@end
