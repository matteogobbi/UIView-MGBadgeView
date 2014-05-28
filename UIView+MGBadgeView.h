//
//  UIView+MGBadgeView.h
//  purl
//
//  Created by Matteo Gobbi on 28/05/2014.
//  Copyright (c) 2014 Matteo Gobbi (Voxygen). All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, MGBadgePosition) {
    MGBadgePositionTopLeft,
    MGBadgePositionTopRight,
    MGBadgePositionBottomLeft,
    MGBadgePositionBottomRight,
    MGBadgePositionBest
};


@interface MGBadgeView : UIView

@property (nonatomic) MGBadgePosition position;

@property (nonatomic) NSInteger badgeValue;

@property(strong, nonatomic) UIFont *font;

@property(strong, nonatomic) UIColor *badgeColor;

@property(strong, nonatomic) UIColor *textColor;

@property(strong, nonatomic) UIColor *outlineColor;

@property (nonatomic) float outlineWidth;

@property (nonatomic) float minDiameter;

@property (nonatomic) BOOL displayIfZero;

@end


@interface UIView (MGBadgeView)

@property(nonatomic, readonly) MGBadgeView *badgeView;

@end
