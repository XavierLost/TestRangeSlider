//
//  View2Controller.m
//  scrollv
//
//  Created by eltx on 2017/12/19.
//  Copyright © 2017年 eltx. All rights reserved.
//

#import "View2Controller.h"
#import "scrollv-Swift.h"
#import "MX_CircularSlider.h"

@interface View2Controller ()

@end

@implementation View2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)setup {
   
//    RangeCircularSlider *slide = [[RangeCircularSlider alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
//    slide.center = self.view.center;
//    slide.startThumbImage = [UIImage imageNamed:@"Bedtime"];
//    slide.endThumbImage = [UIImage imageNamed:@"Bedtime"];
//    slide.maximumValue = 1;
//    slide.startPointValue = 270;
//    slide.endPointValue = 230;
//    [self.view addSubview:slide];
    
    MX_CircularSlider *slide = [[MX_CircularSlider alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    slide.lineWidth = 50;
 
    slide.center = self.view.center;
    [self.view addSubview:slide];
}
@end
