//
//  CountDownView.h
//  countdown
//
//  Created by KWAME on 15/8/10.
//  Copyright (c) 2015年 autohome. All rights reserved.
//

#import "CountDownView.h"


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

static const CGFloat SCROLL_WIDTH = 93;
static const CGFloat LABEL_WIDTH = 8;
static const CGFloat ALL_HEIGHT = 15;
static const CGFloat FONT_SIZE = 11;

@interface CountDownView ()
{
    NSString *sec2;
    NSString *sec1;
    NSString *min2;
    NSString *min1;
    NSString *hour2;
    NSString *hour1;
    NSString *day2;
    NSString *day1;
    NSString *todate;
    NSTimer *timer;
    BOOL timeStart;
    
    NSString *enddata;

    NSInteger isFirstOrSecond;
    
    UIColor *textColor;//字体颜色
    UIColor *symboColor;//分割点颜色
    
    CGFloat SPACE_WIDTH;//间隙大小
    CGFloat DAY_SPACE_WIDTH;//间隙大小
}
//个位数label
@property (nonatomic, strong) UILabel *secondLabel1;
//十位数label
@property (nonatomic, strong) UILabel *secondLabel2;

@property (nonatomic, strong) UILabel *minuteLabel1;
@property (nonatomic, strong) UILabel *minuteLabel2;

@property (nonatomic, strong) UILabel *hourLabel1;
@property (nonatomic, strong) UILabel *hourLabel2;

@property (nonatomic, strong) UILabel *dayLabel1;
@property (nonatomic, strong) UILabel *dayLabel2;

@property (nonatomic, strong) UILabel *symbol1;
@property (nonatomic, strong) UILabel *symbol2;
@property (nonatomic, strong) UILabel *surplusDay;

@property (nonatomic, strong) UILabel *backLabel1;
@property (nonatomic, strong) UILabel *backLabel2;
@property (nonatomic, strong) UILabel *backLabel3;
@property (nonatomic, strong) UILabel *backLabel4;

@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIView *backView;

@end
@implementation CountDownView


- (id)initWithFrame:(CGRect)frame startTime:(NSString *)startString endTime:(NSString *)endString isHiddenBackGround:(BOOL)isHidden{
    
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
        todate = startString;
        enddata = endString;
        isFirstOrSecond = ENUM_FirstTimeIsEnd;
        [self isHidden:isHidden];
        [self setInitTimes];
        [self initKitViews:isHidden];
    }
    return self;
}
-(void)isHidden:(BOOL)isHidden{
    if (isHidden==NO) {
        SPACE_WIDTH = 9;
        DAY_SPACE_WIDTH = 11;
        textColor = [UIColor whiteColor];
        symboColor = [UIColor blackColor];
    }else{
        SPACE_WIDTH = 4;
        DAY_SPACE_WIDTH = 10;
        textColor = [UIColor whiteColor];
        symboColor = [UIColor whiteColor];
    }
}
- (void)setInitTimes {
    [self addSubview:self.backView];
    timeStart = YES;
    [self setBackgroundColor:[UIColor clearColor]];
   
    NSDate *date = [NSDate date];

    //设置的时间小于当天时间
    if ([self timeIntervalFromDate:nil stringDate:todate] <=
        [self timeIntervalFromDate:date stringDate:nil])
    {
        NSLog(@"倒计时结束");
        dispatch_async(dispatch_get_main_queue(), ^{//刚开始加载时间执行的
            [self removeTimer];//移除时间
            [_delegate timeChangeFirstTimeEndOrSecondTimeEnd:isFirstOrSecond];
            if (isFirstOrSecond==ENUM_FirstTimeIsEnd) {
                todate = enddata;//当第一段时间结束后进行时间替换，把第二段时间赋值给todate
                [self setInitTimes];//回调用来初始化并重新开始计时
                isFirstOrSecond = ENUM_SecondTimeIsEnd;
                NSLog(@"结结结结结结结结结");
            }else{
                [self setTimeLabelText];//把时间设置为0
                NSLog(@"经经经经经经经经经");
            }
        });
    }
    else
    {
        [self timerFireMethod:nil];
        
        //每一秒执行一次
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(timerFireMethod:)
                                               userInfo:nil
                                                repeats:YES];
        //设置计时器的优先级，否则放在tableView中，计时器将会停止。
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)initKitViews:(BOOL)isHidden {
    if (isHidden==NO) {
        [self initBackView];
    }
    
    [self.backView addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.secondLabel1];
    [self.backScrollView addSubview:self.secondLabel2];
    [self.backScrollView addSubview:self.minuteLabel1];
    [self.backScrollView addSubview:self.minuteLabel2];
    [self.backScrollView addSubview:self.hourLabel1];
    [self.backScrollView addSubview:self.hourLabel2];
    [self.backScrollView addSubview:self.dayLabel1];
    [self.backScrollView addSubview:self.dayLabel2];
    [self.backScrollView addSubview:self.surplusDay];
    [self.backScrollView addSubview:self.symbol1];
    [self.backScrollView addSubview:self.symbol2];
}

