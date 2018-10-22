//
//  ViewController.m
//  GCDTimer
//
//  Created by kouhanjin on 2018/10/22.
//  Copyright © 2018年 khj. All rights reserved.
//

#import "ViewController.h"
#import "KJTimer/KJTimer.h"

@interface ViewController ()
/** 任务 */
@property (nonatomic, copy) NSString *task;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"begin");
    // 开启定时器
    self.task = [KJTimer exexTask:^{
        NSLog(@"task");
    } startTimer:2.0 interval:1.0 repeat:YES async:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 取消任务
    [KJTimer cancelTaskName:self.task];
    NSLog(@"end");
}


@end
