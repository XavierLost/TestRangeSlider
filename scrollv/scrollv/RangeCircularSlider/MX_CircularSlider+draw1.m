//
//  MX_CircularSlider+draw1.m
//  scrollv
//
//  Created by eltx on 2017/12/21.
//  Copyright © 2017年 eltx. All rights reserved.
//

#import "MX_CircularSlider+draw1.h"

@implementation MX_CircularSlider (draw1)

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
               clockwise:(BOOL)clockwise {
    
    // 开始绘制
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    // 设置线宽
    CGContextSetLineWidth(context, lineWidth);
    // 线条的转角的样式为圆角
    CGContextSetLineCap(context,kCGLineCapRound);
    // 线条的转角的样式为圆角
    CGContextSetLineJoin(context,kCGLineJoinRound);
    // 画圆
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, clockwise);
    CGContextMoveToPoint(context,center.x, center.y);
    // 根据路径填充
    CGContextDrawPath(context, kCGPathFillStroke);
    // pop
    UIGraphicsPopContext();
    
    
}

/**
 绘制背景大圆
 
 @param context 图形上下文
 */
- (void)mx_drawBackgroundCircularSliderInContext:(CGContextRef)context {
    
    // 填充色和边框色
    [[UIColor clearColor] setFill];
    [[UIColor colorWithRed:42.0/255.0f green:42.0/255.0f blue:42.0/255.0f alpha:1] setStroke];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(center.x, center.y);
    radius -= self.lineWidth/2;
    [self mx_drawArcRadius:radius center:center lineWidth:self.lineWidth startAngle:0 endAngle:2*M_PI context:context clockwise:NO];
}

/**
 绘制范围圆
 
 @param context 图形上下文
 */
- (void)mx_drawRangeCircularSliderInContext:(CGContextRef)context {
    
    // 添加边框色
    [[UIColor clearColor] setFill];
    [[UIColor colorWithRed:70.0/255.0f green:69.0/255.0f blue:69.0/255.0f alpha:1] setStroke];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // 半径
    CGFloat radius = MIN(center.x, center.y) - (self.lineWidth-2)/2;
    // 圆的开始位置
    CGFloat arcStartAngle = DegreesToRadians(270 + 50 / 2.0);
    // 圆的结束位置
    CGFloat arcEndAngle = DegreesToRadians(270 - 50 / 2.0);
    
    arcStartAngle = -M_PI_2 + 0.4;
    arcEndAngle = 3*M_PI_2 - 0.4;
    NSLog(@"结束点%lf,%lf",RadiansToDegrees(arcEndAngle),arcEndAngle - arcStartAngle);
    // 圆
    [self mx_drawArcRadius:radius center:center lineWidth:self.lineWidth-12 startAngle:arcStartAngle endAngle:arcEndAngle context:context clockwise:NO];
}


/**
 绘制范围可移动圆
 
 @param context 图形上下文
 @param startAngle 开始弧度
 @param endAngle 结束弧度
 */
- (void)mx_drawRangeFilledInContext:(CGContextRef)context
                         startAngle:(CGFloat)startAngle
                           endAngle:(CGFloat)endAngle{
    
    
    // 添加边框色
    [[UIColor clearColor] setFill];
    [[UIColor orangeColor] setStroke];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // 半径
    CGFloat radius = MIN(center.x, center.y) - (self.lineWidth-2)/2;
    // 圆
    [self mx_drawArcRadius:radius center:center lineWidth:self.lineWidth-12 startAngle:startAngle endAngle:endAngle context:context clockwise:NO];
    
}


/**
 绘制开始和结束 滑块和图片
 
 @param angle 角度
 @param imageStr 图片
 @param context 图形上下文
 @return 位置
 */
- (CGPoint)mx_drawStartOrEndThumbWithAngle:(CGFloat)angle
                                  imageStr:(NSString *)imageStr
                                 InContext:(CGContextRef)context {
    [[UIColor redColor] setFill];
    [[UIColor redColor] setStroke];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));;
    // 半径
    CGFloat radius = MIN(center.x, center.y) - (self.lineWidth-2)/2;
    //获取位置
    CGPoint thumbOrigin = CGPointCenterRadiusAngle(center, radius, angle);
    //圆
    [self mx_drawArcRadius:13 center:thumbOrigin lineWidth:4 startAngle:0 endAngle:M_PI*2 context:context clockwise:YES];
    [self drawThumbImage:[UIImage imageNamed:imageStr] thumbOrigin:thumbOrigin imageWidth:13 context:context];
    
    return thumbOrigin;
}



/**
 从初始间隔到圆间隔的值
 
 @param value 角度
 @param oldInterval oldInterval
 @return 对应的弧度
 */
- (CGFloat)scaleToAngle:(CGFloat)value oldInterval:(Interval)oldInterval; {
    
    Interval angleInterval = {.max = 2*M_PI, .min = 0, .rounds = 1};

    CGFloat angle = [self scaleValue:value fromInterval:oldInterval toInterval: angleInterval];
    
    return angle;
    
}

//将值从一个区间缩放到另一个区间
- (CGFloat)scaleValue:(CGFloat)aValue fromInterval:(Interval)fromInterval  toInterval:(Interval)toInterval {
    
    // 开始范围
    CGFloat sourceRange = (fromInterval.max-fromInterval.min)/fromInterval.rounds;
    // 目的
    CGFloat destinationRange = (toInterval.max-toInterval.min)/toInterval.rounds;
    
    CGFloat scaledValue = fmod((fromInterval.min + (aValue - fromInterval.min)), sourceRange);
    
    CGFloat newValue = ((scaledValue - fromInterval.min) * destinationRange / sourceRange) + toInterval.min;
    
    return newValue;
}



/**
 获取delta
 
 @param interval interval
 @param angle 角度
 @param oldValue 旧值
 @return 新值
 */
- (CGFloat)delta:(Interval)interval
           angle:(CGFloat)angle
        oldValue:(CGFloat)oldValue {
    
    //
    Interval angleIntreval = {.max = 2*M_PI, .min = 0, .rounds = 1};
    // 
    CGFloat oldAngle = [self scaleToAngle:oldValue oldInterval:interval];
    //
    CGFloat deltaAngle = [self angle:oldAngle beta:angle];
    //
    CGFloat scaleValue = [self scaleValue:deltaAngle fromInterval:angleIntreval toInterval:interval];
    
    return scaleValue;
}

- (CGFloat)angle:(CGFloat)alpha beta:(CGFloat)beta {
   
    CGFloat halfValue = M_PI;
    CGFloat offset = alpha >= halfValue ? M_PI*2 - alpha : -alpha;
    CGFloat offsetBeta = beta + offset;
    if (offsetBeta > halfValue) {
        return offsetBeta - M_PI*2;
    }else {
        return offsetBeta;
    }
}


// 绘制图片
- (CGPoint)drawThumbImage:(UIImage *)image thumbOrigin:(CGPoint)thumbOrigin imageWidth:(CGFloat)imageWidth context:(CGContextRef)context {
    // 开始绘制
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGSize imageSize = image.size;
    CGRect rect = CGRectMake(thumbOrigin.x-(imageSize.width/2), thumbOrigin.y - (imageSize.height / 2), imageSize.width, imageSize.height);
    [image drawInRect:rect];
    UIGraphicsPopContext();
    return thumbOrigin;
}

@end
