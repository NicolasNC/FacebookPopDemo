//
//  ViewController.m
//  NCFaceBookPopDemo
//
//  Created by lishengfeng on 2019/11/11.
//  Copyright © 2019 Nicolas. All rights reserved.
//

#import "ViewController.h"
#import <pop/POP.h>
#import "MenuTableViewCell.h"
#import "PaperButton.h"
#import "UIColor+CustomColors.h"
#import "ConstraintsViewController.h"

static NSString * const kCellIdentifier = @"cellIdentifier";
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,POPAnimationDelegate>
@property(nonatomic,strong)UIView *markView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *grayView;
@property(nonatomic,strong)PaperButton *paperButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"NCFaceBookPopDemo";
    
    PaperButton *button = [PaperButton button];
    [button addTarget:self action:@selector(animateTitleLabel:) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor = [UIColor customBlueColor];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    self.paperButton = button;
    
    [self cofigureTableView];
    [self.view addSubview:self.grayView];
    [self.view insertSubview:self.grayView belowSubview:self.tableView];
}
- (void)cofigureTableView{
    self.dataArr =
    @[@[@"BasicAnimation", @"basicAnimation"],
    @[@"SpringAnimation", @"springAnimation"],
    @[@"DecayAnimation", @"decayAnimation"],
    @[@"CustomPropertyAnimation", @"customPropertyAnimation"],
    @[@"PopUp&DecayMove", @"customAnimation1"],
    @[@"Flyin", @"customAnimation2"],
    @[@"Transform", @"customAnimation3"],
    @[@"ConstraintsAnimation", @"ConstraintsAnimation"],
    @[@"CircleProAnimation", @"circleProAnimation"]];
    [self.view addSubview:self.tableView];
}

#pragma mark======subview
- (UIView *)markView{
    if (!_markView) {
        _markView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _markView.backgroundColor = [UIColor customGreenColor];
        _markView.center = self.view.center;
        [self.view addSubview:_markView];
    }
    return _markView;
}
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
        _label.center = self.view.center;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor customGrayColor];
        _label.font = [UIFont boldSystemFontOfSize:40];
        [self.view addSubview:_label];
    }
    return _label;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-self.view.frame.size.width*0.65, 0, self.view.frame.size.width*0.65, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MenuTableViewCell class]
        forCellReuseIdentifier:kCellIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 50.f;
    }
    return _tableView;
}
- (UIView *)grayView{
    if (!_grayView) {
        _grayView = [[UIView alloc]initWithFrame:self.view.bounds];
        _grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _grayView.alpha = 0;
        _grayView.userInteractionEnabled = true;
               
        __autoreleasing UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(grayViewAction)];
        [_grayView addGestureRecognizer:tgr];
    }
    return _grayView;
}
#pragma mark=====action
- (void)grayViewAction{
    [self animationTableView:false];
    [self.paperButton updataStatue:true];
    self.paperButton.selected = false;
}
- (void)animateTitleLabel:(PaperButton *)sender
{
    sender.selected = !sender.selected;
    [self animationTableView:sender.selected];
    
}
- (void)animationTableView:(bool)show{
   if (!show) {
      [self resetMarkView];
   }else{
       self.markView.hidden = true;
       self.label.hidden = true;
   }
   CGFloat toValue = show?CGRectGetMinX(self.view.bounds)+CGRectGetWidth(self.tableView.bounds)*0.5:- CGRectGetWidth(self.tableView.bounds);
    POPSpringAnimation *psa = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    psa.toValue = @(toValue);
    psa.springBounciness = 10.f;
    [self.tableView pop_addAnimation:psa forKey:kPOPLayerPositionX];
    [self.tableView reloadData];
    
    CGFloat toValue2 = show?1:0;
    POPBasicAnimation *pba = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    pba.toValue = @(toValue2);
    pba.duration = 0.33;
    [self.grayView pop_addAnimation:pba forKey:kPOPLayerOpacity];
}

