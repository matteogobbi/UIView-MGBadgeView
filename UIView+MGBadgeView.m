//
//  UIView+MGBadgeView.m
//  purl
//
//  Created by Matteo Gobbi on 28/05/2014.
//  Copyright (c) 2014 Matteo Gobbi (Voxygen). All rights reserved.
//

#import "UIView+MGBadgeView.h"
#import <objc/runtime.h>

void MGFillRoundedRect(CGContextRef __nullable context, CGRect rect, CGFloat radius) {
    CGFloat theRadius = MAX(radius, rect.size.height/2.0);
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, theRadius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, theRadius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, theRadius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, theRadius);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@implementation MGBadgeView

static float const kMGBadgeViewInnerSpaceFromBorder = 7.0;
static int const kMGBadgeViewTag = 9876;

#define BADGE_SIDE_OFFSET kMGBadgeViewInnerSpaceFromBorder + _outlineWidth
#define BADGE_TOTAL_OFFSET BADGE_SIDE_OFFSET * 2.0

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        _font = [UIFont boldSystemFontOfSize:13.0];
        _badgeColor = [UIColor blueColor];
        _textColor = [UIColor whiteColor];
        _outlineColor = [UIColor whiteColor];
        _outlineWidth = 2.0;
        _minDiameter = 25.0;
        _position = MGBadgePositionBest;
        _displayIfZero = NO;
        _horizontalOffset = 0.0;
        _verticalOffset = 0.0;
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        self.tag = kMGBadgeViewTag;
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSString *stringToDraw = nil;
    if(!_badgeImage) {
        if(_badgeText) {
            stringToDraw = _badgeText;
        } else if(_badgeValue != 0 || _displayIfZero) {
            stringToDraw = [NSString stringWithFormat:@"%ld", (long)_badgeValue];
        }
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [_outlineColor set];
    MGFillRoundedRect(context, CGRectInset(rect, 1.0, 1.0), 0);
    
    [_badgeColor set];
    MGFillRoundedRect(context, CGRectInset(rect, _outlineWidth + 1.0, _outlineWidth + 1.0), 0);
    
    if(_badgeImage) {
        CGRect imageRect = CGRectMake((rect.size.width - _badgeImage.size.width)/2.0, (rect.size.height - _badgeImage.size.height)/2.0, _badgeImage.size.width, _badgeImage.size.height);
        [_badgeImage drawInRect:imageRect];
    }
    
    if(stringToDraw) {
        CGSize numberSize = [stringToDraw sizeWithAttributes:@{NSFontAttributeName: _font}];
        
        [_textColor set];
        NSMutableParagraphStyle *paragrapStyle = [NSMutableParagraphStyle new];
        paragrapStyle.lineBreakMode = NSLineBreakByClipping;
        paragrapStyle.alignment = NSTextAlignmentCenter;
        
        CGRect lblRect = CGRectMake(rect.origin.x, (rect.size.height / 2.0) - (numberSize.height / 2.0), rect.size.width, numberSize.height);
    
        [stringToDraw drawInRect:lblRect withAttributes:@{
                                                          NSFontAttributeName : _font,
                                                          NSParagraphStyleAttributeName : paragrapStyle,
                                                          NSForegroundColorAttributeName : _textColor
                                                          }];
    }
}

#pragma mark - Properties accessor methods

