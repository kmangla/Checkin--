//
//  AKStory.m
//  Checkin++
//
//  Created by Albert Sun on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKStory.h"
#import <CoreText/CoreText.h>

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
  // TODO: internationalize, also probably clean up using helper functions / categories

  NSMutableAttributedString *text = [[[NSMutableAttributedString alloc] init] autorelease];
  CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica"), 17, NULL);
  UIColor *blackColor = [UIColor blackColor];
  UIColor *blueColor = [UIColor blueColor];

  NSAttributedString *actorString = [[NSAttributedString alloc] initWithString:self.actorName
                                                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                (id)font, kCTFontAttributeName,
                                                                                blackColor.CGColor, kCTForegroundColorAttributeName,
                                                                                nil]];

  NSAttributedString *objectString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", self.objectName]
                                                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                 (id)font, kCTFontAttributeName,
                                                                                 blueColor.CGColor, kCTForegroundColorAttributeName,
                                                                                 nil]];

  // TODO: probably should say "from" for flew
  NSAttributedString *prepositionString = [[NSAttributedString alloc] initWithString:@"at "
                                                                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                      (id)font, kCTFontAttributeName,
                                                                                      blackColor.CGColor, kCTForegroundColorAttributeName,
                                                                                      nil]];

  NSAttributedString *placeString = [[NSAttributedString alloc] initWithString:self.placeName
                                                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                (id)font, kCTFontAttributeName,
                                                                                blueColor.CGColor, kCTForegroundColorAttributeName,
                                                                                nil]];

  NSAttributedString *periodString = [[NSAttributedString alloc] initWithString:@"."
                                                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                 (id)font, kCTFontAttributeName,
                                                                                 blackColor.CGColor, kCTForegroundColorAttributeName,
                                                                                 nil]];

  NSAttributedString *verbString = nil;

  if (self.verbName != nil && self.verbName.length > 0) {

    if (self.objectName != nil && self.objectName.length > 0) {

      // Note: fragile
      if (self.verbName.length > 2 &&
          [[self.verbName substringFromIndex:self.verbName.length - 3] isEqualToString:@" a"]) {
        // This doesn't always work - some y and acronyms sometimes should be prefaced with an
        char l = [[self.objectName lowercaseString] characterAtIndex:0];
        BOOL displayAn = (l == 'a' || l == 'e' || l == 'i' || l == 'o' || l == 'u');

        if (displayAn) {
          verbString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@n ", self.verbName]
                                                       attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   (id)font, kCTFontAttributeName,
                                                                   blackColor.CGColor, kCTForegroundColorAttributeName,
                                                                   nil]];
        } else {
          verbString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", self.verbName]
                                                       attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   (id)font, kCTFontAttributeName,
                                                                   blackColor.CGColor, kCTForegroundColorAttributeName,
                                                                   nil]];
        }
      } else {
        verbString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", self.verbName]
                                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 (id)font, kCTFontAttributeName,
                                                                 blackColor.CGColor, kCTForegroundColorAttributeName,
                                                                 nil]];
      }
    }
  } else {
    verbString = [[NSAttributedString alloc] initWithString:@" checked in at "
                                                 attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             (id)font, kCTFontAttributeName,
                                                             blackColor.CGColor, kCTForegroundColorAttributeName,
                                                             nil]];
  }

  // Construct string
  [text appendAttributedString:actorString];
  [text appendAttributedString:verbString];
  if (objectString != nil) {
    [text appendAttributedString:objectString];
  }
  [text appendAttributedString:prepositionString];
  [text appendAttributedString:placeString];
  [text appendAttributedString:periodString];

  // Clean up
  [actorString release];
  [verbString release];
  [objectString release];
  [prepositionString release];
  [placeString release];
  [periodString release];

  CFRelease(font);

  return text;
}

@end
