//
//  AKActivityLogController.h
//  Checkin++
//
//  Created by Albert Sun on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class AKStory;

@interface AKActivityLogController : UITableViewController
{
  Facebook *_facebook;
  NSArray *_items;
}

// TODO: initial story might be removed if we decide to only download from server
- (id)initWithFacebook:(Facebook *)facebook initialStory:(AKStory *)initialStory;

@end
