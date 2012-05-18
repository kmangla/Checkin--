//
//  AKActionsViewController.h
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPlace.h"
#import "FBConnect.h"

typedef enum {
  kQ1 = 1,
  kQ2,
  kQ3,
  kQ4,
  kQ5,
  kQ6,
  kQ7,
} AKQuestionType;


@interface AKActionsViewController : UITableViewController {
  AKPlace *_place;
  Facebook *_facebook;
}

- (id)initWithFacebook:(Facebook *)facebook place:(AKPlace *) place;

@end
