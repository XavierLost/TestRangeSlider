//
//  MX_CircularSlider.h
//  scrollv
//
//  Created by eltx on 2017/12/19.
//  Copyright © 2017年 eltx. All rights reserved.
//

#import <UIKit/UIKit.h>

///角度转弧度
static inline double DegreesToRadians(double angle) { return M_PI * angle / 180.0; }
///弧度转角度
static inline double RadiansToDegrees(double angle) { return angle * 180.0 / M_PI; }

static inline CGPoint CGPointCenterRadiusAngle(CGPoint center, double radius, double angle) {
    return CGPointMake(center.x + radius * cos(angle), center.y + radius * sin(angle));
}

static inline CGFloat AngleBetweenPoints(CGPoint a, CGPoint b, CGPoint c) {
    return atan2(a.y - c.y, a.x - c.x) - atan2(b.y - c.y, b.x - c.x);
}

#define CircleInitialAngle (-M_PI_2)
#define Center CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))

struct Interval {
    CGFloat max;
    CGFloat min;
    NSInteger rounds;
};

typedef enum : NSUInteger {
    SelectedThumbNone = 0,
    SelectedThumbStart = 1,
    SelectedThumbEnd = 2,
} SelectedThumb;

typedef struct CG_BOXABLE Interval Interval;

@interface MX_CircularSlider : UIControl


/**
 * 圆线的宽度
 * 此属性的默认值为5
 */
@property(nonatomic, assign) IBInspectable CGFloat lineWidth;


/**
 * 最小值
 * 如果您更改了该属性的值，并且接收器的结束值低于新的最小值，则将调整端点值以自动匹配新的最小值
 * 此属性的默认值为0
 */
@property(nonatomic, assign) IBInspectable CGFloat minimumValue;

/**
 * 最大值
 * 如果更改此属性的值，并且接收器的结束值高于新的最大值，则将结束值自动调整以匹配新的最大值
 * 此属性的默认值为1
 */
@property(nonatomic, assign) IBInspectable CGFloat maximumValue;


/**
 * 圆半径
 */
@property(nonatomic, assign) CGFloat radius;

@end
