//
//  AKPlace.m
//  Checkin++
//
//  Created by Albert Sun on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKPlace.h"

@implementation AKPlace
@synthesize name = _name;
@synthesize street = _street;
@synthesize fbid = _fbid;


- (id)initWithJSON:(id) json {
  if (self = [super init]) {
    _name = [[json objectForKey:@"name"] copy];
    _fbid = [[json objectForKey:@"id"] copy];
    _street = [[[json objectForKey:@"location"] objectForKey:@"street"] copy];
  }
  return self;
}

- (void) dealloc {
  [_name release];
  [_street release];
  [_fbid release];

  [super dealloc];
}

@end
