//
//  ZJMensesInfo.m
//  Test
//
//  Created by ZJ on 12/30/15.
//  Copyright © 2015 ZJ. All rights reserved.
//

#import "ZJMensesInfo.h"
#import "ZJMenstrualDateInfo.h"

@implementation NSDate (CompareDate)

- (BOOL)isEqualToDate:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *str1 = [format stringFromDate:self];
    NSString *str2 = [format stringFromDate:date];
    if ([str1 isEqualToString:str2]) {
        return YES;
    }
    
    return NO;
}

+ (NSDateComponents *)getComponentsWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    return comps;
}

+ (NSDate *)getDateWithDaySpan:(NSInteger)daySpan sinceDate:(NSDate *)date {
    return [NSDate dateWithTimeInterval:24*3600*daySpan sinceDate:date];
}

- (NSInteger)getDaySpanSinceDate:(NSDate *)date {
    float span = [self timeIntervalSinceDate:date] / (3600*24);
    if (span > 0) {
        if (span + 0.1 > ceil(span)) {
            span += 0.1;
        }
    }
    
    return (NSInteger)span;
}

@end

@interface ZJMensesInfo ()

/**
 *  黄体期持续天数:月经后 一般为2天，根据月经持续时间和前7后8计算
 */
@property (nonatomic, assign) NSInteger lutealDurationAfterMenses;

/**
 *  当月 月经信息总天数
 */
@property (nonatomic, assign) NSInteger mensesTotalDuration;

/**
 *  排卵日:要算出唯一的一个进行概率计算
 */
@property (nonatomic, strong, readonly) NSDate *ovumDay;

/**
 *  排卵日:月经后
 */
@property (nonatomic, strong, readonly) NSDate *ovumDayAfterMenses;

/**
 *  排卵日:月经前
 */
@property (nonatomic, strong, readonly) NSDate *ovumDayBeforeMenses;

/**
 *  当日的类型
 */
@property (nonatomic, assign) MensesInfoType mensesInfoTypeOfToday;

@end

#define C1 0.45             //  周期推算法:占比

#define EmptyDuration 3     //  填充的天数
#define MensesDuration 7    //  月经默认持续天数
#define MensesCycle 28      //  月经默认周期
#define OvumDuration 10     //  排卵期默认天数
#define LutealDuration 9    //  黄体期天数:月经前的

@implementation ZJMensesInfo

@synthesize mensesInfos = _mensesInfos;
@synthesize ovumDay = _ovumDay;
@synthesize ovumDayAfterMenses = _ovumDayAfterMenses;
@synthesize ovumDayBeforeMenses = _ovumDayBeforeMenses;

#pragma mark -  初始化方法

- (instancetype)init {
    self = [super init];
    if (self) {
        /*
         该对象的默认值设置不能用属性赋值,只能使用实例变量,因为调用setter方法会调用resetValue方法
         */
        _beganDate = [NSDate date];
        self.mensesDuration = MensesDuration;
        _cycle = MensesCycle;
    }
    return self;
}

- (ZJMensesInfo *)initWithBeganDate:(NSDate *)beganDate mensesDuraton:(NSInteger)duration cycle:(NSInteger)cycle {
    self = [super init];
    if (self) {
        if (beganDate) {
            _beganDate = beganDate;//[NSDate getDateWithDaySpan:21 sinceDate:[NSDate date]];//
        }else {
            _beganDate = [NSDate date];
        }
        
        if (duration > 0) {
            self.mensesDuration = duration;
        }else {
            self.mensesDuration = MensesDuration;
        }
        
        if (cycle > 0) {
            _cycle = cycle;
        }else {
            _cycle = MensesCycle;
        }
    }
    
    return self;
}

#pragma mark - setter

/**
 重新对_beganDate、_duration、_cycle任一值赋值，都调用resetValue方法
 */
- (void)setBeganDate:(NSDate *)beganDate {
    if (!beganDate) {
        beganDate = [NSDate date];
    }
    _beganDate = beganDate;
    
    [self resetValue];
}

