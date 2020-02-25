//
//  RefreshGradientView
//  TaoChongYouPin
//
//  Created by icash on 16/11/14.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "RefreshGradientView.h"

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
static const float kPROGRESS_LINE_WIDTH=4.0;

@interface RefreshGradientView ()

@property (nonatomic,strong) CAShapeLayer *progressLayer;

@property (nonatomic,strong) CAReplicatorLayer *replicatorLayer;

@end

@implementation RefreshGradientView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self dosetup];
    }
    return self;
}
- (void)dosetup
{
    
}

- (void)setOffsetY:(CGFloat)offsetY
{
    _offsetY = offsetY;

    
    [self setupBesier];//下拉刷新效果
//    [self juhuaAnnmion];
    
    [self drawAnimationLayer];
}
- (void)setupBesier
{
    if (self.progressLayer) {
        return;
    }
    CGRect frame = self.frame;
    //设置贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:(frame.size.width-kPROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(-60) endAngle:degreesToRadians(-120) clockwise:YES];
    //遮罩层
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor= [UIColor redColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = kPROGRESS_LINE_WIDTH;
    
    _progressLayer.path=path.CGPath;
    
    //渐变图层
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = _progressLayer.frame;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0x999999, 1) CGColor],(id)[UIColorFromRGB(0x666666, 1) CGColor], nil]];
    [gradientLayer setLocations:@[@0,@1]];
    [gradientLayer setStartPoint:CGPointMake(0, 0)];
    [gradientLayer setEndPoint:CGPointMake(1, 0)];
    //用progressLayer来截取渐变层 遮罩
    [gradientLayer setMask:_progressLayer];
    [self.layer addSublayer:gradientLayer];
    
}
- (void)drawAnimationLayer
{
    CGFloat height = self.triggerHeight;
    CGFloat oper = self.offsetY / height;
    
    self.progressLayer.strokeEnd = oper;
    
    if (oper >=1) { // 填充
        
    } else { // 取消填充
        
    }
    
}
-(void)juhuaAnnmion
{
   
    CGFloat width = self.bounds.size.width;
    
    _replicatorLayer = [CAReplicatorLayer layer];
    _replicatorLayer.bounds = CGRectMake(0, 0, width, width);
    //设置中点为父视图的中点
    _replicatorLayer.position = CGPointMake(width/2, width/2);
    //复制图层次数
    _replicatorLayer.instanceCount = 10;
    //复制延迟
    _replicatorLayer.instanceDelay = 0.5;
    [self.layer addSublayer:_replicatorLayer];
    
    
    CALayer *layer = [CALayer layer];
    //小菊花“叶子”的宽高
    layer.bounds = CGRectMake(0, 0, 1, 6);
    layer.position = CGPointMake(width/2, 2);
    //小菊花的颜色
    layer.backgroundColor = kColorThirdTextColor.CGColor;
    [_replicatorLayer addSublayer:layer];

    CGFloat angle = (CGFloat) 2*M_PI/10;
    _replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.fromValue = [NSNumber numberWithFloat:0.4];
    alphaAnim.toValue = [NSNumber numberWithFloat:0.8];
    alphaAnim.duration = 1.5;
    alphaAnim.repeatCount = HUGE;
    [layer addAnimation:alphaAnim forKey:nil];
}




@end
