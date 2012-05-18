//
//  AKPlacesViewController.m
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKPlacesViewController.h"
#import "AKActionsViewController.h"
#import "AKPlace.h"

@interface AKPlacesViewController ()
<CLLocationManagerDelegate, FBRequestDelegate>

@property(nonatomic, retain) FBRequest* request;

@end

@implementation AKPlacesViewController
@synthesize request = _request;

- (id)initWithFacebook:(Facebook*) facebook {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _facebook = [facebook retain];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
  }
  return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  if (!_request) {
    NSString* center = [NSString stringWithFormat: @"%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:  @"place", @"type",  @" ", @"q", center, @"center", nil];
    _request = [[_facebook requestWithGraphPath:@"search" andParams:params andDelegate:self] retain];
  }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
  NSLog(@"%@", error);
  self.request = nil;
}

- (void)request:(FBRequest *)request didLoad:(id)result {
  NSLog(@"%@", result);
  NSMutableArray *places = [[NSMutableArray alloc] init];
  NSArray *arrayResult = [result objectForKey:@"data"];
  for (NSDictionary *place in arrayResult){
    [places addObject:[[AKPlace alloc] initWithJSON:place]];
  }
  self.request = nil;
  [_places release];
  _places = places;
  [_locationManager stopUpdatingLocation];
  [self.tableView reloadData];
}

- (void) dealloc
{
  [_facebook release];
  [_request release];
  [_locationManager release];
  [_places release];
  [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  self.title = @"Checkin++";

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear: (BOOL) animated {
  [super viewWillAppear: animated];
  [_locationManager startUpdatingLocation];
}

- (void) viewWillDisappear: (BOOL) animated {
  [super viewWillDisappear: animated];
  [_locationManager stopUpdatingLocation];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  AKPlace* place = (AKPlace*)[_places objectAtIndex: indexPath.row];
  UITableViewController* controller = [[AKActionsViewController alloc] initWithFacebook:_facebook place:place];
  [self.navigationController pushViewController: controller animated:YES];
  [controller release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString* const kTableCell = @"table_cell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: kTableCell];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: kTableCell];
  }

  AKPlace* place = (AKPlace*)[_places objectAtIndex: indexPath.row];

  cell.textLabel.text = place.name;
  cell.detailTextLabel.text = place.street;
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_places count];
}

@end