- (void)setMensesDuration:(NSInteger)mensesDuration {
    if (mensesDuration <= 0) {
        mensesDuration = MensesDuration;
    }
    _mensesDuration = mensesDuration;
    
    [self resetValue];
}

- (void)setCycle:(NSInteger)cycle {
    if (cycle <= 0) {
        cycle = MensesCycle;
    }
    _cycle = cycle;
    
    [self resetValue];
}

/**
 *  体温数组元素个数:2个,当天体温和前一天体温
 *  @param temps 根据体温算出排卵概率
 */
- (void)setTemps:(NSArray *)temps {
    _temps = temps;
    
    if (_temps.count >= 2) {
        for (ZJMenstrualDateInfo *info in self.mensesInfos) {
            if (info.isToDay) {
                info.ovumProbability = [self getOvumProbability];
                break;
            }
        }
    }
}

#pragma mark - getter

/**
 *  排卵日D= d1+n-14
 */
- (NSDate *)ovumDay {
    if (!_ovumDay) {
        if (labs([self.ovumDayAfterMenses getDaySpanSinceDate:[NSDate date]]) <= labs([self.ovumDayBeforeMenses getDaySpanSinceDate:[NSDate date]])) {
            _ovumDay = [self.ovumDayAfterMenses copy];
        }else {
            _ovumDay = [self.ovumDayBeforeMenses copy];
        }
    }
    return _ovumDay;
}

- (NSDate *)ovumDayAfterMenses {
    if (!_ovumDayAfterMenses) {
        _ovumDayAfterMenses = [NSDate getDateWithDaySpan:self.cycle-14 sinceDate:_beganDate];
    }
    return _ovumDayAfterMenses;
}

- (NSDate *)ovumDayBeforeMenses {
    if (!_ovumDayBeforeMenses) {
        _ovumDayBeforeMenses = [NSDate getDateWithDaySpan:-(self.cycle-14) sinceDate:_beganDate];
    }
    
    return _ovumDayBeforeMenses;
}

/**
 *  前七后八,包含月经当天共9天
 */
- (NSInteger)lutealDurationAfterMenses {
    _lutealDurationAfterMenses = 9 - self.mensesDuration;
    
    return _lutealDurationAfterMenses;
}

- (NSArray *)mensesInfos {
    if (!_mensesInfos) {
        NSMutableArray *ary = [NSMutableArray array];
        NSInteger count = 0;
        if (self.mensesInfoTypeOfToday == MensesInfoTypeOfMenstrual) {                  // 经期
            count = self.mensesDuration + self.lutealDurationAfterMenses + OvumDuration;
        }else if (self.mensesInfoTypeOfToday == MensesInfoTypeOfLutealBeforeMenses) {   // 黄体期
            count = self.mensesDuration + self.lutealDurationAfterMenses;
        }else if (self.mensesInfoTypeOfToday == MensesInfoTypeOfOvumRelease) {          // 排卵期
            count = self.mensesDuration;        /// 当出现两个月经期会出错
        }else {
            count = self.mensesDuration + self.lutealDurationAfterMenses + OvumDuration + LutealDuration;
        }
        count += EmptyDuration;
        
        for (int i = 0; i < self.mensesTotalDuration; i++) {
            ZJMenstrualDateInfo *info = [ZJMenstrualDateInfo new];
            [ary addObject:info];
            
            info.date = [NSDate getDateWithDaySpan:(i - (self.mensesTotalDuration - count)) sinceDate:_beganDate];
            if (i < 3 || i >= self.mensesTotalDuration - 3) {
                info.type = MensesInfoTypeOfDefault;
            }else {
                info.type = [self getMensesInfoTypeWithDate:info.date];
            }
            
            if ([info.date isEqualToDate:self.ovumDayAfterMenses] || [info.date isEqualToDate:self.ovumDayBeforeMenses]) {
                info.isOvumDay = YES;
                if ([info.date isEqualToDate:self.ovumDayAfterMenses]) {
                    info.isNextOvumDay = YES;
                }
            }
            info.isToDay = [info.date isEqualToDate:[NSDate date]];
        }
        
        _mensesInfos = [ary copy];
    }
    return _mensesInfos;
}

/**
 *  获取某个日期的MensesType
 */
