//
//  CHcir_Slider.h
//  cir_Slider
//
//  Created by summer_ness on 16/8/18.
//  Copyright © 2016年 summer_ness. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHcirsliderDelegate <NSObject>
@optional
- (void)minIntValueChanged:(CGFloat)minIntValue;

- (void)maxIntValueChanged:(CGFloat)maxIntValue;

@end




@interface CHcir_Slider : UIControl

// 开始角度
@property (nonatomic, assign)  CGFloat startAngle;
// 角度距离
@property (nonatomic, assign)  CGFloat cutoutAngle;
// 左边的进度(Max)
@property (nonatomic, assign)  CGFloat progress;
// 右边的进度(Min)
@property (nonatomic, assign)  CGFloat progress1;
// (圆)线宽
@property (nonatomic, assign)  CGFloat lineWidth;
// 范围圆的背景颜色
@property (nonatomic, strong)  UIColor *guideLineColor;
// 右边线的颜色
@property (nonatomic, strong)  UIColor *guideLineColor1;

@property (nonatomic, strong)  UIColor *guidecoverColor;

@property (nonatomic, strong)  UIColor *guidecoverColor1;
//
@property (nonatomic, assign)  CGFloat handleOutSideRadius;
//
@property (nonatomic, assign)  CGFloat handleInSideRadius;
// 代理
@property (weak, nonatomic)  id<CHcirsliderDelegate> delegate;

@end
