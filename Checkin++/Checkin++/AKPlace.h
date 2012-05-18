//
//  AKPlace.h
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKPlace : NSObject {
  NSString *_fbid;
  NSString *_name;
  NSString *_street;
}

- (id) initWithJSON:(id) json;

@property(nonatomic, retain) NSString* fbid;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* street;

@end
