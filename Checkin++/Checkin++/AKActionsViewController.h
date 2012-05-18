//
//  AKActionsViewController.h
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPlace.h"

@interface AKActionsViewController : UITableViewController {
  AKPlace *_place;
}

- (id) initWithPlace:(AKPlace*) place;

@end
