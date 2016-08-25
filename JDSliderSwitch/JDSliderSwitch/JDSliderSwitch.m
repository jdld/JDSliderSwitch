//
//  JDSliderSwitch.m
//  JDSliderSwitch
//
//  Created by Etong on 16/8/22.
//  Copyright © 2016年 Jdld. All rights reserved.
//

#import "JDSliderSwitch.h"

@interface JDSliderSwitch(){
    NSArray *stateArr;
    NSInteger oldItem;
    BOOL getSourse;
    BOOL fristItem;
}
@property (strong, nonatomic)NSMutableArray *statePoint;

@property (strong, nonatomic)UIView *backView;

@property (strong, nonatomic)UIButton *switchBtn;

@property (strong, nonatomic)UIImageView *indicator;

@property (strong, nonatomic)UIImageView *StateIV;

@end

@implementation JDSliderSwitch


- (instancetype)initWithFrame:(CGRect)frame stateImageArr:(NSArray *)imageArr {
    self = [super initWithFrame:frame];
    if (self) {
        getSourse = YES;
        fristItem = YES;
        _BeginAnimation = YES;
        stateArr = imageArr;
        [self createSubviews];
        [self commonInit];
    }
    return self;
}

- (void)createSubviews {
    _switchBtn = [[UIButton alloc]init];
    _backView = [[UIView alloc]init];
    _indicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"indicator"]];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [_switchBtn addGestureRecognizer:panGes];
    
    _switchBtn.backgroundColor = [UIColor whiteColor];
    _switchBtn.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    _switchBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _switchBtn.layer.shadowOpacity = YES;
    _backView.backgroundColor = [UIColor colorWithRed:233.f/255.f green:233.f/255.f blue:233.f/255.f alpha:1];
}

- (void)createStateImage:(NSArray *)imageArr {
    for (int i = 0; i < imageArr.count; i++) {
        _StateIV = [[UIImageView alloc]initWithImage:imageArr[i]];
    }
}

- (void)commonInit {
    [self.backView addSubview:self.switchBtn];
    [self addSubview:self.backView];
    [self addSubview:self.indicator];
}

- (void)layoutSubviews {
    _switchBtn.frame = CGRectMake(34, 2, _switchViewHeight - 4, _switchViewHeight - 4);
    _switchBtn.layer.cornerRadius = (_switchViewHeight - 4)/2;
    _backView.frame = CGRectMake(0, 10, self.frame.size.width, _switchViewHeight);
    _backView.layer.cornerRadius = _switchViewHeight/2;
    _indicator.frame = CGRectMake(_switchBtn.center.x - 4, _switchViewHeight + 12, 10, 10);
    
    float switchHeight = _switchViewHeight/2;
    if (stateArr.count == 2) {
        switchHeight = _switchViewHeight;
    }
    float stateImageInterval = ((self.frame.size.width - 60)/(stateArr.count - 1)) - (switchHeight);
    _statePoint = [NSMutableArray new];
    for (int i = 0; i < stateArr.count; i++) {
        _StateIV = [[UIImageView alloc]initWithImage:stateArr[i]];
        _StateIV.frame = CGRectMake(30 + stateImageInterval *i, _switchViewHeight + 30, _switchViewHeight, _switchViewHeight);
        CGPoint point = _StateIV.center;
        //将CGPoint转为NSString放入数组
        [_statePoint addObject:NSStringFromCGPoint(point)];
        [self addSubview:_StateIV];
    }
    
    if(_BeginAnimation){
        [self animationAction:_switchBtn point:[self.delegate setSelectHowManyGrades]];
    }else {
        CGPoint point = CGPointFromString(_statePoint[[self.delegate setSelectHowManyGrades]]);
        _switchBtn.center = CGPointMake(point.x, point.y - _switchViewHeight - 30);
    }
}

// 拖拽手势
- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    UIButton *btn = (UIButton *)gestureRecognizer.view;
    
    CGPoint velocity = [gestureRecognizer velocityInView:self];// 分别得出x，y轴方向的速度向量长度（velocity代表按照当前速度，每秒可移动的像素个数，分xy轴两个方向）
    
    // 基于速度和滑动因子计算终点
    CGPoint finalPoint = CGPointMake(btn.center.x + velocity.x ,
                                     btn.center.y + velocity.y );
    // 确定终点在视图边界内
    finalPoint.x = MIN(MAX(finalPoint.x, 0), self.bounds.size.width);
    finalPoint.y = MIN(MAX(finalPoint.y, 0), self.bounds.size.height);
    
    float oldFinal = 0.0;
    if (getSourse) {
        oldFinal = finalPoint.y;
        getSourse = NO;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:self];
    switch (gestureRecognizer.state) {

        case UIGestureRecognizerStateChanged:{

                btn.center = CGPointMake(gestureRecognizer.view.center.x + translation.x, gestureRecognizer.view.center.y + oldFinal);
                [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self];
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
         
            float stateImageInterval = ((self.frame.size.width - 60)/(stateArr.count - 1)) - (_switchViewHeight/2);
            float lineState = stateImageInterval/2 + 30 ;

            if (stateArr.count == 2) {
                if (gestureRecognizer.view.center.x + translation.x <= lineState + _switchViewHeight/2) {
                    [self animationAction:btn point:0];
                }else{
                    [self animationAction:btn point:1];
                }
            }
            
            if (stateArr.count == 3) {
                if (gestureRecognizer.view.center.x + translation.x < lineState + _switchViewHeight/2) {
                    [self animationAction:btn point:0];
                }else if (gestureRecognizer.view.center.x + translation.x >= lineState*2 +_switchViewHeight*1.5){
                    [self animationAction:btn point:2];
                }else {
                    [self animationAction:btn point:1];
                }
            }
            
            if (stateArr.count == 4) {
                if (gestureRecognizer.view.center.x + translation.x < lineState + _switchViewHeight/2) {
                    [self animationAction:btn point:0];
                }else if (gestureRecognizer.view.center.x + translation.x >= lineState + _switchViewHeight/2 && gestureRecognizer.view.center.x + translation.x < lineState*2 +_switchViewHeight/1.5){
                    [self animationAction:btn point:1];
                }else if (gestureRecognizer.view.center.x + translation.x > lineState*3 +_switchViewHeight) {
                    [self animationAction:btn point:3];
                }else{
                    [self animationAction:btn point:2];
                }
            }
            break;
        }
        default:
            break;
    }
}

- (void)animationAction:(UIButton *)btn point:(NSInteger)i {
    
    CGPoint point = CGPointFromString(_statePoint[i]);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        btn.center = CGPointMake(point.x, point.y - _switchViewHeight - 30);
        if (_indicatorAnimation){
            _indicator.center = CGPointMake(point.x, _switchViewHeight + 17);
        }
        if (oldItem != i && fristItem == NO) {
            [self.delegate switchActionChange:i+1];
            fristItem = YES;
        }
    } completion:nil];
    _indicator.center = CGPointMake(point.x, _switchViewHeight + 17);
    
    if (fristItem) {
        oldItem = i;
        fristItem = NO;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fitSize = [super sizeThatFits:size];
    
    return fitSize;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
