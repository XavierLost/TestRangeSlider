#define CartesianToCompass(rad) ((rad) + M_PI / 2 )
#define CompassToCartesian(rad) ((rad) - M_PI / 2 )

#import "CHcir_Slider.h"
///角度转弧度
static inline double DegreesToRadians(double angle) { return M_PI * angle / 180.0; }
///弧度转角度
static inline double RadiansToDegrees(double angle) { return angle * 180.0 / M_PI; }

static inline CGPoint CGPointCenterRadiusAngle(CGPoint c, double r, double a) {
    return CGPointMake(c.x + r * cos(a), c.y + r * sin(a));
}

static inline CGFloat AngleBetweenPoints(CGPoint a, CGPoint b, CGPoint c) {
    return atan2(a.y - c.y, a.x - c.x) - atan2(b.y - c.y, b.x - c.x);
}

@interface CHcir_Slider ()

@property (strong, nonatomic) CALayer *outerCircleLayer;

@property (assign, nonatomic) CGPoint handcenterPoint ;

@property (assign, nonatomic) CGPoint handcenterPoint1 ;

@property (assign, nonatomic) CGPoint location;
@property(nonatomic, strong) CAShapeLayer *yuanLayer;
@end

@implementation CHcir_Slider
- (instancetype)init
{
    return [self initWithFrame:CGRectZero] ;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _startAngle = -270.f;
        _cutoutAngle = 60.f;
        _lineWidth = 40.f;
        _guideLineColor = [UIColor clearColor];
        _progress = 10.f;
        _progress1 = .0f;
        _handleOutSideRadius = 11.f; //开始结束外圆半径
        _handleInSideRadius = 4.f;   //开始小圆半径
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _startAngle = -270.f;
        _cutoutAngle = 60.f;
        _lineWidth = 40.f;
        _guideLineColor = [UIColor clearColor];
        _progress = 1.f;
        _progress1 = .0f;
        _handleOutSideRadius = 11.f; //开始结束外圆半径
        _handleInSideRadius = 4.f;   //开始小圆半径
    }
    return self;
}


//检测触摸点是否在slider所在圆圈范围内
- (BOOL)pointInsideCircle:(CGPoint)point {
    //获取x.y的位置
    CGPoint p1 =  CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint p2 = point;
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    double distance = sqrt((xDist * xDist) + (yDist * yDist));
    CGFloat radius = CGRectGetMidX(self.bounds) - self.lineWidth / 2 - self.handleOutSideRadius *2 ;
    
    
    CGFloat handleRadius = self.handleOutSideRadius;
    
    return distance < radius + self.lineWidth * 0.5 + handleRadius && distance > radius - self.lineWidth *0.5 - handleRadius;
}

//检测触摸点是否在滑动块中
- (BOOL)pointInsideHandle:(CGPoint)point{
    CGPoint handleCenter = CGPointMake(_handcenterPoint.x, self.bounds.size.width- _handcenterPoint.y) ;
  //   NSLog(@"(%f..%f)......(%f..%f).......(%f..%f)",_handcenterPoint.x,_handcenterPoint.y,handleCenter.x,handleCenter.y,point.x,point.y);
    CGFloat handleRadius = _handleOutSideRadius+15;
    
    CGRect handleRect = CGRectMake(handleCenter.x - handleRadius, handleCenter.y - handleRadius, handleRadius *2, handleRadius *2);
    return CGRectContainsPoint(handleRect, point);
}


