//
//  MJViewController.m
//  07.GCD的队列和任务
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"

@interface MJViewController ()

@end

@implementation MJViewController
/**
 
 GCD的任务
 
 1> disptach_sync       没有创建线程的欲望，就在当前线程执行
    最主要的目的，阻塞并行队列任务的执行，只有当前的同步任务执行完毕后，后续的任务才能够执行
    应用场景：用户登录！
 
 2> dispatch_async      有创建线程的欲望，但是创建多少条线程，取决与队列的类型
 
 GCD的队列
 
 1> 串行队列              类似于跑步，只有一条跑道，最多能够有两条
    如果存在异步任务，就会在新线程中执行异步任务，而同步任务依旧在当前线程中执行
 
 2> 并行队列              类似与赛跑，具体跑道的数量，由系统决定
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self demo];
}

- (void)demo
{
    dispatch_queue_t q = dispatch_queue_create("demo", DISPATCH_QUEUE_CONCURRENT);
    
    // 在新线程中工作
    dispatch_async(q, ^{
        // 2
        NSLog(@"%@", [NSThread currentThread]);
        
        __block BOOL userLogon = NO;
        
        // 用户登录，用户输入用户名，密码之后，提交到服务器确认身份
        // 应用场景1：用来阻塞必须要按照顺序执行的任务
        dispatch_sync(q, ^{
            // 2
            NSLog(@"用户网络登陆 %@", [NSThread currentThread]);
            
            [NSThread sleepForTimeInterval:3.0f];
            
            userLogon = NO;
        });
        
        // 身份确认之前，不能做其他事情
        dispatch_async(q, ^{
            // 可能是3，也可能是2
            // 3.0（对的） / 立马执行（不对的）
            NSLog(@"后续处理 %@", [NSThread currentThread]);
            
            if (userLogon) {
                NSLog(@"welcome");
            } else {
                NSLog(@"why");
            }
        });
        
        // 队列是先进先出FIFO的，队列中的任务都是串着的
    });
}

@end