- (MensesInfoType)getMensesInfoTypeWithDate:(NSDate *)date {
    NSInteger span = [date getDaySpanSinceDate:_beganDate];
    if (span >= 0) {    /// _beganDate --> date，从月经开始时间向后数
        if (span < self.mensesDuration) {
            return MensesInfoTypeOfMenstrual;
        }else if (span < self.mensesDuration + self.lutealDurationAfterMenses) {
            return MensesInfoTypeOfLutealAfterMenses;
        }else if (span < self.mensesDuration + self.lutealDurationAfterMenses + OvumDuration) {
            return MensesInfoTypeOfOvumRelease;
        }else {
            return MensesInfoTypeOfLutealAfterMenses;
        }
    }else {
        NSInteger span2 = labs(span);
        if (span2 <= LutealDuration) {                       // 9
            return MensesInfoTypeOfLutealBeforeMenses;
        }else if (span2 <= LutealDuration + OvumDuration) {  // 19
            return MensesInfoTypeOfOvumRelease;
        }else if (span2 <= LutealDuration + OvumDuration + self.lutealDurationAfterMenses) { // 21
            return MensesInfoTypeOfLutealAfterMenses;
        }else {
            return MensesInfoTypeOfMenstrual;
        }
    }
}

/**
 *  总天数
 */
- (NSInteger)mensesTotalDuration {
    if (_mensesTotalDuration <= 0) {
        if (self.mensesInfoTypeOfToday == MensesInfoTypeOfLutealAfterMenses) {
            _mensesTotalDuration = LutealDuration*2 + self.mensesDuration + OvumDuration + self.lutealDurationAfterMenses;
        }else if (self.mensesInfoTypeOfToday == MensesInfoTypeOfOvumRelease) {          /// OK
            _mensesTotalDuration =  self.mensesDuration*2 + self.lutealDurationAfterMenses + OvumDuration + LutealDuration;
        }else if (self.mensesInfoTypeOfToday == MensesInfoTypeOfLutealBeforeMenses) {   /// OK
            _mensesTotalDuration =  self.lutealDurationAfterMenses*2 + OvumDuration + LutealDuration + self.mensesDuration;
        }else {                                                                         /// OK
            _mensesTotalDuration = OvumDuration*2 + LutealDuration +self.lutealDurationAfterMenses + self.mensesDuration;
        }
        
        _mensesTotalDuration += 2*EmptyDuration;
    }
    
    return _mensesTotalDuration;
}

/**
 *  当天的MensesType
 */
- (MensesInfoType)mensesInfoTypeOfToday {
    /// 月经开始时间离今天有几天
    if (_mensesInfoTypeOfToday <= 0) {
        NSInteger span = [_beganDate getDaySpanSinceDate:[NSDate date]] % self.cycle;
        if (span > 0) {     // 今天 --> 月经开始时间, 从月经开始时间向后数
            if (span <= LutealDuration) {                           // 9
                _mensesInfoTypeOfToday = MensesInfoTypeOfLutealBeforeMenses;
            }else if (span <= LutealDuration + OvumDuration) {      // 19
                _mensesInfoTypeOfToday = MensesInfoTypeOfOvumRelease;
                
            }else if (span <= LutealDuration + OvumDuration + self.lutealDurationAfterMenses) {
                _mensesInfoTypeOfToday = MensesInfoTypeOfLutealAfterMenses;
                
                NSInteger sp = [_beganDate getDaySpanSinceDate:[NSDate date]];
                if (sp > OvumDuration + LutealDuration) {
                    _beganDate = [NSDate getDateWithDaySpan:-self.cycle sinceDate:_beganDate];
                }
            }else {
                _mensesInfoTypeOfToday = MensesInfoTypeOfMenstrual; /// 出现这种情况:当天是2月1号-7号，began=2月29
                _beganDate = [NSDate getDateWithDaySpan:-self.cycle sinceDate:_beganDate];  // 29号 --> 1号
            }
        }else {             // 经期 --> 今天
            NSInteger sp = labs(span);
            if (sp < self.mensesDuration) {                                         // 7
                _mensesInfoTypeOfToday = MensesInfoTypeOfMenstrual;
            }else if (sp < self.mensesDuration + self.lutealDurationAfterMenses) {  // 9
                _mensesInfoTypeOfToday = MensesInfoTypeOfLutealAfterMenses;
            }else if (sp < self.mensesDuration + self.lutealDurationAfterMenses + OvumDuration) {   // 19
                _mensesInfoTypeOfToday = MensesInfoTypeOfOvumRelease;
                
                NSInteger sp2 = [self.ovumDay getDaySpanSinceDate:_beganDate];  /// 出现两个月经开始时间的时候选择后一个
                if (sp2 > 0) {
                    _beganDate = [NSDate getDateWithDaySpan:self.cycle sinceDate:_beganDate];
                }
            }else if (sp < self.lutealDurationAfterMenses + OvumDuration + LutealDuration) {
                _mensesInfoTypeOfToday = MensesInfoTypeOfLutealBeforeMenses;
            }else {
                _mensesInfoTypeOfToday = MensesInfoTypeOfMenstrual;
                _beganDate = [NSDate getDateWithDaySpan:self.cycle sinceDate:_beganDate];   ///出现这种情况:began在上个月，今天在下个月
            }
        }
    }
    
    return _mensesInfoTypeOfToday;
}