#pragma mark=====Animation
- (void)basicAnimation{
   POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    basic.fromValue = @(0);
    basic.toValue = @(300);
    basic.duration = 0.33;
    [self.markView pop_addAnimation:basic forKey:kPOPLayerPositionX];
}
- (void)springAnimation{
    NSInteger rand = arc4random() % 100;
    if (rand < 50) {
        POPSpringAnimation *psa = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
           psa.velocity = @2000;
           psa.springBounciness = 20;
           [self.markView.layer pop_addAnimation:psa forKey:kPOPViewScaleX];
    }else{
        //改变的是x和y的比例
        POPSpringAnimation *psa2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        psa2.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
        psa2.toValue = [NSValue valueWithCGSize:CGSizeMake(3, 3)];
        psa2.springSpeed = 5;
        psa2.springBounciness = 15;
        [self.markView pop_addAnimation:psa2 forKey:kPOPViewScaleXY];
    }
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
    [self performPopUpAnimation];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.markView addGestureRecognizer:pan];
}
- (void)customAnimation2{
    [self.markView pop_removeAllAnimations];
    
    [self.markView.layer setCornerRadius:5.0f];
    [self.markView setBounds:CGRectMake(0.0f, 0.0f, 160.0f, 230.0f)];
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI_4/8.0);
    [self.markView.layer setAffineTransform:rotateTransform];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.springBounciness = 6;
    anim.springSpeed = 10;
    anim.fromValue = @-200;
    anim.toValue = @(self.view.center.y);
    
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.25;
    opacityAnim.toValue = @1.0;
    
    POPBasicAnimation *rotationAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    
    rotationAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnim.beginTime = CACurrentMediaTime() + 0.1;
    rotationAnim.duration = 0.3;
    rotationAnim.toValue = @(0);
    
    [self.markView.layer pop_addAnimation:anim forKey:@"AnimationScale"];
    [self.markView.layer pop_addAnimation:opacityAnim forKey:@"AnimateOpacity"];
    [self.markView.layer pop_addAnimation:rotationAnim forKey:@"AnimateRotation"];
}
- (void)customAnimation3{
    [self.markView pop_removeAllAnimations];
    self.markView.layer.cornerRadius = 25.0;

       //Config progress line
       CAShapeLayer *progressLayer = [CAShapeLayer layer];
       progressLayer.strokeColor = [UIColor customYellowColor].CGColor;
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

- (void)circleProAnimation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat lineWidth = 10.f;
        CGFloat radius = CGRectGetWidth(self.markView.bounds)/2 - lineWidth/2;
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        CGRect rect = CGRectMake(lineWidth/2, lineWidth/2, radius * 2, radius * 2);
        circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                      cornerRadius:radius].CGPath;

        circleLayer.strokeColor = self.markView.tintColor.CGColor;
        circleLayer.fillColor = nil;
        circleLayer.lineWidth = lineWidth;
        circleLayer.lineCap = kCALineCapRound;
        circleLayer.lineJoin = kCALineJoinRound;
        circleLayer.strokeColor = [UIColor customYellowColor].CGColor;
        [self.markView.layer addSublayer:circleLayer];
        
        NSInteger rand = arc4random()% 6 +1;
        CGFloat toValue = rand/10.0;
        POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
        strokeAnimation.toValue = @(toValue);
        strokeAnimation.springBounciness = 5.f;
        strokeAnimation.springSpeed = 6;
        strokeAnimation.removedOnCompletion = NO;
        [circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimation"];
    });
}
- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.view];
    pan.view.center = CGPointMake(pan.view.center.x + translation.x,
                                         pan.view.center.y + translation.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    if(pan.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [pan velocityInView:self.view];
        [self addDecayPositionAnimationWithVelocity:velocity];
    }
}

-(void)addDecayPositionAnimationWithVelocity:(CGPoint)velocity
{
    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
    anim.delegate = self;
    anim.velocity = [NSValue valueWithCGPoint:velocity];
    anim.deceleration = 0.998;
    [self.markView.layer pop_addAnimation:anim forKey:@"AnimationPosition"];
    
}
-(void)performPopUpAnimation
{
    
    [self.markView pop_removeAllAnimations];
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.springBounciness = 10;
    anim.springSpeed = 20;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.6, 1.6)];
    
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.3;
    opacityAnim.toValue = @1.0;
    
    [self.markView.layer pop_addAnimation:anim forKey:@"AnimationScale"];
    [self.markView.layer pop_addAnimation:opacityAnim forKey:@"AnimateOpacity"];
}
- (void)resetMarkView{
    [self.markView.layer pop_removeAllAnimations];
    for (CAShapeLayer *layer in self.markView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    self.markView.layer.opacity = 1;
    
    self.markView.layer.transform = CATransform3DIdentity;
    [self.markView.layer setMasksToBounds:YES];
    [self.markView.layer setBackgroundColor:[UIColor colorWithRed:0.16 green:0.72 blue:1.0 alpha:1.0].CGColor];
    [self.markView.layer setCornerRadius:50.0f];
    [self.markView setBounds:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    self.markView.layer.position = CGPointMake(self.view.center.x, self.view.center.y);
}
#pragma mark - POPAnimationDelegate
- (void)pop_animationDidApply:(POPDecayAnimation *)anim
{
    BOOL isDragViewOutsideOfSuperView = !CGRectContainsRect(self.view.frame, self.markView.frame);
    if (isDragViewOutsideOfSuperView) {
        CGPoint currentVelocity = [anim.velocity CGPointValue];
        CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        positionAnimation.toValue = [NSValue valueWithCGPoint:self.view.center];
        [self.markView.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}
#pragma mark=======UITableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                              forIndexPath:indexPath];
      cell.textLabel.text = [self.dataArr[indexPath.row] firstObject];
      return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self animationTableView:false];
    [self.paperButton updataStatue:true];
    self.paperButton.selected = false;
    NSString *methodStr = self.dataArr[indexPath.row][1];
    self.title = [self.dataArr[indexPath.row] firstObject];
    if ([methodStr isEqualToString:@"ConstraintsAnimation"]) {
        ConstraintsViewController *cvc = [[ConstraintsViewController alloc]init];
        [self.navigationController pushViewController:cvc animated:true];
        return;
    }
    if ([methodStr isEqualToString:@"customPropertyAnimation"]) {
        self.markView.hidden = true;
        self.label.hidden = false;
    }else{
        self.markView.hidden = false;
        self.label.hidden = true;
    }
    if (methodStr) {
        SEL sel = NSSelectorFromString(methodStr);
        if([self respondsToSelector:sel]){
        　 [self performSelector:sel　withObject:nil];
        }
    }
}
@end
