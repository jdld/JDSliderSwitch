//
//  ViewController.m
//  JDSliderSwitch
//
//  Created by Etong on 16/8/22.
//  Copyright © 2016年 Jdld. All rights reserved.
//

#import "ViewController.h"
#import "JDSliderSwitch.h"

@interface ViewController ()<JDSliderSwitchDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *imageArr = @[[UIImage imageNamed:@"refresh1"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh2"],[UIImage imageNamed:@"refresh1"]];
    JDSliderSwitch *sliderView = [[JDSliderSwitch alloc]initWithFrame:CGRectMake(100, 100, 300, 30) stateImageArr:imageArr];
    sliderView.center = self.view.center;
    sliderView.switchViewHeight = 30;
    sliderView.indicatorAnimation = NO;
    sliderView.delegate = self;
    
    
    [self.view addSubview:sliderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JDSliderSwitchDelegate
- (void)switchActionChange:(NSInteger)indexRow {
    NSLog(@"更改至%ld档风",(long)indexRow);
}

- (NSInteger)setSelectHowManyGrades {
    return 2;
}

@end
