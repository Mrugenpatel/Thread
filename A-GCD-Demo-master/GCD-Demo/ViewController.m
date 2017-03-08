//
//  ViewController.m
//  GCD-Demo
//
//  Created by xiaofan on 16/5/27.
//  Copyright © 2016年 xiaofan. All rights reserved.
//

#import "ViewController.h"
#import "GCD.h"
#import <UIImageView+WebCache.h>

@interface ViewController ()
// GCD 执行队列与UI界面所在线程队列
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage     *image;

// GCD 定时器
@property (nonatomic, strong) GCDTimer *gcdTimer;
@property (nonatomic, strong) NSTimer  *normalTimer;

// GCD 综合介绍
@property (nonatomic, strong) UIImageView *view1;
@property (nonatomic, strong) UIImageView *view2;
@property (nonatomic, strong) UIImageView *view3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 执行串行队列
    //[self serailQueue];
    
    // 执行并发队列
    //[self initConcurrent];
    
    // UI界面所在的线程队列
    //[self UIQueue];
    
    // NSThread 延时执行
    //[self setNSThread];
    
    // GCD延时执行事件
    //[self setGCDEvent];
    
    // GCD 线程组
    //[self setGCDGroup];
    
    // GCDTimer
    //[self runGCDTimer];
    
    // NSTimer
    //[self runNSTimer];
    
    // GCDSemaphore GCD信号量
    //[self setGCDSemaphore];
    
    // GCD 综合介绍应用
    [self setGCD];
    
}

#pragma mark - GCD串行队列与并发队列

// 创建串行队列
- (void)serailQueue {
    // 创建队列
    GCDQueue *queue = [[GCDQueue alloc] initSerial];
    //执行队列中的线程1
    [queue execute:^{
        NSLog(@"线程1");
    }];
    
    //执行队列中的线程2
    [queue execute:^{
        NSLog(@"线程2");
    }];
    
    //执行队列中的线程3
    [queue execute:^{
        NSLog(@"线程3");
    }];
    
    //执行队列中的线程4
    [queue execute:^{
        NSLog(@"线程4");
    }];
    
    //执行队列中的线程5
    [queue execute:^{
        NSLog(@"线程5");
    }];
}

// 创建并发队列
- (void)initConcurrent {
    // 创建队列
    GCDQueue *queue = [[GCDQueue alloc] initConcurrent];
    //执行队列中的线程1
    [queue execute:^{
        NSLog(@"线程1");
    }];
    
    //执行队列中的线程2
    [queue execute:^{
        NSLog(@"线程2");
    }];
    
    //执行队列中的线程3
    [queue execute:^{
        NSLog(@"线程3");
    }];
    
    //执行队列中的线程4
    [queue execute:^{
        NSLog(@"线程4");
    }];
    
    //执行队列中的线程5
    [queue execute:^{
        NSLog(@"线程5");
    }];
}

// UI界面所在的线程队列是串行队列
- (void)UIQueue {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
    
    [GCDQueue executeInGlobalQueue:^{
        // 处理业务逻辑
        // 图片url
        NSURL         *imgUrl  = [NSURL URLWithString:@"http://o7mwf03sy.bkt.clouddn.com/1460334144112.jpg"];
        
        NSLog(@"处理业务逻辑");
        
        [GCDQueue executeInMainQueue:^{
            //更新UI
            [self.imageView sd_setImageWithURL:imgUrl];
            
            NSLog(@"更新UI");
            
        }];
    }];
}

#pragma mark - GCD延时执行与NSThread 延时对比

 // NSThread 延时执行
