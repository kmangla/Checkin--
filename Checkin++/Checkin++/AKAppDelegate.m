//
//  AKAppDelegate.m
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKAppDelegate.h"

#import "AKPlacesViewController.h"

@implementation AKAppDelegate

@synthesize window = _window;
@synthesize facebook = _facebook;

- (void)dealloc
{
  [_window release];
  [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  _facebook = [[Facebook alloc] initWithAppId:@"173832779412397" andDelegate:self];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"FBAccessTokenKey"]
       && [defaults objectForKey:@"FBExpirationDateKey"]) {
    _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
    _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
  }
  if (![_facebook isSessionValid]) {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"publish_actions",
                            nil];
    [_facebook authorize:permissions];
    [permissions release];
  }


  UIViewController *rootViewController = [[AKPlacesViewController alloc] initWithFacebook:_facebook];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
  [rootViewController release];
  self.window.rootViewController = navigationController;
  [navigationController release];
  [self.window makeKeyAndVisible];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [_facebook handleOpenURL:url];
}

#pragma mark FBSessionDelegate

- (void)fbDidLogin {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
  [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
  [defaults synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{

}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{

}

- (void)fbDidLogout
{

}

- (void)fbSessionInvalidated
{

}


@end
