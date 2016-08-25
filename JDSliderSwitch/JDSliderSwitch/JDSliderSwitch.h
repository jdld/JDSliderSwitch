//
//  JDSliderSwitch.h
//  JDSliderSwitch
//
//  Created by Etong on 16/8/22.
//  Copyright © 2016年 Jdld. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JDSliderSwitchDelegate <NSObject>

@optional
/**
 * 更改按钮位置回调
 */
- (void)switchActionChange:(NSInteger)indexRow;

- (NSInteger)setSelectHowManyGrades;

@end


@interface JDSliderSwitch : UIView

@property (nonatomic, assign) id<JDSliderSwitchDelegate> delegate;

/**
 *  初始化JDSliderSwitch
 *
 *  @param frame  JDSliderSwitch的frame
 *  @param imageArr 档位图片数组
 *
 *  @return   JDMoviePlayer
 */
- (instancetype)initWithFrame:(CGRect)frame stateImageArr:(NSArray *)imageArr;

/**
 * 设置背景框的高
 */
@property (nonatomic)float switchViewHeight;

/**
 * 设定指针移动是否有动画
 */
@property (nonatomic)BOOL indicatorAnimation;

/**
 * 设定开头定位是否有动画
 */
@property (nonatomic)BOOL BeginAnimation;


@end