/**
 *  @param date  排卵期内某日的date
 *  @param index 计算P2的时候需要, 计算P1不需要
 *
 *  @return P1 + P2
 */
- (float)getOvumProbability {
    float P1 = [self getCycleProbility];                        // 根据排卵周期推算
    float P2 = [self getTempProbilityWithCycleProbility:P1];    // 根据体温推算
    
    return P1 + P2;
}

- (float)getCycleProbility {
    float P1 = 0;
    
    long span = labs([self.ovumDay getDaySpanSinceDate:[NSDate date]]);
    if (span <= OvumDuration) {
        P1 = C1 - span*0.1;
        if (P1 <= FLT_EPSILON) {
            P1 = 0.01;
        }
    }else {
        P1 = 0.01;
    }
    
    return P1;
}

/**
 *  当天体温Tnow, 前一天体温Tbefore
 */
- (float)getTempProbilityWithCycleProbility:(float)P1 {
    float P2 = 0;
    
    float tBefore = [_temps[0] floatValue];
    float tNow = [_temps[1] floatValue];
    float span = tNow - tBefore;
    
    if (span > 0.4) {
        span = 0.4;
    }
    span -= 0.1;
    if (span > 0) {
        P2 = P1*(span*3);
    }
    
    return P2;
}

- (void)resetValue {
    _ovumDay = nil;
    _ovumDayAfterMenses = nil;
    _ovumDayBeforeMenses = nil;
    _mensesInfos = nil;
    _mensesTotalDuration = 0;
    _mensesInfoTypeOfToday = MensesInfoTypeOfDefault;
}

/*
 排卵概率算法(结果单位:百分比):
 周期推算法:占比c1=45%
 体温推算法:占比c2=45%
 P=P1+P2
 
 周期推算法(结果单位:百分比):
 本次月经第一天d1(已知,用户每次输入,或用上次输入根据周期推算,至少有一次输入)
 月经周期n(已知,首次必须输入)
 排卵日D= d1+n-14
 当前排卵日期now
 if(|now-D|<=5)
 {
 P1=c1-|now-D|*10%
 if(P1<0)
 {
 P1=0%;
 }
 }
 else
 {
 P1=0%;
 }
 */
/*
 体温推算法(结果单位:百分比):
 本次月经第一天d1(同周期推算法)
 月经周期n(同周期推算法)
 月经开始的每天体温(T1......T15)
 月经期平均体温Tavg=avg(T1+T2+T3+T4+T5)
 当天体温Tnow
 前一天体温Tbefore
 排卵概率P1(由周期推算法得出)
 span = Tnow - Tbefore;
 if(span>0.4)
 {
 span=0.4
 }
 span—;
 if(span>0)
 {
 P2 = P1*(span*3)  [P2 > 0]
 }
 else
 {
 P2=0%
 }
 */
@end