- (BOOL)point1InsideHandle:(CGPoint)point{
    CGPoint handleCenter = CGPointMake(_handcenterPoint1.x, self.bounds.size.width- _handcenterPoint1.y);

    CGFloat handleRadius = _handleOutSideRadius+15;
    
    CGRect handleRect = CGRectMake(handleCenter.x - handleRadius, handleCenter.y - handleRadius, handleRadius *2, handleRadius *2);


    return CGRectContainsPoint(handleRect, point);
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    _location = [touch locationInView:self];
    if([self pointInsideHandle:_location] == 1){
        [self drawWithLocation:_location with:1];
    }else if([self point1InsideHandle:_location] == 1){
        [self drawWithLocation:_location with:2];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    

}
- (void)drawWithLocation:(CGPoint)location with:(NSInteger)index{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = CGRectGetMidX(self.bounds) - self.lineWidth / 2;
    CGFloat startAngle = _startAngle;
    
    if (startAngle < 0)
        startAngle = fabs(startAngle);
    else
        startAngle = 360.f - startAngle;
    CGPoint startPoint = CGPointCenterRadiusAngle(center, radius, DegreesToRadians(startAngle));
    CGFloat angle = RadiansToDegrees(AngleBetweenPoints(location, startPoint, center));
    if (angle < 0) angle += 360.f;
    angle = angle - _cutoutAngle / 2.f;
    
    if(index == 1){
        self.progress = angle / (360.f - _cutoutAngle);
    }else if(index == 2) {
        self.progress1 = angle/ (360.f - _cutoutAngle);
    }

    [self.delegate maxIntValueChanged:self.progress];
    [self.delegate minIntValueChanged:self.progress1];
}
- (void)setStartAngle:(CGFloat)startAngle {
    _startAngle = startAngle;
    [self setNeedsDisplay];
}

- (void)setCutoutAngle:(CGFloat)cutoutAngle {
    _cutoutAngle = cutoutAngle;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

#pragma mark - 设置左边的进度(Max)
- (void)setProgress:(CGFloat)progress {
    if (progress < self.progress1) {
        return;
    }
    if (progress > 0.99)
        _progress = 1;
    else if (progress < 0)
        _progress = 0;
    else
        _progress = progress;
    NSLog(@"Max:%lf",progress);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

#pragma mark - 设置右边的进度(Min)
- (void)setProgress1:(CGFloat)progress1{
    if (progress1 > 1)
        _progress1 = 1;
    else if (progress1 < 0.01)
        _progress1 = 0.0;
    else
        _progress1 = progress1;
    NSLog(@"Min:%lf",progress1);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 改变画布位置（0，0位置移动到此处）
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // 居中
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // 半径
    CGFloat radius = CGRectGetMidX(self.bounds) - self.lineWidth / 2 - self.handleOutSideRadius/2;
    
    // 1.绘制背景圆
    [[UIColor blackColor]set];
    CGContextSetLineWidth(context, self.lineWidth+10);
    CGContextAddArc(context, center.x, center.y, radius, 0, M_PI*2, 1);
    CGContextStrokePath(context);
    
    radius = CGRectGetMidX(self.bounds) - self.lineWidth / 2 - self.handleOutSideRadius/2  + 1.5;
    // 2.绘制范围圆
    CGContextSetLineWidth(context, self.lineWidth);
    // 圆的开始位置
    CGFloat arcStartAngle = DegreesToRadians(self.startAngle + 360.0 - self.cutoutAngle / 2.0);
    // 圆的结束位置
    CGFloat arcEndAngle = DegreesToRadians(self.startAngle + self.cutoutAngle / 2.0);
    // 左边进度
    CGFloat progressAngle = DegreesToRadians(360.f - self.cutoutAngle) * self.progress;
    // 右边
    CGFloat progressAngle1 = DegreesToRadians(360.f - self.cutoutAngle) * _progress1;
    // 设置颜色
    [self.guideLineColor set];
    // 开始绘制范围圆
    CGContextAddArc(context, center.x, center.y, radius, arcStartAngle, arcEndAngle, 1);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
    
    // 3.背景
//    [self.tintColor set];
    [[UIColor orangeColor]set];
    CGContextAddArc(context, center.x, center.y, radius, arcStartAngle-progressAngle1, arcStartAngle - progressAngle, 1);
    CGContextStrokePath(context);

    // 4.背景
    [[UIColor orangeColor]set];
    CGContextAddArc(context, center.x, center.y, radius, arcStartAngle - progressAngle1, arcStartAngle - progressAngle1, NO);
    CGContextStrokePath(context);
    
    // 5.结束外的大圆
//    [[UIColor blackColor] set];
//    CGContextSetLineWidth(context, self.handleOutSideRadius * 1);
    CGPoint handle = CGPointCenterRadiusAngle(center, radius, arcStartAngle - progressAngle);
//    CGContextAddArc(context, handle.x, handle.y, self.handleOutSideRadius, 0, DegreesToRadians(360), 1);
//    CGContextStrokePath(context);
    _handcenterPoint = handle;
    _handcenterPoint = CGPointMake(_handcenterPoint.x, _handcenterPoint.y + 11/1.2);
    // 6.结束中的小圆
//    [[UIColor orangeColor]set];
//    CGContextSetLineWidth(context, self.handleInSideRadius * 2);
//    CGContextAddArc(context, handle.x, handle.y, self.handleInSideRadius, 0, DegreesToRadians(360), 1);
//    CGContextAddRect(context, CGRectMake(handle.x-1/2, handle.y-1/2, 1, 1));
//    CGContextStrokePath(context);
    [self drawThumbImage:[UIImage imageNamed:@"AutomaticBidding_end"] thumbOrigin:handle imageWidth:self.handleInSideRadius * 2 context:context];
    
    // 7.开始的大圆
//    [[UIColor blackColor] set];
//    CGContextSetLineWidth(context, self.handleOutSideRadius * 1);
    CGPoint handle1 = CGPointCenterRadiusAngle(center, radius, arcStartAngle - progressAngle1);
    _handcenterPoint1 = handle1;
//    CGContextAddArc(context, handle1.x, handle1.y, self.handleOutSideRadius, 0, DegreesToRadians(360), 1);
//    CGContextStrokePath(context);
    
    // 8.开始中的小圆
//    [[UIColor orangeColor] set];
//    CGContextSetLineWidth(context, self.handleInSideRadius * 1);
//    CGContextAddArc(context, handle1.x, handle1.y, self.handleInSideRadius, 0, DegreesToRadians(360), 1);
//    CGContextStrokePath(context);
    _handcenterPoint1 = CGPointMake(_handcenterPoint1.x, _handcenterPoint1.y + 11/1.2);
     [self drawThumbImage:[UIImage imageNamed:@"AutomaticBidding_start"] thumbOrigin:handle1 imageWidth:self.handleInSideRadius * 2 context:context];
    //周围小圆
    if (self.yuanLayer) {
        return;
    }

    NSArray *numArr = @[@"0",@"1",@"3",@"6",@"12",@"18",@"24",@"36"];
    UIBezierPath *yuanPath = [UIBezierPath bezierPath];
    double cha = (M_PI * (2.0-DegreesToRadians(0.2)) /8)/M_PI;
    for (int i = 0; i < numArr.count; i++) {
        
        CGPoint po = [self getPicLocAngle:(1.62+cha*i)*M_PI center:center radius:radius - self.lineWidth/2-4];
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(po.x, po.y) radius:2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [yuanPath appendPath:path2];
        
        UILabel *la = [[UILabel alloc]init];
        la.text = numArr[i];
        la.textColor = [UIColor colorWithRed:249.0/255.0 green:144.0/255.0 blue:0 alpha:1];
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
    
    
    self.yuanLayer = [CAShapeLayer layer];
    self.yuanLayer.frame = self.bounds;
    self.yuanLayer.fillColor =  [[UIColor colorWithRed:249.0/255.0 green:144.0/255.0 blue:0 alpha:1] CGColor];
    self.yuanLayer.strokeColor  = [UIColor colorWithRed:249.0/255.0 green:144.0/255.0 blue:0 alpha:1].CGColor;
    self.yuanLayer.lineWidth = 2;
    self.yuanLayer.path = yuanPath.CGPath;
    self.yuanLayer.strokeEnd = 1;
    self.yuanLayer.lineCap = kCALineCapRound;
    self.yuanLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:self.yuanLayer];
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


- (CGPoint)getPicLocAngle:(double)angle center:(CGPoint)center radius:(double)radius {
    
    double x = .0;
    double y = .0;
    x = center.x +  (double)(cosf((double)angle)*radius);
    y = center.y +  (double)(sinf((double)angle)*radius);
    
    return CGPointMake(x, y);
}



@end
