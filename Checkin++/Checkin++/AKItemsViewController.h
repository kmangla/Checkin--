//
//  AKItemsViewController.h
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKItemsViewController : UITableViewController {
  AKPlace *_place;
}

- (id) initWithPlace:(AKPlace*) place action:(NSString*) action;

@end
