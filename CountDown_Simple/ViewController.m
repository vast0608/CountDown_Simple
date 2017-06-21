//
//  ViewController.m
//  CountDown_Simple
//
//  Created by 上海烨历网络科技有限公司 on 2017/6/21.
//  Copyright © 2017年 上海烨历网络科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "CountDownView.h"
@interface ViewController ()<timeChangeDelegate>
@property(nonatomic,strong)CountDownView *countDown;//倒计时
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化countDownView 设置倒计时终止时间。
    _countDown = [[CountDownView alloc]initWithFrame:CGRectMake(21, 80, 91, 15) startTime:@"2017-06-08 12:00:00" endTime:@"2018-06-08 12:00:00" isHiddenBackGround:NO];
    _countDown.delegate = self;
    [self.view addSubview:_countDown];
    //注：时间差大于99天的，统一按99天处理，只能显示两位数
}
-(void)timeChangeFirstTimeEndOrSecondTimeEnd:(NSInteger)currentEndTime{
    if (currentEndTime == ENUM_FirstTimeIsEnd) {//到了第一个时间点
        NSLog(@"时间正好到2017-06-08 12:00:00");
    }else if (currentEndTime == ENUM_SecondTimeIsEnd){//到了第二个时间点
        NSLog(@"时间正好到2018-06-08 12:00:00");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
