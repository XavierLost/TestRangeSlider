//
//  MX_CircularSlider+draw1.h
//  scrollv
//
//  Created by eltx on 2017/12/21.
//  Copyright © 2017年 eltx. All rights reserved.
//

#import "MX_CircularSlider.h"

@interface MX_CircularSlider (draw1)


/**
 绘制圆

 @param radius 半径
 @param center 中心点
 @param lineWidth 线宽
 @param startAngle 开始弧度
 @param endAngle 结束弧度
 @param context 图形上下文
 @param clockwise clockwise
 */
- (void)mx_drawArcRadius:(CGFloat)radius
                  center:(CGPoint)center
               lineWidth:(CGFloat)lineWidth
              startAngle:(CGFloat)startAngle
                endAngle:(CGFloat)endAngle
                 context:(CGContextRef)context
               clockwise:(BOOL)clockwise;
/**
 绘制背景大圆
 
 @param context 图形上下文
 */
- (void)mx_drawBackgroundCircularSliderInContext:(CGContextRef)context;

/**
 绘制范围圆
 
 @param context 图形上下文
 */
- (void)mx_drawRangeCircularSliderInContext:(CGContextRef)context;


/**
 绘制范围可移动圆

 @param context 图形上下文
 @param startAngle 开始弧度
 @param endAngle 结束弧度
 */
- (void)mx_drawRangeFilledInContext:(CGContextRef)context
                         startAngle:(CGFloat)startAngle
                           endAngle:(CGFloat)endAngle;


/**
 绘制开始和结束 滑块和图片
 
 @param angle 角度
 @param imageStr 图片
 @param context 图形上下文
 @return 位置
 */
- (CGPoint)mx_drawStartOrEndThumbWithAngle:(CGFloat)angle
                                     imageStr:(NSString *)imageStr
                                 InContext:(CGContextRef)context;



/**
 从初始间隔到圆间隔的值

 @param value 角度
 @param oldInterval oldInterval
 @return 对应的弧度
 */
- (CGFloat)scaleToAngle:(CGFloat)value
            oldInterval:(Interval)oldInterval;



/**
 获取delta
 
 @param interval interval
 @param angle 角度
 @param oldValue 旧值
 @return 新值
 */
- (CGFloat)delta:(Interval)interval
           angle:(CGFloat)angle
        oldValue:(CGFloat)oldValue;






@end