- (void)setNSThread {
    NSLog(@"启动");
   [self performSelector:@selector(threadEvent:)
              withObject:self
              afterDelay:2.f];
    // 取消当前延时操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
// NSThread 延时执行的事件
- (void)threadEvent:(id)sender {
    NSLog(@"NSThread 延时执行事件");
}

// GCD延时执行事件

- (void)setGCDEvent {
     NSLog(@"启动");
    
    [GCDQueue executeInMainQueue:^{
        NSLog(@"GCD 延时执行事件");
    } afterDelaySecs:2.f];
}

#pragma mark - GCDGroup

- (void)setGCDGroup {
    // 初始化线程组
    GCDGroup *group = [[GCDGroup alloc] init];
    
    // 创建一个线程队列
    GCDQueue *queue = [[GCDQueue alloc] initConcurrent];
    
    // 让线程在group中执行 线程1
    [queue execute:^{
        sleep(1);// 休眠
        NSLog(@"线程1执行完毕");
    } inGroup:group];
    
    // 让线程在group中执行 线程2
    [queue execute:^{
        sleep(3);
        NSLog(@"线程2执行完毕");
    } inGroup:group];
    
    // 监听线程组是否执行完毕，然后执行线程3
    [queue notify:^{
        NSLog(@"线程3执行完毕");
    } inGroup:group];
}

#pragma mark - GCDTimer
// GCDTimer
- (void)runGCDTimer {
    // 初始化
    self.gcdTimer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    
    // 指定间隔时间
    [self.gcdTimer event:^{
        NSLog(@"运行GCDTimer");
    } timeInterval:NSEC_PER_SEC];// 1 miao
    
    // 运行GCDTimer
    [self.gcdTimer start];
}
// NSTimer
- (void)runNSTimer {
    // 初始化并激活NSTimer
    self.normalTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(timerEvent)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)timerEvent {
    NSLog(@"运行NSTimer");
}

#pragma mark - GCDSemaphore GCD信号量

- (void)setGCDSemaphore {
    // 创建GCDSemaphore 信号量
    GCDSemaphore *semaphore = [[GCDSemaphore alloc] init];
    
    // 异步线程 1
    [GCDQueue executeInGlobalQueue:^{
        NSLog(@"异步线程 1");
        
        // 发送执行完毕信号
        [semaphore signal];
    }];
    
    // 异步线程 2
    [GCDQueue executeInGlobalQueue:^{
        // 等待接收执行完毕信号才开始执行进程
        [semaphore wait];
        
        NSLog(@"异步线程 2");
    }];
    // 作用： 必须线程1先执行完毕，然后在执行线程2
    // 将异步线程转化成同步线程。
}

#pragma mark - GCD 综合使用介绍

- (void)setGCD {
    
    NSString *img1 = @"http://o7mwf03sy.bkt.clouddn.com/1460334156212.jpg";
    NSString *img2 = @"http://o7mwf03sy.bkt.clouddn.com/1460334134611.jpg";
    NSString *img3 = @"http://o7mwf03sy.bkt.clouddn.com/1460334144112.jpg";
    
    self.view1 = [self createImageViewWithFrame:CGRectMake(50, 50, 200, 100) imageUreStr:img1];
    self.view2 = [self createImageViewWithFrame:CGRectMake(50, 200, 200, 100) imageUreStr:img2];
    self.view3 = [self createImageViewWithFrame:CGRectMake(50, 350, 200, 100) imageUreStr:img3];
    
    GCDSemaphore *semaphore = [[GCDSemaphore alloc] init];
    
    // 在子线程中完成下载  图片1
    [GCDQueue executeInGlobalQueue:^{
        // 在主线程中更新UI
        [GCDQueue executeInMainQueue:^{
            NSLog(@"线程 1 开始执行");
            // 2秒动画显示图片
            [UIView animateWithDuration:2.f animations:^{
                self.view1.alpha = 1.f;
            } completion:^(BOOL finished) {
                NSLog(@"线程 1 执行完毕");
                // 发送执行完毕信号
                [semaphore signal];
            }];
        }];
    }];
    
    // 在子线程中完成下载  图片2
    [GCDQueue executeInGlobalQueue:^{
        // 阻塞执行，等待消息
        [semaphore wait];
        NSLog(@"线程 2 开始执行");
        // 在主线程中更新UI
        [GCDQueue executeInMainQueue:^{
            // 2秒动画显示图片
            [UIView animateWithDuration:2.f animations:^{
                self.view2.alpha = 1.f;
            } completion:^(BOOL finished) {
                NSLog(@"线程 2 执行完毕");
                // 发送执行完毕信号
                [semaphore signal];
            }];
        }];
    }];
    
    // 在子线程中完成下载  图片3
    [GCDQueue executeInGlobalQueue:^{
        // 阻塞执行，等待消息
        [semaphore wait];
        NSLog(@"线程 3 开始执行");
        // 在主线程中更新UI
        [GCDQueue executeInMainQueue:^{
            // 2秒动画显示图片
            [UIView animateWithDuration:2.f animations:^{
                self.view3.alpha = 1.f;
            } completion:^(BOOL finished) {
                NSLog(@"线程 3 执行完毕");
            }];
        }];
    }];
}
// 创建 imageview
- (UIImageView *)createImageViewWithFrame:(CGRect)frame imageUreStr:(NSString *)string {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.alpha        = 0.f;
    [imageView sd_setImageWithURL:[NSURL URLWithString:string]];
    [self.view addSubview:imageView];
    
    return imageView;
}










@end
