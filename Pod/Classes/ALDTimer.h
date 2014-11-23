//
//  ALDTimer.h
//  ALDTimer
//
//  Created by Jameel Khan on 23/11/2014.
//  Copyright (c) 2014 Jameel. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ALDTimer : UIControl



/**
 The current interval this contorl is displaying
 */
@property (nonatomic, assign) IBInspectable double interval;

/**
 The minimum interval this contorl should allow
 */
@property (nonatomic, assign) IBInspectable double minimumInterval;

/**
 The maximum interval this contorl should allow
 */
@property (nonatomic, assign) IBInspectable double maximumInterval;

/**
 The selected dot color on clock
 */
@property (nonatomic, strong) IBInspectable UIColor *backgroundColor;

/**
 The selected dot color on clock
 */
@property (nonatomic, strong) IBInspectable UIColor *selectedDotColor;

/**
 The unSelected dot UIColor on clock
 */
@property (nonatomic, strong) IBInspectable UIColor *unSelectedDotColor;

/**
 The dot size on timer
 */
@property (nonatomic, assign) IBInspectable float dotRadius;

/**
 The decrement of percentage of dot on each circle
 */
@property (nonatomic, assign) IBInspectable float decreaseSizeBy;

/**
 The the spacing between each circle
 */
@property (nonatomic, assign) IBInspectable float circleDistance;






@end
