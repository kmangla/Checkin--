//
//  AKPlacesViewController.h
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import <CoreLocation/CoreLocation.h>

@interface AKPlacesViewController : UITableViewController {
  Facebook* _facebook;
  CLLocationManager* _locationManager;
  FBRequest* _request;
  NSArray *_places;
}

- (id) initWithFacebook:(Facebook*) facebook;

@end
