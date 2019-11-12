//
//  ViewController.m
//  NCFaceBookPopDemo
//
//  Created by lishengfeng on 2019/11/11.
//  Copyright © 2019 Nicolas. All rights reserved.
//

#import "ViewController.h"
#import <pop/POP.h>
@interface ViewController ()
@property(nonatomic,strong)UIView *markView;
@property(nonatomic,strong)UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (UIView *)markView{
    if (!_markView) {
        _markView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _markView.backgroundColor = [UIColor redColor];
        _markView.center = self.view.center;
        [self.view addSubview:_markView];
    }
    return _markView;
}
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
        _label.center = self.view.center;
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:_label];
    }
    return _label;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //1.基础动画
//    [self basicAnimation];
    
    //2.弹性动画
//    [self springAnimation];
    
    //3.衰减动画
//    [self decayAnimation];
    
    //4.自定义Property
//    [self customPropertyAnimation];
    
     //5.特殊动画
//     [self customAnimation1];
    
    //6.特殊动画
//    [self customAnimation2];//FLYIN
    
    //7.特殊动画
    [self customAnimation3];//TRANSFORM
}

- (void)basicAnimation{
   POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    basic.fromValue = @(0);
    basic.toValue = @(300);
    basic.duration = 0.33;
    [self.markView pop_addAnimation:basic forKey:kPOPLayerPositionX];
}
- (void)springAnimation{
#if  0
    POPSpringAnimation *psa = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleX];
    psa.fromValue = @(0.3);
    psa.toValue = @(2);
    psa.springSpeed = 5;
    psa.springBounciness = 15;
    [self.markView pop_addAnimation:psa forKey:kPOPViewScaleX];
    
#else
    //改变的是x和y的比例
    POPSpringAnimation *psa2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    psa2.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
    psa2.toValue = [NSValue valueWithCGSize:CGSizeMake(3, 3)];
    psa2.springSpeed = 5;
    psa2.springBounciness = 15;
    [self.markView pop_addAnimation:psa2 forKey:kPOPViewScaleXY];
#endif
}
- (void)decayAnimation{
    POPDecayAnimation *pda = [POPDecayAnimation animationWithPropertyNamed:kPOPViewSize];
    pda.velocity = [NSValue valueWithCGSize:CGSizeMake(300, self.markView.frame.size.height)];
    [self.markView pop_addAnimation:pda forKey:kPOPViewSize];
    
}
- (void)customPropertyAnimation{
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = 10.0;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) { prop.readBlock = ^(id obj, CGFloat values[]) {     values[0] = [[obj description] floatValue];
        
       };
        prop.writeBlock = ^(id obj, const CGFloat values[]) {     [obj setText:[NSString stringWithFormat:@"%.2f",values[0]]];
        };
        prop.threshold = 0.01;}];
    anim.property = prop;
    anim.fromValue = @(0.0);
    anim.toValue = @(100.0);
    [self.label pop_addAnimation:anim forKey:nil];
}
- (void)customAnimation1{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.markView addGestureRecognizer:pan];
    
    [self.markView.layer pop_removeAllAnimations];
    for (CAShapeLayer *layer in self.markView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    self.markView.layer.opacity = 1;
    
    self.markView.layer.transform = CATransform3DIdentity;
    [self.markView.layer setMasksToBounds:YES];
    [self.markView.layer setBackgroundColor:[UIColor colorWithRed:0.16 green:0.72 blue:1.0 alpha:1.0].CGColor];
    [self.markView.layer setCornerRadius:25.0f];
    [self.markView setBounds:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    self.markView.layer.position = CGPointMake(self.view.center.x, 180.0);
}
- (void)customAnimation2{
    [self.markView pop_removeAllAnimations];
       POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
       anim.springBounciness = 10;
       anim.springSpeed = 20;
       anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
       anim.toValue = [NSValue valueWithCGPoint:CGPointMake(2.0, 2.0)];
       
       POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
       
       opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
       opacityAnim.duration = 0.3;
       opacityAnim.toValue = @1.0;
       
    [self.markView.layer pop_addAnimation:anim forKey:@"AnimationScale"];
    [self.markView.layer pop_addAnimation:opacityAnim forKey:@"AnimateOpacity"];
}
- (void)customAnimation3{
     [self.markView pop_removeAllAnimations];

       //Config progress line
       CAShapeLayer *progressLayer = [CAShapeLayer layer];
       progressLayer.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.98].CGColor;
       progressLayer.lineCap   = kCALineCapRound;
       progressLayer.lineJoin  = kCALineJoinBevel;
       progressLayer.lineWidth = 26.0;
       progressLayer.strokeEnd = 0.0;
       
       UIBezierPath *progressline = [UIBezierPath bezierPath];
       [progressline moveToPoint:CGPointMake(25.0, 25.0)];
       [progressline addLineToPoint:CGPointMake(700.0, 25.0)];
       progressLayer.path = progressline.CGPath;
       
       [self.markView.layer addSublayer:progressLayer];
       //

       POPSpringAnimation *scaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
       scaleAnim.springBounciness = 5;
       scaleAnim.springSpeed = 12;
       scaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.3, 0.3)];
       
       POPSpringAnimation *boundsAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
       boundsAnim.springBounciness = 10;
       boundsAnim.springSpeed = 6;
       boundsAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 800, 50)];
       
       boundsAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
           if (finished) {
               
               UIGraphicsBeginImageContextWithOptions(self.markView.frame.size, NO, 0.0);
               POPBasicAnimation *progressBoundsAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
               progressBoundsAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
               progressBoundsAnim.duration = 1.0;
               progressBoundsAnim.fromValue = @0.0;
               progressBoundsAnim.toValue = @1.0;
               
               [progressLayer pop_addAnimation:progressBoundsAnim forKey:@"AnimateBounds"];
               progressBoundsAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                   if (finished) {
                       UIGraphicsEndImageContext();
                   }
               };
               
               
           }
       };
       
       [self.markView.layer pop_addAnimation:boundsAnim forKey:@"AnimateBounds"];
       [self.markView.layer pop_addAnimation:scaleAnim forKey:@"AnimateScale"];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            [self.markView.layer pop_removeAllAnimations];
            
            CGPoint translation = [pan translationInView:self.view];
            
            CGPoint center = self.markView.center;
            center.x += translation.x;
            center.y += translation.y;
            self.markView.center = center;
            
            [pan setTranslation:CGPointZero inView:self.markView];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            CGPoint velocity = [pan velocityInView:self.view];
            [self addDecayPositionAnimationWithVelocity:velocity];
            break;
        }
            
        default:
            break;
    }
}

-(void)addDecayPositionAnimationWithVelocity:(CGPoint)velocity
{
    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
    
    anim.velocity = [NSValue valueWithCGPoint:CGPointMake(velocity.x, velocity.y)];
    anim.deceleration = 0.998;
    [self.markView.layer pop_addAnimation:anim forKey:@"AnimationPosition"];
}

@end
