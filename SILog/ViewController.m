//
//  ViewController.m
//  SILog
//
//  Created by sincere on 16/9/12.
//  Copyright © 2016年 cofortune. All rights reserved.
//

#import "ViewController.h"
#import "SILogger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SILogInfo(@"这是Info打印模式");
    SILogDebug(@"这是Debug打印模式");
    SILogger  *  myLog = [SILogger new];
    [myLog logLevel: SILogLevelWARN format:@"这是Warn打印模式"];
    [myLog logLevel: SILogLevelERROR format:@"这是Error打印模式"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
