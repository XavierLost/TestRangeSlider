//
//  TwoViewController.m
//  scrollv
//
//  Created by eltx on 2017/12/14.
//  Copyright © 2017年 eltx. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupUI];

}

- (void)setupUI {
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    path.lineWidth = 15;
//    path.lineCapStyle = kCGLineCapButt;
//    CGPoint center = self.view.center;
//    CGFloat radius = 50;
//    
//    CGFloat startAngle = -((float)M_PI)/7; 
//    CGFloat endAngle = ((float)M_PI)-startAngle ;
//    
//    [[UIColor grayColor] set];
//    
//    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
//    [path stroke];
//    [path closePath];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}


- (IBAction)close:(UIStoryboardSegue *)segue {
  
}

@end
