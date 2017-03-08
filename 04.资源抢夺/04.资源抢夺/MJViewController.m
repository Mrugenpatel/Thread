//
//  MJViewController.m
//  04.资源抢夺
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"

@interface MJViewController ()

@property (weak, nonatomic) IBOutlet UITextView *infoText;

/**
 在iOS中还有一种锁的功能，原子锁 —— 多读单写的锁（128位自旋锁），也会消耗性能
 
 原子锁只保护写入时的数据正确，而读取不负责。
 
 对于要写入的资源，保护“写入数据”的正确性重要，还是读取的准确性重要！
 
 如果只是开发单写多读的功能，只需要使用原子锁即可。
 
 @synchronized 性能消耗非常的大，苹果官方不建议使用。
 
 在实际开发中，不要去抢夺资源！
 
 *** 并发编程最主要的目的是提高性能，让更多的代码同时运行，达到并发运行，提高整体性能的目的！
 
 *** 手机开发最主要的是流畅，并行，至于资源抢夺的功能开发是属于服务端的范畴！
 */

// 票数
@property (atomic, assign) NSInteger tickets;

@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - 卖票操作
// 卖票循环，一直卖完为止
- (void)doSaleLoop:(NSString *)opName
{
    // 所有线程进入都可以循环卖票
    while (YES) {
        // 加互斥锁，在共享资源的“读”“写”范围添加互斥锁
        // *** 要让锁的范围尽可能小！
        // 是否有票
        // 资源抢夺做简单的做法就是使用互斥锁@synchronized
        // 使用互斥锁，会变慢，互斥锁的代价十分高昂！
        @synchronized(self) {
            if (self.tickets > 0) {
                --self.tickets;
                
                NSLog(@"剩余票数 %ld - %@ - %@", (long)self.tickets, opName, [NSThread currentThread]);
            } else {
                break;
            }
        }
        //-----------------------------------------
        // 模拟休眠，跟资源抢夺无关，不用放在锁里
        if ([opName isEqualToString:@"OP 1"]) {
            [NSThread sleepForTimeInterval:1.0f];
        } else {
            [NSThread sleepForTimeInterval:0.3f];
        }
    }
}

#pragma mark 模拟多人卖票
#pragma mark GCD实现


- (IBAction)doSale:(id)sender
{
    // 做多线程开始时，永远不要相信一次运行的结果
    self.tickets = 20;
    
    // 1. 队列
    dispatch_queue_t q = dispatch_queue_create("sale", DISPATCH_QUEUE_CONCURRENT);
    
    // 2. 添加任务
    dispatch_async(q, ^{
        [self doSaleLoop:@"OP 1"];
    });
    
    dispatch_async(q, ^{
        [self doSaleLoop:@"OP 2"];
    });
    
    dispatch_async(q, ^{
        [self doSaleLoop:@"OP 3"];
    });
    
    dispatch_async(q, ^{
        [self doSaleLoop:@"OP 4"];
    });
}

@end
