//
//  KJTimer.m
//  GCDTimer
//
//  Created by kouhanjin on 2018/10/22.
//  Copyright © 2018年 khj. All rights reserved.
//

#import "KJTimer.h"

@implementation KJTimer

static NSMutableDictionary *timers_;
dispatch_semaphore_t semaphore_;

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        // 创建信号量
        // 信号量的初始值，可以用来控制线程并发访问的最大数量，初始值为1，代表同时只允许1条线程访问资源，保证线程同步
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)exexTask:(void (^)(void))task startTimer:(NSTimeInterval)startTimer interval:(NSTimeInterval)interval repeat:(BOOL)repeat async:(BOOL)async{
    
    if (!task || startTimer < 0 || (interval <= 0 && repeat)) return nil;
   
    // 队列
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    // 创建定时器队列
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置时间
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, startTimer * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    // 线程同步
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    
    // 定时器的唯一标识
    NSString *name = [NSString stringWithFormat:@"%zd",timers_.count];
    
    // 存放到字典
    timers_[name] = timer;
    
    // 让信号量的值加1
    dispatch_semaphore_signal(semaphore_);
    
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeat) {
            [self cancelTaskName:name];
        }
    });
    // 启动定时器
    dispatch_resume(timer);
    
    return name;
}

+ (void)cancelTaskName:(NSString *)name{
    if (name.length == 0) return;
    // 如果信号量的值<=0，当前线程就会进入休眠等待（直到信号量的值>0）
    // 如果信号量的值>0，就减1，然后往下执行后面的代码
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    
    // 取出timer
    dispatch_source_t timer = timers_[name];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:name];
    }
    // 让信号量的值加1
    dispatch_semaphore_signal(semaphore_);
}

@end
