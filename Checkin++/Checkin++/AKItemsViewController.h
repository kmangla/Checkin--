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

@class AKSearchView;

@interface AKItemsViewController : UITableViewController {
  Facebook *_facebook;
  AKPlace *_place;
  AKQuestionType _questionType;
  FBRequest *_downloadRequest;
  FBRequest *_createRequest;
  FBRequest *_publishRequest;
  NSArray *_items;
  BOOL _addButtonVisible;

  AKSearchView *_searchView;
}

- (id)initWithFacebook:(Facebook *)facebook place:(AKPlace*)place questionType:(AKQuestionType)questionType;

@property(nonatomic, assign) BOOL addButtonVisible;

@end
