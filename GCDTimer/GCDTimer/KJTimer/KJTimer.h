//
//  KJTimer.h
//  GCDTimer
//
//  Created by kouhanjin on 2018/10/22.
//  Copyright © 2018年 khj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJTimer : NSObject

/**
 开启任务

 @param task 任务回调
 @param startTimer 开始时间，几秒后执行
 @param interval 每隔几秒执行
 @param repeat 是否重复执行
 @param async 子线程还是还是主线程
 @return 任务名
 */
+ (NSString *)exexTask:(void(^)(void))task startTimer:(NSTimeInterval)startTimer interval:(NSTimeInterval)interval repeat:(BOOL)repeat async:(BOOL)async;

/**
 取消任务

 @param name 任务名称
 */
+ (void)cancelTaskName:(NSString *)name;
@end