//计时器
- (void)timerFireMethod:(NSTimer *)theTimer
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *endTime = [[NSDateComponents alloc] init];
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateString = [dateFormatter dateFromString:todate];
    NSString *overdate = [dateFormatter stringFromDate:dateString];
    static int year;
    static int month;
    static int day;
    static int hour;
    static int minute;
    static int second;
    if(timeStart) {//从NSDate中取出年月日，时分秒，但是只能取一次
        year = [[overdate substringWithRange:NSMakeRange(0, 4)] intValue];
        month = [[overdate substringWithRange:NSMakeRange(5, 2)] intValue];
        day = [[overdate substringWithRange:NSMakeRange(8, 2)] intValue];
        hour = [[overdate substringWithRange:NSMakeRange(11, 2)] intValue];
        minute = [[overdate substringWithRange:NSMakeRange(14, 2)] intValue];
        second = [[overdate substringWithRange:NSMakeRange(17, 2)] intValue];
        timeStart= NO;
    }
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:day];
    [endTime setHour:hour];
    [endTime setMinute:minute];
    [endTime setSecond:second];
    
    NSDate *overTime = [cal dateFromComponents:endTime]; //把目标时间装载入date
    
    //用来得到具体的时差，是为了统一成北京时间
    unsigned int unitFlags =  NSCalendarUnitDay| NSCalendarUnitHour| NSCalendarUnitMinute| NSCalendarUnitSecond;
    NSDateComponents *dateComponets = [cal components:unitFlags fromDate:today toDate:overTime options:0];
    //NSLog(@"----%@",dateComponets);
    if([dateComponets second] <= 0 &&
       [dateComponets hour] <= 0 &&
       [dateComponets minute] <= 0 &&
       [dateComponets day] <= 0) {
        //计时器失效
        [theTimer invalidate];//移除时间
        [self removeTimer];//移除时间
        //计时结束 do_something
        dispatch_async(dispatch_get_main_queue(), ^{//运行过程中执行的
            NSLog(@"已结束");
            //代理方法
            [_delegate timeChangeFirstTimeEndOrSecondTimeEnd:isFirstOrSecond];
            if (isFirstOrSecond==ENUM_FirstTimeIsEnd) {
                todate = enddata;//当第一段时间结束后进行时间替换，把第二段时间赋值给todate
                [self setInitTimes];//回调用来初始化并重新开始计时
                isFirstOrSecond = ENUM_SecondTimeIsEnd;
                NSLog(@"束束束束束束束束");
            }else{
                [self setTimeLabelText];//把时间设置为0
                NSLog(@"已已已已已已已已");
            }
        });
        
    } else{
        //计时尚未结束，do_something.
        [self changeScrollViewAnimationWithDateComponets:dateComponets];
    }
}
- (void) setTimeLabelText {
    [self.secondLabel1 setText:@"0"];
    [self.secondLabel2 setText:@"0"];
    [self.minuteLabel1 setText:@"0"];
    [self.minuteLabel2 setText:@"0"];
    [self.hourLabel1 setText:@"0"];
    [self.hourLabel2 setText:@"0"];
    [self.dayLabel1 setText:@"0"];
    [self.dayLabel2 setText:@"0"];
}
- (void) removeTimer {
    [timer invalidate];
    timer=nil;
    //NSLog(@"计时器终结");
}

