//
//  DemoObj.m
//  03.Block引用
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "DemoObj.h"

@interface DemoObj()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation DemoObj

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"demoobj dealloc");
}

- (void)demoOp:(id)obj
{
    NSLog(@"%@ %@", [NSThread currentThread], obj);
}

- (void)demoBlockOp
{
    // 不能用__weak
//    __weak DemoObj *weakSelf = self;
    // 只有self直接强引用block，才会出现循环引用
    // block的管理以及线程的创建和销毁是由队列负责的，直接在block中使用self没有关系！
    for (int i = 0; i < 10; ++i) {
        
        [self.queue addOperationWithBlock:^{
            [self demoOp:@(i)];
        }];
    }
}

@end
