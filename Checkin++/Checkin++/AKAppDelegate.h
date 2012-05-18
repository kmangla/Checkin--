//
//  AKAppDelegate.h
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class AKViewController;

@interface AKAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate> {
    Facebook *_facebook;
}


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) Facebook *facebook;
@end
