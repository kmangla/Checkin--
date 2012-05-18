//
//  AKItemsViewController.h
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKActionsViewController.h"
#import "FBConnect.h"

@interface AKItemsViewController : UITableViewController {
  Facebook *_facebook;
  AKPlace *_place;
  AKQuestionType _questionType;
  FBRequest *_downloadRequest;
  FBRequest *_publishRequest;
  NSArray *_items;
}

- (id)initWithFacebook:(Facebook *)facebook place:(AKPlace*)place questionType:(AKQuestionType)questionType;

@end
