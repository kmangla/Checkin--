//
//  AKStory.h
//  Checkin++
//
//  Created by Albert Sun on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// This class encapsulates the data in each Activity Log story
@interface AKStory : NSObject
{
@private
  NSString *_actorName;
  NSString *_verbName;
  NSString *_placeName;
  NSString *_objectName;
}

// {actorName} {verbName} {objectName} at {placeName}
// Albert ate a sandwich at Quiznos
@property (nonatomic, copy) NSString *actorName;
@property (nonatomic, copy) NSString *verbName;
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, copy) NSString *objectName;

// This is the output, with highlighted colors
@property (nonatomic, readonly) NSAttributedString *storyString;

- (id)initWithActor:(NSString *)actorName
           verbName:(NSString *)verbName
          placeName:(NSString *)placeName
         objectName:(NSString *)objectName;

- (id)initWithJSON:(id)json;

@end
