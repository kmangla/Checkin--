//
//  AKStory.m
//  Checkin++
//
//  Created by Albert Sun on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKStory.h"

@implementation AKStory
@synthesize actorName = _actorName;
@synthesize verbName = _verbName;
@synthesize placeName = _placeName;
@synthesize objectName = _objectName;

#pragma mark - Lifecycle
- (id)initWithActor:(NSString *)actorName
           verbName:(NSString *)verbName
          placeName:(NSString *)placeName
         objectName:(NSString *)objectName
{
  if ((self = [super init])) {
    _actorName = [actorName copy];
    _verbName = [verbName copy];
    _placeName = [placeName copy];
    _objectName = [objectName copy];
  }
  return self;
}

- (void)dealloc
{
  [_actorName release];
  [_verbName release];
  [_placeName release];
  [_objectName release];

  [super dealloc];
}

#pragma mark - Properties
- (NSAttributedString *)storyString
{
  // TODO: make this colorful, internationalize, make some fields optional

  NSString *constructedString = nil;

  if (self.verbName != nil && self.verbName.length > 0) {
    if (self.objectName != nil && self.objectName.length > 0) {

      // Note: fragile
      if (self.verbName.length > 2 &&
          [[self.verbName substringFromIndex:self.verbName.length - 3] isEqualToString:@" a"]) {
        // This doesn't always work - some y and acronyms sometimes should be prefaced with an
        char l = [[self.objectName lowercaseString] characterAtIndex:0];
        BOOL displayAn = (l == 'a' || l == 'e' || l == 'i' || l == 'o' || l == 'u');

        if (displayAn) {
          constructedString = [NSString stringWithFormat:@"%@ %@n %@ at %@",
                               self.actorName, self.verbName, self.objectName, self.placeName];
        } else {
          constructedString = [NSString stringWithFormat:@"%@ %@ %@ at %@",
                               self.actorName, self.verbName, self.objectName, self.placeName];
        }
      } else {
        constructedString = [NSString stringWithFormat:@"%@ %@ %@ at %@",
                             self.actorName, self.verbName, self.objectName, self.placeName];
      }
    } else {
      constructedString = [NSString stringWithFormat:@"%@ %@ at %@",
                           self.actorName, self.verbName, self.placeName];
    }
  } else {
    constructedString = [NSString stringWithFormat:@"%@ checked in at %@", self.actorName, self.placeName];
  }

  return [[[NSAttributedString alloc] initWithString:constructedString] autorelease];
}

@end