#pragma mark - 设置动画效果
- (void) changeScrollViewAnimationWithDateComponets:(NSDateComponents *)dateComponets {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *dateString = [dateFormatter dateFromString:todate];
    NSInteger day;
    if ([dateComponets day]>99) {
        day = 99;
    }else{
        day = [dateComponets day];
    }
    NSString *s_day = [NSString stringWithFormat:@"%02zd", day];
    NSString *s_hour = [NSString stringWithFormat:@"%02zd", [dateComponets hour]];
    NSString *s_minute = [NSString stringWithFormat:@"%02zd", [dateComponets minute]];
    NSString *s_second = [NSString stringWithFormat:@"%02zd", [dateComponets second]];
    //设置秒数和动画
    [self setAnimationSecond:s_second];
    //设置分钟和动画
    [self setAnimationMinute:s_minute];
    //设置小时和动画
    [self setAnimationHour:s_hour];
    //设置天数和动画
    [self setAnimationDay:s_day];
}
- (void) initBackView {
    _backLabel1 = [[UILabel alloc]init];
    _backLabel1.frame = CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*2, 0, LABEL_WIDTH*2, ALL_HEIGHT);
    _backLabel1.layer.cornerRadius = 2;
    _backLabel1.clipsToBounds = YES;
    _backLabel1.backgroundColor = [UIColor blackColor];
    [self.backScrollView addSubview:_backLabel1];
    
    _backLabel2 = [[UILabel alloc]init];
    _backLabel2.frame = CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*4-SPACE_WIDTH, 0, LABEL_WIDTH*2, ALL_HEIGHT);
    _backLabel2.layer.cornerRadius = 2;
    _backLabel2.clipsToBounds = YES;
    _backLabel2.backgroundColor = [UIColor blackColor];
    [self.backScrollView addSubview:_backLabel2];
    
    _backLabel3 = [[UILabel alloc]init];
    _backLabel3.frame = CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*6-SPACE_WIDTH*2, 0, LABEL_WIDTH*2, ALL_HEIGHT);
    _backLabel3.layer.cornerRadius = 2;
    _backLabel3.clipsToBounds = YES;
    _backLabel3.backgroundColor = [UIColor blackColor];
    [self.backScrollView addSubview:_backLabel3];
    
    _backLabel4 = [[UILabel alloc]init];
    _backLabel4.frame = CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*8-SPACE_WIDTH*2-DAY_SPACE_WIDTH, 0, LABEL_WIDTH*2, ALL_HEIGHT);
    _backLabel4.layer.cornerRadius = 2;
    _backLabel4.clipsToBounds = YES;
    _backLabel4.backgroundColor = [UIColor blackColor];
    [self.backScrollView addSubview:_backLabel4];
}
- (void) setAnimationSecond:(NSString *)s_second {
    sec2 = [s_second substringToIndex:1];
    sec1 = [self firstStrForString:s_second];
    
    [self.secondLabel1 setText:sec1];
    [self startAnimationWithLayer:self.secondLabel1.layer];
    [self.secondLabel2 setText:sec2];
    if ([sec1 integerValue] == 9) {
        [self startAnimationWithLayer:self.secondLabel2.layer];
    }
}

