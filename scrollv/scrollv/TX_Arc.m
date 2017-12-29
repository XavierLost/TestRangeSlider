//
//  TX_Arc.m
//  scrollv
//
//  Created by eltx on 2017/12/14.
//  Copyright © 2017年 eltx. All rights reserved.
//

#import "TX_Arc.h"
//弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI )
#define SQR(x)            ( (x) * (x) )
#define Cgpoint     CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
#define Cradius  self.bounds.size.height/2-30
CGFloat lineWidth = 30.0;

@interface TX_Arc ()
@property(nonatomic, strong) CAShapeLayer *progressLayer;
@property(nonatomic,strong)UIImageView *startImageView;
@property(nonatomic,strong)UIImageView *endImageView;
@end
@implementation TX_Arc


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (void)setupUI {
    
   
    CGFloat wi = self.bounds.size.width;
    CGFloat hi = self.bounds.size.height;
    CGFloat startAngle = 1.62 * M_PI;
    CGFloat endAngle = 1.38 * M_PI;
    
    
    NSLog(@"startAngle = %lf,endAngle = %lf",startAngle,endAngle);
    
    //添加背景圆环
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(wi/2, hi/2) radius:hi/2-lineWidth startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor =  [[UIColor clearColor] CGColor];
    backLayer.strokeColor  = [UIColor colorWithRed:42.0/255.0f green:42.0/255.0f blue:42.0/255.0f alpha:1].CGColor;
    backLayer.lineWidth = lineWidth;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    backLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:backLayer];
    
    //添加圆环
    CGFloat lineWidth1 = 22;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(wi/2, hi/2) radius:hi/2-lineWidth+1 startAngle:startAngle endAngle:endAngle clockwise:YES];
    CAShapeLayer *backLayer1 = [CAShapeLayer layer];
    backLayer1.frame = self.bounds;
    backLayer1.fillColor =  [[UIColor clearColor] CGColor];
    backLayer1.strokeColor  = [UIColor colorWithRed:70.0/255.0f green:69.0/255.0f blue:69.0/255.0f alpha:1].CGColor;
    backLayer1.lineWidth = lineWidth1;
    backLayer1.path = path1.CGPath;
    backLayer1.strokeEnd = 1;
    backLayer1.lineCap = kCALineCapRound;
    [self.layer addSublayer:backLayer1];
    
    
    //周围小圆
    NSArray *numArr = @[@"0",@"1",@"3",@"6",@"12",@"18",@"24",@"36"];
    UIBezierPath *yuanPath = [UIBezierPath bezierPath];
    
    double cha = (M_PI * (2.0-DEGREES_TO_RADIANS(0.2)) /8)/M_PI;
    NSLog(@"%lf",cha);
    
    
    for (int i = 0; i < numArr.count; i++) {
        
        CGPoint po = [self getPicLocAngle:(1.62+cha*i)*M_PI center:CGPointMake(wi/2, hi/2) radius:hi/2-lineWidth-14];
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(po.x, po.y) radius:2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [yuanPath appendPath:path2];

        UILabel *la = [[UILabel alloc]init];
        la.text = numArr[i];
        la.textColor = [UIColor orangeColor];
        la.textAlignment = NSTextAlignmentCenter;
        la.font = [UIFont systemFontOfSize:8];
        la.frame = CGRectMake(yuanPath.currentPoint.x, yuanPath.currentPoint.y, 15, 10);
        [self addSubview:la];
        switch (i) {
            case 0:
            {
                la.frame = CGRectMake(yuanPath.currentPoint.x-5, yuanPath.currentPoint.y+5, 15, 10);
            }
                break;
            case 1:
                la.frame = CGRectMake(yuanPath.currentPoint.x-15, yuanPath.currentPoint.y-5, 15, 10);
                break;
            case 2:
                la.frame = CGRectMake(yuanPath.currentPoint.x -15, yuanPath.currentPoint.y-5, 15, 10);
                break;
            case 3:
                la.frame = CGRectMake(yuanPath.currentPoint.x -5, yuanPath.currentPoint.y-15, 15, 10);
                break;
            case 4:
                la.frame = CGRectMake(yuanPath.currentPoint.x -5, yuanPath.currentPoint.y-15, 15, 10);
                break;
            case 5:
                la.frame = CGRectMake(yuanPath.currentPoint.x +5, yuanPath.currentPoint.y-5, 15, 10);
                break;
            case 6:
                la.frame = CGRectMake(yuanPath.currentPoint.x +5, yuanPath.currentPoint.y-5, 15, 10);
                break;
            case 7:
                la.frame = CGRectMake(yuanPath.currentPoint.x-5, yuanPath.currentPoint.y+5, 15, 10);
                break;
        }
        [la sizeToFit];
    }

    
    CAShapeLayer *yuanLayer = [CAShapeLayer layer];
    yuanLayer.frame = self.bounds;
    yuanLayer.fillColor =  [[UIColor redColor] CGColor];
    yuanLayer.strokeColor  = [UIColor redColor].CGColor;
    yuanLayer.lineWidth = 2;
    yuanLayer.path = yuanPath.CGPath;
    yuanLayer.strokeEnd = 1;
    yuanLayer.lineCap = kCALineCapRound;
    yuanLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:yuanLayer];
    
    

    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(wi/2, hi/2) radius:hi/2-lineWidth+1 startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0.6;
    
    self.progressLayer.path = progressPath.CGPath;
    [self.layer addSublayer:self.progressLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.progressLayer.strokeEnd = 0.8;
    });
    
    CGPoint po1 = [self getPicLocAngle:1.62*M_PI center:CGPointMake(wi/2, hi/2) radius:hi/2-lineWidth/2];
    self.startImageView.frame = CGRectMake(po1.x, po1.y, 15, 15);
    po1 = [self getPicLocAngle:1.38*M_PI center:CGPointMake(wi/2, hi/2) radius:hi/2-lineWidth/2];
    self.endImageView.frame = CGRectMake(po1.x, po1.y, 15, 15);
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = nil;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineJoin = kCALineCapRound;
        _progressLayer.lineWidth = 22;
    }
    return _progressLayer;
}

