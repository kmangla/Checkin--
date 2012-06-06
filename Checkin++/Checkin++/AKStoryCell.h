//
//  AKStoryCell.h
//  Checkin++
//
//  Created by Albert Sun on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AKStoryCell : UITableViewCell
{
  CATextLayer *_textLayer;
  UIEdgeInsets _textPadding;
}

@property (nonatomic, copy) NSAttributedString *storyString;

@end
