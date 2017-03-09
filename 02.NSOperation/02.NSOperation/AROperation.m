//
//  AROperation.m
//  02.NSOperation
//
//  Created by ylgwhyh on 17/3/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "AROperation.h"

@implementation AROperation

// 自定义NSOperation类.m文件的main方法实现
- (void)main {
    NSLog(@"测试自定义NSOperation   this is my custom operation ---- %@", [NSThread currentThread]);
    
    for (NSInteger i = 0; i < 1000; i++) {
        NSLog(@"SubTask---0---%zd",i);
    }
    // 判断当前任务是否被取消,如果已经取消,及时返回
    if (self.cancelled) {
        return;
    }
    
    for (NSInteger i = 0; i < 1000; i++) {
        
        NSLog(@"SubTask---1---%zd", i);
    }
    if (self.cancelled) {
        return;
    }
    
    for (NSInteger i = 0; i < 1000; i++) {
        NSLog(@"SubTask---2---%zd",i);
    }
}

@end