- (UIImageView *)startImageView {
    if (!_startImageView) {
        _startImageView = [[UIImageView alloc]init];
        _startImageView.userInteractionEnabled = YES;
        _startImageView.backgroundColor = [UIColor redColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(startPanGestureRecognizer:)];
        [_startImageView addGestureRecognizer:pan];
        [self addSubview:_startImageView];

    }
    return _startImageView;
}

- (UIImageView *)endImageView {
    if (!_endImageView) {
        _endImageView = [[UIImageView alloc]init];
        _endImageView.userInteractionEnabled = YES;
        _endImageView.backgroundColor = [UIColor yellowColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(endPanGestureRecognizer:)];
        [_endImageView addGestureRecognizer:pan];
        [self addSubview:_endImageView];

    }
    return _endImageView;
}

- (void)startPanGestureRecognizer:(UIPanGestureRecognizer*)pan{
    
    NSLog(@"start:%@",NSStringFromCGPoint([pan locationInView:self]));
    CGPoint startPoint = [pan locationInView:self];
    float radiansTowardsCenter = ToRad(AngleFromNorth(Cgpoint, startPoint, NO));
    NSLog(@"start:%lf",radiansTowardsCenter);
    CGPoint po = [self getPicLocAngle:radiansTowardsCenter center:Cgpoint radius:Cradius];
    if ((radiansTowardsCenter < 1.62 *M_PI) && (radiansTowardsCenter > 1.38 *M_PI)) {
        return;
    }
    self.startImageView.center = po;
    self.progressLayer.strokeStart = (2*M_PI)-(radiansTowardsCenter/M_PI);
}

- (void)endPanGestureRecognizer:(UIPanGestureRecognizer*)pan{
    
    NSLog(@"end:%@",NSStringFromCGPoint([pan locationInView:self]));
    CGPoint endPoint = [pan locationInView:self];
    float radiansTowardsCenter = ToRad(AngleFromNorth(Cgpoint, endPoint, NO));
    CGPoint po = [self getPicLocAngle:radiansTowardsCenter center:Cgpoint radius:Cradius];
    NSLog(@"end:%lf",radiansTowardsCenter);
    if ((radiansTowardsCenter < 1.62 *M_PI) && (radiansTowardsCenter > 1.38 *M_PI)) {
        return;
    }
    self.endImageView.center = po;
    NSLog(@"end : %lf",radiansTowardsCenter);
    self.progressLayer.strokeEnd = (2*M_PI) - radiansTowardsCenter;
}

- (CGPoint)getPicLocAngle:(double)angle center:(CGPoint)center radius:(double)radius {
    
    double x = .0;
    double y = .0;
    x = center.x +  (double)(cosf((double)angle)*radius);
    y = center.y +  (double)(sinf((double)angle)*radius);
    
    return CGPointMake(x, y);
}

//计算中心点到任意点的角度
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

@end
