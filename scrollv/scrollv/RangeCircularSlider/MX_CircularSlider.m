//
//  MX_CircularSlider.m
//  scrollv
//
//  Created by eltx on 2017/12/19.
//  Copyright © 2017年 eltx. All rights reserved.
//

#import "MX_CircularSlider.h"
//#import "MX_CircularSlider+Draw.h"
#import "MX_CircularSlider+draw1.h"


@interface MX_CircularSlider()

@property(nonatomic, assign) CGPoint startPoint;
@property(nonatomic, assign) CGPoint endPoint;
@property(nonatomic, assign) SelectedThumb selectedThumb;
//@property(nonatomic, assign) BOOL isEndThumb;
@property(nonatomic, assign) CGFloat startPointValue;
@property(nonatomic, assign) CGFloat endPointValue;
@property(nonatomic, assign) CGPoint startThumbCenter;
@property(nonatomic, assign) CGPoint endThumbCenter;
@end
IB_DESIGNABLE
@implementation MX_CircularSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}


#pragma mark - 初始化
- (void)setup {
    self.startPointValue = 0;
    self.endPointValue = 8;
}



#pragma mark - 重写最小值set方法
- (void)setMinimumValue:(CGFloat)minimumValue {
    _minimumValue = minimumValue;
    if (self.endPointValue < minimumValue) {
        self.endPointValue = minimumValue;
    }
}

#pragma mark - 重写最大值set方法
- (void)setMaximumValue:(CGFloat)maximumValue {
    _maximumValue = maximumValue;
    if (self.endPointValue > maximumValue) {
        self.endPointValue = maximumValue;
    }
}

- (void)setStartPointValue:(CGFloat)startPointValue {
    _startPointValue = startPointValue;

//    if (startPointValue < 0.01) {
//        startPointValue = 0.01;
//    }else if(startPointValue > 35.99) {
//        startPointValue = 35.99;
//    }
    [self setNeedsDisplay];
}


#pragma mark - 重写结束圆的位置set方法
- (void)setEndPointValue:(CGFloat)endPointValue {
    _endPointValue = endPointValue;
    
//    if (endPointValue > 35.99) {
//        endPointValue = 35.99;
//    }else if(endPointValue < 0.01) {
//        endPointValue = 0.01;
//    }
    [self setNeedsDisplay];
}



- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

#pragma mark - 绘制图片
- (void)drawRect:(CGRect)rect {
    
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 背景大圆
    [self mx_drawBackgroundCircularSliderInContext:context];
    // 范围圆
    [self mx_drawRangeCircularSliderInContext:context];

    // 范围移动圆
    Interval interval = {.max = 36, .min = 0, .rounds = 1};
    // 获取开始的角度
    CGFloat startAngle = [self scaleToAngle:self.startPointValue oldInterval:interval];
   
    
    // 获取结束的角度
    CGFloat endAngle = [self scaleToAngle:self.endPointValue oldInterval:interval];
    
     NSLog(@"startAngle = %lf,endAngle = %lf",RadiansToDegrees(startAngle),RadiansToDegrees(endAngle));
    
    startAngle -= M_PI_2 + 0.4;
    endAngle -= M_PI_2 + 0.4;
    
    //移动圆
    [self mx_drawRangeFilledInContext:context startAngle:startAngle endAngle:endAngle];
    // 结束滑块
    self.endThumbCenter = [self mx_drawStartOrEndThumbWithAngle:endAngle imageStr:@"AutomaticBidding_start" InContext:context];
    
    // 开始滑块
    self.startThumbCenter = [self mx_drawStartOrEndThumbWithAngle:startAngle imageStr:@"AutomaticBidding_end" InContext:context];
}


#pragma mark - 是否要追踪点击事件并进行事件事件的处理
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
  
    [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
    CGPoint touchPosition = [touch locationInView:self];
    if ([self isThumbWithThumbCenter:self.startThumbCenter touchPoint:touchPosition]) {
        return self.selectedThumb = SelectedThumbStart;
    }else if ([self isThumbWithThumbCenter:self.endThumbCenter touchPoint:touchPosition]) {
        return self.selectedThumb = SelectedThumbEnd;
    }else {
        return self.selectedThumb = SelectedThumbNone;
    }
}

#pragma mark - 拖动后的事件追踪并进行事件事件的处理
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event{
 
    if (self.selectedThumb == SelectedThumbNone) {
        return NO;
    }
    
    
    CGFloat oldValue = self.selectedThumb == SelectedThumbStart ? self.startPointValue : self.endPointValue;
    CGPoint touchPosition = [touch locationInView:self];
    CGPoint center = Center;
    CGPoint startPoint = CGPointMake(center.x, 0);
    
    CGFloat value = [self newValue:oldValue touchPosition:touchPosition startPosition:startPoint];
    
    if (self.selectedThumb == SelectedThumbStart) {
        self.startPointValue = value;
    }else {
        self.endPointValue = value;
    }
    
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}


- (CGFloat)newValue:(CGFloat)oldValue touchPosition:(CGPoint)touchPosition startPosition:(CGPoint)startPosition {
    
    
    CGFloat angle = AngleBetweenPoints(touchPosition, startPosition, Center);
   
    Interval interval = {.max = 36, .min = 0, .rounds = 1};
    
    CGFloat deltaValue = [self delta:interval angle:angle oldValue:oldValue];
    CGFloat newValue = oldValue + deltaValue;
    
    CGFloat range = 36 - 0;
    
    if (newValue > 36) {
        newValue -= range;
    }else if (newValue < 0){
        newValue += range;
    }
    NSLog(@"newValue = %lf",newValue);
    return newValue;
}





#pragma mark - 检查触点是否影响
- (BOOL)isThumbWithThumbCenter:(CGPoint)thumbCenter touchPoint:(CGPoint)touchPoint {
    
    CGRect rect = CGRectMake(thumbCenter.x-13, thumbCenter.y-13, 13*2, 13*2);
    if (CGRectContainsPoint(rect, touchPoint)) {
        //包含
        return YES;
    }
    return NO;
    //弧度转角度()
//    CGFloat angle = RadiansToDegrees(AngleBetweenPoints(touchPoint,thumbCenter , Center));
//    BOOL isInside = fabs(angle) < 15 || fabs(angle) > 345;
//    return isInside;
}


@end