- (void) setAnimationMinute:(NSString *)s_minute {
    min2 = [s_minute substringToIndex:1];
    min1 = [self firstStrForString:s_minute];
    [self.minuteLabel1 setText:min1];
    //满足秒数为59时才执行一次
    if ([sec2 integerValue] == 5 &&
        [sec1 integerValue] == 9) {
        [self startAnimationWithLayer:self.minuteLabel1.layer];
    }
    [self.minuteLabel2 setText:min2];
    //满足秒数为59 分钟个位数为9时才执行
    if ([min1 integerValue] == 9 &&
        [sec2 integerValue] == 5 &&
        [sec1 integerValue] ==9) {
        [self startAnimationWithLayer:self.minuteLabel2.layer];
    }
}
- (void) setAnimationHour:(NSString *)s_hour {
    hour2 = [s_hour substringToIndex:1];
    hour1 = [self firstStrForString:s_hour];
    [self.hourLabel1 setText:hour1];
    if ([min2 integerValue] == 5 &&
        [min1 integerValue] == 9 &&
        [sec2 integerValue] == 5 &&
        [sec1 integerValue] ==9) {
        [self startAnimationWithLayer:self.hourLabel1.layer];
    }
    [self.hourLabel2 setText:hour2];
    if ([hour1 integerValue] == 9 &&
        [min2 integerValue] == 5 &&
        [min1 integerValue] == 9 &&
        [sec2 integerValue] == 5 &&
        [sec1 integerValue] ==9) {
    }
}
- (void) setAnimationDay:(NSString *)s_day {
    day2 = [s_day substringToIndex:1];
    day1 = [self firstStrForString:s_day];
    [self.dayLabel1 setText:day1];
    if ([hour2 integerValue] == 2 &&
        [hour1 integerValue] == 9 &&
        [min2 integerValue] == 5 &&
        [min1 integerValue] == 9 &&
        [sec2 integerValue] == 5 &&
        [sec1 integerValue] ==9) {
        [self startAnimationWithLayer:self.dayLabel1.layer];
    }
    [self.dayLabel2 setText:day2];
    if ([day1 integerValue] == 9 &&
        [hour2 integerValue] == 2 &&
        [hour1 integerValue] == 9 &&
        [min2 integerValue] == 5 &&
        [min1 integerValue] == 9 &&
        [sec2 integerValue] == 5 &&
        [sec1 integerValue] ==9) {
        [self startAnimationWithLayer:self.dayLabel2.layer];
    }
}
- (NSString *) firstStrForString:(NSString *)string {
    unichar sub1 = [string characterAtIndex:1];
    NSString *sec =[NSString stringWithCharacters:&sub1 length:1];
    return sec;
}
//时间向上滑动的效果
- (void) startAnimationWithLayer:(CALayer *)layer {
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 0.5f;
    //先慢后快
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [layer addAnimation:animation forKey:@"pageCurl"];
}

- (NSTimeInterval) timeIntervalFromDate:(NSDate *)date stringDate:(NSString *)strDate {
    NSInteger fitstDate;
    if (date == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateString = [dateFormatter dateFromString:strDate];
        NSInteger intv = [[NSString stringWithFormat:@"%.0f",[dateString timeIntervalSince1970]] integerValue];
        fitstDate = intv;
    }else{
        NSInteger intv = [[NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]] integerValue];
        fitstDate = intv;
    }
    return fitstDate;
}
#pragma mark - 时间控件初始化
//时间控件总宽度为65 高度为15
- (UIScrollView *)backScrollView {
    if (_backScrollView == nil) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(_backView.frame.size.width-SCROLL_WIDTH, 0, SCROLL_WIDTH, ALL_HEIGHT)];
        _backScrollView.backgroundColor = [UIColor clearColor];
    }
    return _backScrollView;
}

