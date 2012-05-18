//
//  AKItem.h
//  Checkin++
//
//  Created by Albert Sun on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKItem : NSObject
{
  NSString *_itemId;
  NSString *_pageId;
  NSString *_name;
  NSString *_questionType;
}

- (id)initWithJSON:(id)json;

@property(nonatomic, retain) NSString* itemId;
@property(nonatomic, retain) NSString* pageId;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* questionType;

@end
