//
//  AKStoryCell.m
//  Checkin++
//
//  Created by Albert Sun on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKStoryCell.h"
#import <CoreText/CoreText.h>

@implementation AKStoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    _textLayer = [[CATextLayer alloc] init];
    _textLayer.anchorPoint = CGPointZero;
    _textLayer.truncationMode = kCATruncationEnd;
    _textLayer.wrapped = YES;
    [self.contentView.layer addSublayer:_textLayer];

    _textPadding = UIEdgeInsetsMake(5, 5, 5, 5);
  }
  return self;
}

#pragma mark - Properties
- (NSAttributedString *)storyString
{
  return _textLayer.string;
}

- (void)setStoryString:(NSAttributedString *)storyString
{
  _textLayer.string = storyString;
}

- (CGFloat)_boundingHeightForWidth:(CGFloat)inWidth withAttributedString:(NSAttributedString *)attributedString {
  CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (CFMutableAttributedStringRef) attributedString);
  CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(inWidth, CGFLOAT_MAX), NULL);
  CFRelease(framesetter);
  return suggestedSize.height;
}

- (void)_layoutTextLayer
{
  CGRect availableFrame = self.contentView.bounds;
  availableFrame.origin.x += self.imageView.bounds.size.width;
  availableFrame.size.width -= availableFrame.origin.x;

  CGSize availableSize = availableFrame.size;
  CGPoint textPosition = CGPointMake(_textPadding.left, _textPadding.top);

  // small padding on each side
  availableSize.width -= _textPadding.left + _textPadding.right;
  availableSize.height -= _textPadding.top + _textPadding.bottom;

  // approximate size with NSString sizeWithFont
  CGFloat textHeight = [self _boundingHeightForWidth:availableSize.width withAttributedString:_textLayer.string];

  // position vertically
  textPosition.y = (availableSize.height - textHeight) / 2;

  textPosition.y += availableFrame.origin.y;
  textPosition.x += availableFrame.origin.x;

  textPosition.y = floorf(textPosition.y);
  textPosition.x = floorf(textPosition.x);

  // done
  _textLayer.bounds = CGRectMake(0, 0, availableSize.width, textHeight);
  _textLayer.position = textPosition;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
  [super layoutSublayersOfLayer:layer];

  if (layer == self.layer) {
    [self _layoutTextLayer];
  }
}

@end
