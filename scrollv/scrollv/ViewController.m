//
//  ViewController.m
//  scrollv
//
//  Created by eltx on 2017/12/13.
//  Copyright © 2017年 eltx. All rights reserved.
//

#import "ViewController.h"
#import "FXBlurView.h"


@interface ViewController ()<UIScrollViewDelegate>
 
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//headerView
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property(nonatomic, strong) UIImageView *headerImageView;
@property(nonatomic, strong) UIImageView *blurImageView;
@end

CGFloat offset_HeaderStop = 40.0;       // 头部视图停止的位置
CGFloat offset_B_LabelHeader = 95.0;    // 
CGFloat distance_W_LabelHeader = 35.0;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupUI];
}

- (void)setupUI {
    // Header - Image
    self.headerImageView = [[UIImageView alloc]initWithFrame:self.headerView.bounds];
    self.headerImageView.image = [UIImage imageNamed:@"header_bg"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headerView insertSubview:self.headerImageView belowSubview:self.headerLabel];
    
    // Header - Blurred Image
    self.blurImageView = [[UIImageView alloc]initWithFrame:self.headerView.bounds];
    self.blurImageView.image = [[UIImage alloc] blurredImageWithRadius:10 iterations:20 tintColor:[UIColor clearColor]];
    self.blurImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurImageView.alpha = 0.0;
    [self.headerView insertSubview:self.blurImageView belowSubview:self.headerLabel];
    
    self.headerView.clipsToBounds = YES;
    
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.y;
    CATransform3D iconTransform = CATransform3DIdentity;
    CATransform3D headerTransform = CATransform3DIdentity;
    CGFloat header_hight = self.headerView.bounds.size.height;
    CGFloat icon_height = self.iconImage.bounds.size.height;
    // 下拉 -1,-2 ...
    if (offset < 0) {
        
        CGFloat header_scaleFactor = -(offset) / header_hight;
        CGFloat header_variation = ((header_hight * (1.0 + header_scaleFactor)) - header_hight) / 2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, header_variation, 0);
        headerTransform= CATransform3DScale(headerTransform, 1.0 + header_scaleFactor, 1.0 + header_scaleFactor, 0);
        self.headerView.layer.transform = headerTransform;
    NSLog(@"%lf**%lf**%lf",header_scaleFactor,header_variation,fabs(offset));
    }else {
    // 上拉 1,2 ...
        headerTransform = CATransform3DTranslate(headerTransform, 0, MAX(-offset_HeaderStop, -offset), 0);
        
        // Label
        CATransform3D label_Transform = CATransform3DMakeTranslation(0, MAX(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0);
        self.headerLabel.layer.transform = label_Transform;
        
        // Icon
        CGFloat icon_scaleFactor = MIN(offset_HeaderStop, offset) / icon_height / 1.4;
        CGFloat icon_variation = icon_height * (1 + icon_scaleFactor) - icon_height/2.0;
        iconTransform = CATransform3DTranslate(iconTransform, 0, icon_variation, 0);
        iconTransform = CATransform3DScale(iconTransform, 1.0-icon_scaleFactor, 1.0-icon_scaleFactor, 0);
        
        // 到距离
        if (offset <= offset_HeaderStop) {
            if (self.iconImage.layer.zPosition < self.headerView.layer.zPosition) {
                self.headerView.layer.zPosition = 0;
            }
            
        }else {
            if (self.iconImage.layer.zPosition >= self.headerView.layer.zPosition) {
                self.headerView.layer.zPosition = 2;
            }
        }
        
    }
    
    self.headerView.layer.transform = headerTransform;
    self.iconImage.layer.transform = iconTransform;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
