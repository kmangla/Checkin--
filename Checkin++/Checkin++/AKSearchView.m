//
//  AKSearchView.m
//  Checkin++
//
//  Created by Albert Sun on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKSearchView.h"

static const CGFloat kTextFieldInset = 8;

@implementation AKSearchView
@synthesize textField = _textField;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self addSubview:_textField];
    self.backgroundColor = [UIColor lightGrayColor];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  }
  return self;
}

- (void)dealloc
{
  [_textField release];

  [super dealloc];
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  _textField.frame = CGRectInset(self.bounds, kTextFieldInset, kTextFieldInset);
}

@end
