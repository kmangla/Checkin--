//
//  AKItem.m
//  Checkin++
//
//  Created by Albert Sun on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKItem.h"

@implementation AKItem
@synthesize itemId = _itemId;
@synthesize pageId = _pageId;
@synthesize name = _name;
@synthesize questionType = _questionType;

- (id)initWithJSON:(id)json
{
  if ((self = [super init])) {
    _itemId = [[json objectForKey:@"item_id"] copy];
    _pageId = [[json objectForKey:@"page_id"] copy];
    _name = [[json objectForKey:@"name"] copy];
    _questionType = [[json objectForKey:@"question_type"] copy];
  }
  return self;
}

- (void)dealloc
{
  [_itemId release];
  [_pageId release];
  [_name release];
  [_questionType release];

  [super dealloc];
}

@end
