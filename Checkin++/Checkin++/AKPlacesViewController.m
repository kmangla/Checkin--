//
//  AKPlacesViewController.m
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKPlacesViewController.h"

@interface AKPlacesViewController ()
<CLLocationManagerDelegate, FBRequestDelegate>

@end

@implementation AKPlacesViewController


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
    NSString* center = [NSString stringWithFormat: @"(%f.8, %f.8)", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"q", @"", @"center", center, nil];
    _request = [[_facebook requestWithGraphPath:@"search" andParams:params andDelegate:self] retain];
  }
}


- (void) dealloc
{
  [_facebook release];
  [_request release];
  [_locationManager release];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
