//
//  SILogger.h
//  SILog
//
//  Created by sincere on 16/9/12.
//  Copyright © 2016年 cofortune. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"
#import "DDASLLogger.h"

typedef NS_ENUM(UInt8, SILogLevel) {
    SILogLevelDEBUG         = 1,
    SILogLevelINFO          = 2,
    SILogLevelWARN          = 3,
    SILogLevelERROR         = 4,
    SILogLevelOFF           = 5,
};

#if DEBUG
#define __SI_FUNCTION__ NSLog(@"function = %s, line = %d", __PRETTY_FUNCTION__, __LINE__);
#else
#define __SI_FUNCTION__
#endif
#define SI_LOG_MACRO(level, fmt, ...)     [[SILogger sharedInstance] logLevel:level format:(fmt), ##__VA_ARGS__]
#define SI_LOG_PRETTY(level, fmt, ...)    \
do {SI_LOG_MACRO(level, @"%s #%d \n============================================================begin\n" fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);} while(0)

//在release版本下禁止输出
#ifdef DEBUG
#define SILogError(frmt, ...)   SI_LOG_PRETTY(SILogLevelERROR, frmt, ##__VA_ARGS__)
#define SILogWarn(frmt, ...)    SI_LOG_PRETTY(SILogLevelWARN,  frmt, ##__VA_ARGS__)
#define SILogInfo(frmt, ...)    SI_LOG_PRETTY(SILogLevelINFO,  frmt, ##__VA_ARGS__)
#define SILogDebug(frmt, ...)   SI_LOG_PRETTY(SILogLevelDEBUG, frmt, ##__VA_ARGS__)
#define DLog(frmt, ...) SI_LOG_PRETTY(SNLogLevelDEBUG, frmt, ##__VA_ARGS__)
#define isRuntimeLogEffectiveDefault 1
#else
#define SILogError(frmt, ...)
#define SILogWarn(frmt, ...)
#define SILogInfo(frmt, ...)
#define SILogDebug(frmt, ...)
#define DLog(frmt, ...)
#define isRuntimeLogEffectiveDefault 0
#endif



static int ddLogLevel;

@interface SILogger : NSObject <DDLogFormatter>
@property (nonatomic, assign) SILogLevel logLevel;
@property (nonatomic, assign) BOOL isRuntimeLogEffective;//< 是否开启运行时Log事件 默认为YES;

+ (instancetype)sharedInstance;
+ (void)startWithLogLevel:(SILogLevel)logLevel;

- (void)logLevel:(SILogLevel)level format:(NSString *)format, ...;
- (void)logLevel:(SILogLevel)level message:(NSString *)message;



@end
