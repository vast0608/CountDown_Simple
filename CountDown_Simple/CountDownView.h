//
//  CountDownView.h
//  countdown
//
//  Created by KWAME on 15/8/10.
//  Copyright (c) 2015年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ENUM_FirstTimeIsEnd=100,//第一段时间结束
    ENUM_SecondTimeIsEnd,//第二段时间结束
//    ENUM_Null,//无操作
} ENUM_isEndTimeType;

@protocol timeChangeDelegate <NSObject>
- (void)timeChangeFirstTimeEndOrSecondTimeEnd:(NSInteger)currentEndTime;
@end

@interface CountDownView : UIView

- (id)initWithFrame:(CGRect)frame startTime:(NSString *)startString endTime:(NSString *)endString isHiddenBackGround:(BOOL)isHidden;

- (void)removeTimer;

@property (nonatomic,weak)id<timeChangeDelegate>delegate;//协议

@end