- (void)setBadgeValue:(NSInteger)badgeValue {
    if(_badgeValue != badgeValue) {
        _badgeValue = badgeValue;
        _badgeText = nil;
        _badgeImage = nil;
        
        if(badgeValue != 0 || _displayIfZero) {
            [self mg_updateBadgeViewSize];
        
            if(_position == MGBadgePositionBest)
                [self mg_updateBadgeViewPosition];
        
        } else {
            self.frame = CGRectZero;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeText:(NSString *)badgeText {
    if(_badgeText != badgeText) {
        _badgeText = badgeText;
        _badgeValue = 0;
        _badgeImage = nil;
        
        if(_badgeText.length > 0) {
            [self mg_updateBadgeViewSize];
            if(_position == MGBadgePositionBest)
                [self mg_updateBadgeViewPosition];
        } else {
            self.frame = CGRectZero;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeImage:(UIImage *)badgeImage {
    if(_badgeImage != badgeImage) {
        _badgeImage = badgeImage;
        _badgeText = nil;
        _badgeValue = 0;
        
        if(badgeImage) {
            [self mg_updateBadgeViewSize];
            if(_position == MGBadgePositionBest) {
                [self mg_updateBadgeViewPosition];
            }
        } else {
            self.frame = CGRectZero;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)setPosition:(MGBadgePosition)position {
    if(_position != position) {
        _position = position;
        [self mg_updateBadgeViewPosition];
        [self setNeedsDisplay];
    }
}

- (void)setMinDiameter:(float)minDiameter {
    if (_minDiameter != minDiameter) {
        _minDiameter = minDiameter;
        
        if(_position == MGBadgePositionBest)
            [self mg_updateBadgeViewPosition];
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeColor:(UIColor *)badgeColor {
    if(_badgeColor != badgeColor) {
        _badgeColor = badgeColor;
        [self setNeedsDisplay];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if(_textColor != textColor) {
        _textColor = textColor;
        [self setNeedsDisplay];
    }
}

- (void)setOutlineColor:(UIColor *)outlineColor {
    if(_outlineColor != outlineColor) {
        _outlineColor = outlineColor;
        [self setNeedsDisplay];
    }
}

- (void)setOutlineWidth:(float)outlineWidth {
    if(_outlineWidth != outlineWidth) {
        _outlineWidth = outlineWidth;
        
        if(_position == MGBadgePositionBest)
            [self mg_updateBadgeViewPosition];
        
        [self setNeedsDisplay];
    }
}

- (void)setFont:(UIFont *)font {
    if(_font != font) {
        _font = font;
        
        [self mg_updateBadgeViewSize];
        
        if(_position == MGBadgePositionBest)
            [self mg_updateBadgeViewPosition];

        
        [self setNeedsDisplay];
    }
}

- (void)setDisplayIfZero:(BOOL)displayIfZero {
    if(_displayIfZero != displayIfZero) {
        _displayIfZero = displayIfZero;
        
        if(_badgeValue == 0) {
            if(_displayIfZero) {
                [self mg_updateBadgeViewSize];
                
                if(_position == MGBadgePositionBest)
                    [self mg_updateBadgeViewPosition];
            } else {
                self.frame = CGRectZero;
            }
        }
    }
}

#pragma mark - Private methods

- (void)mg_updateBadgeViewSize {
    //Calculate badge bounds
    CGSize contentSize = CGSizeZero;
    if (_badgeImage) {
        // assume images should always be rendered in a circle, hence ensure content is square for equal padding
        CGFloat imageLongestSide = MAX(_badgeImage.size.width, _badgeImage.size.height);
        contentSize = CGSizeMake(imageLongestSide, imageLongestSide);
    } else if(_badgeText) {
        contentSize = [(_badgeText ?: @"") sizeWithAttributes:@{NSFontAttributeName: _font}];
    } else {
        contentSize = [[NSString stringWithFormat:@"%ld", (long)_badgeValue] sizeWithAttributes:@{NSFontAttributeName: _font}];
    }
    
    float badgeHeight = ceilf(MAX(BADGE_TOTAL_OFFSET + contentSize.height, _minDiameter));
    float badgeWidth = ceilf(MAX(badgeHeight, BADGE_TOTAL_OFFSET + contentSize.width));

    [self setBounds:CGRectMake(0, 0, badgeWidth, badgeHeight)];
}

- (void)mg_updateBadgeViewPosition {
    CGRect superviewFrame = self.superview.frame;
    CGSize badgeSize = self.bounds.size;
    
    MGBadgePosition position = _position;
    
    //Set the best position before
    if(position == MGBadgePositionBest) {
        CGPoint topRightInWindow = [self.superview convertPoint:CGPointMake(superviewFrame.origin.x + superviewFrame.size.width + (badgeSize.width / 2.0), -(badgeSize.height / 2.0)) fromView:nil];
        
        CGSize appFrameSize = [[UIScreen mainScreen] applicationFrame].size;
        
        if(topRightInWindow.x > appFrameSize.width) {
            position = (topRightInWindow.y < appFrameSize.height) ? MGBadgePositionBottomLeft : MGBadgePositionTopLeft;
        } else {
            position = (topRightInWindow.y < appFrameSize.height) ? MGBadgePositionBottomRight : MGBadgePositionTopRight;
        }
    }
    
    switch (position) {
        case MGBadgePositionCenterLeft: {
            self.center = CGPointMake(_horizontalOffset, superviewFrame.size.height / 2 + _verticalOffset);
            break;
        }
        case MGBadgePositionCenterRight: {
            self.center = CGPointMake(superviewFrame.size.width + _horizontalOffset, superviewFrame.size.height / 2 + _verticalOffset);
            break;
        }
        case MGBadgePositionTopRight: {
            self.center = CGPointMake(superviewFrame.size.width + _horizontalOffset, _verticalOffset);
            break;
        }
        case MGBadgePositionTopLeft: {
            self.center = CGPointMake(_horizontalOffset, _verticalOffset);
            break;
        }
        case MGBadgePositionBottomRight: {
            self.center = CGPointMake(superviewFrame.size.width + _horizontalOffset, superviewFrame.size.height + _verticalOffset);
            break;
        }
        case MGBadgePositionBottomLeft: {
            self.center = CGPointMake(_horizontalOffset, superviewFrame.size.height + _verticalOffset);
            break;
        }
        default:
            break;
    }
}

@end



static const char *kMGBadgeViewPropertyKey = "kMGBadgeViewPropertyKey";

@implementation UIView (MGBadgeView)

- (void)setBadgeView:(MGBadgeView *)badgeView {
    objc_setAssociatedObject(self, kMGBadgeViewPropertyKey, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MGBadgeView *)badgeView {
    
    MGBadgeView *badgeView = objc_getAssociatedObject(self, kMGBadgeViewPropertyKey);
    
    if (!badgeView) {
        self.badgeView = [[MGBadgeView alloc] initWithFrame:CGRectZero];
        badgeView = objc_getAssociatedObject(self, kMGBadgeViewPropertyKey);
        [self addSubview:badgeView];
    }
    
    return badgeView;
}

@end


