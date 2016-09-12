//
//  SILogger.m
//  SILog
//
//  Created by sincere on 16/9/12.
//  Copyright © 2016年 cofortune. All rights reserved.
//

#import "SILogger.h"

@implementation SILogger

+ (instancetype)sharedInstance
{
    static SILogger *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SILogger alloc] init];
        _instance.isRuntimeLogEffective = isRuntimeLogEffectiveDefault;
    });
    return _instance;
}

+ (void)startWithLogLevel:(SILogLevel)logLevel
{
    [self sharedInstance];
    [[self sharedInstance] setLogLevel:logLevel];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 启动Xcode Colors环境
        setenv("XcodeColors", "YES", 0);
        
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        
        UIColor *pink = [UIColor colorWithRed:(255/255.0) green:(58/255.0) blue:(159/255.0) alpha:1.0];
        
        [[DDTTYLogger sharedInstance] setForegroundColor:pink backgroundColor:nil forFlag:DDLogFlagInfo];
        
        // sends log statements to Xcode console - if available
        [[DDTTYLogger sharedInstance] setLogFormatter:self];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        // sends log statements to Apple System Logger, so they show up on Console.app
        [[DDASLLogger sharedInstance] setLogFormatter:self];
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        
    }
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    
    NSString *logLevel = nil;
    switch (logMessage->_flag)
    {
        case LOG_FLAG_ERROR:
            logLevel = @"[ERROR] > ";
            break;
        case LOG_FLAG_WARN:
            logLevel = @"[WARN]  > ";
            break;
        case LOG_FLAG_INFO:
            logLevel = @"[INFO]  > ";
            break;
        case LOG_FLAG_DEBUG:
            logLevel = @"[DEBUG] > ";
            break;
        default:
            logLevel = @"[VBOSE] > ";
            break;
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%@%@",
                           logLevel, logMessage->_message];
    return formatStr;
}

- (void)setLogLevel:(SILogLevel)logLevel
{
    _logLevel = logLevel;
    switch (_logLevel) {
        case SILogLevelDEBUG:
            ddLogLevel = LOG_LEVEL_DEBUG;
            break;
        case SILogLevelINFO:
            ddLogLevel = LOG_LEVEL_INFO;
            break;
        case SILogLevelWARN:
            ddLogLevel = LOG_LEVEL_WARN;
            break;
        case SILogLevelERROR:
            ddLogLevel = LOG_LEVEL_ERROR;
            break;
        case SILogLevelOFF:
            ddLogLevel = LOG_LEVEL_OFF;
            break;
        default:
            break;
    }
}

//! 记录日志(有格式)
- (void)logLevel:(SILogLevel)level format:(NSString *)format, ...
{
    if (format)
    {
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        [self logLevel:level message:message];
    }
}

//! 记录日志(无格式)
- (void)logLevel:(SILogLevel)level message:(NSString *)message
{
    if (message.length > 0)
    {
        switch (level)
        {
            case SILogLevelERROR:
                DDLogError(@"\n*************************************************************\n\n                      ERROR!!!\n                      ERROR!!!\n          \n*************************************************************\n%@\n============================================================end", message);
                break;
                
            case SILogLevelWARN:
                DDLogWarn(@"%@\n============================================================end", message);
                break;
                
            case SILogLevelINFO:
                DDLogInfo(@"%@\n============================================================end", message);
                break;
                
            case SILogLevelDEBUG:
                DDLogDebug(@"%@\n============================================================end", message);
                break;
                
            default:
                DDLogVerbose(@"%@\n============================================================end", message);
                break;
        }
    }
}

@end