- (UILabel *)secondLabel1 {
    if (_secondLabel1 == nil) {
        _secondLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_secondLabel1 setBackgroundColor:[UIColor clearColor]];
        [_secondLabel1 setTextAlignment:NSTextAlignmentLeft];
        [_secondLabel1 setTextColor:textColor];
        [_secondLabel1 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _secondLabel1;
}

- (UILabel *)secondLabel2 {
    if (_secondLabel2 == nil) {
        _secondLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*2, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_secondLabel2 setBackgroundColor:[UIColor clearColor]];
        [_secondLabel2 setTextAlignment:NSTextAlignmentRight];
        [_secondLabel2 setTextColor:textColor];
        [_secondLabel2 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _secondLabel2;
}

- (UILabel *)minuteLabel1 {
    if (_minuteLabel1 == nil) {
        _minuteLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*3-SPACE_WIDTH, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_minuteLabel1 setBackgroundColor:[UIColor clearColor]];
        [_minuteLabel1 setTextAlignment:NSTextAlignmentLeft];
        [_minuteLabel1 setTextColor:textColor];
        [_minuteLabel1 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _minuteLabel1;
}

- (UILabel *)minuteLabel2 {
    if (_minuteLabel2 == nil) {
        _minuteLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*4-SPACE_WIDTH, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_minuteLabel2 setBackgroundColor:[UIColor clearColor]];
        [_minuteLabel2 setTextAlignment:NSTextAlignmentRight];
        [_minuteLabel2 setTextColor:textColor];
        [_minuteLabel2 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _minuteLabel2;
}
- (UILabel *)hourLabel1 {
    if (_hourLabel1 == nil) {
        _hourLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*5-SPACE_WIDTH*2, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_hourLabel1 setBackgroundColor:[UIColor clearColor]];
        [_hourLabel1 setTextAlignment:NSTextAlignmentLeft];
        [_hourLabel1 setTextColor:textColor];
        [_hourLabel1 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _hourLabel1;
}

- (UILabel *)hourLabel2 {
    if (_hourLabel2 == nil) {
        _hourLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*6-SPACE_WIDTH*2, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_hourLabel2 setBackgroundColor:[UIColor clearColor]];
        [_hourLabel2 setTextAlignment:NSTextAlignmentRight];
        [_hourLabel2 setTextColor:textColor];
        [_hourLabel2 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _hourLabel2;
}

- (UILabel *)dayLabel1 {
    if (_dayLabel1 == nil) {
        _dayLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*7-SPACE_WIDTH*2-DAY_SPACE_WIDTH, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_dayLabel1 setBackgroundColor:[UIColor clearColor]];
        [_dayLabel1 setTextAlignment:NSTextAlignmentLeft];
        [_dayLabel1 setTextColor:textColor];
        [_dayLabel1 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _dayLabel1;
}

- (UILabel *)dayLabel2 {
    if (_dayLabel2 == nil) {
        _dayLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*8-SPACE_WIDTH*2-DAY_SPACE_WIDTH, 0, LABEL_WIDTH, ALL_HEIGHT)];
        [_dayLabel2 setBackgroundColor:[UIColor clearColor]];
        [_dayLabel2 setTextAlignment:NSTextAlignmentRight];
        [_dayLabel2 setTextColor:textColor];
        [_dayLabel2 setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    }
    return _dayLabel2;
}


- (UILabel *)symbol1 {
    if (_symbol1 == nil) {
        _symbol1 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*2-SPACE_WIDTH, 0, SPACE_WIDTH, ALL_HEIGHT-2)];
        [_symbol1 setBackgroundColor:[UIColor clearColor]];
        [_symbol1 setTextAlignment:NSTextAlignmentCenter];
        [_symbol1 setTextColor:symboColor];
        [_symbol1 setFont:[UIFont systemFontOfSize:13]];
        [_symbol1 setText:@":"];
    }
    return _symbol1;
}
- (UILabel *)symbol2 {
    if (_symbol2 == nil) {
        _symbol2 = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*4-SPACE_WIDTH*2, 0, SPACE_WIDTH, ALL_HEIGHT-2)];
        [_symbol2 setBackgroundColor:[UIColor clearColor]];
        [_symbol2 setTextAlignment:NSTextAlignmentCenter];
        [_symbol2 setTextColor:symboColor];
        [_symbol2 setFont:[UIFont systemFontOfSize:13]];
        [_symbol2 setText:@":"];
    }
    return _symbol2;
}
- (UILabel *)surplusDay {
    if (_surplusDay == nil) {
        _surplusDay = [[UILabel alloc]initWithFrame:CGRectMake(SCROLL_WIDTH-LABEL_WIDTH*6-SPACE_WIDTH*2-DAY_SPACE_WIDTH, 1, DAY_SPACE_WIDTH, ALL_HEIGHT-1)];
        [_surplusDay setBackgroundColor:[UIColor clearColor]];
        [_surplusDay setTextAlignment:NSTextAlignmentCenter];
        [_surplusDay setTextColor:symboColor];
        [_surplusDay setFont:[UIFont systemFontOfSize:9]];
        [_surplusDay setText:@"天"];
    }
    return _surplusDay;
}
- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        [_backView setBackgroundColor:[UIColor blueColor]];
    }
    return _backView;
}
#pragma mark -
@end
