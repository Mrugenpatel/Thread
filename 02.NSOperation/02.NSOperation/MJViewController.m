//
//  MJViewController.m
//  02.NSOperation
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"
#import "AROperation.h"

@interface MJViewController ()

@property (nonatomic, strong) NSOperationQueue *myQueue;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setImageView];
    
    self.myQueue = [[NSOperationQueue alloc] init];
    
    [self demoOp2];
    
    
    
    
    // 1) NSInvocationOperation用法
    //1.封装操作
    /*
     第一个参数：目标对象
     第二个参数：该操作要调用的方法，最多接受一个参数
     第三个参数：调用方法传递的参数，如果方法不接受参数，那么该值传nil
     */
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run) object:nil];
    
    //2.启动操作
    [operation start];
    
    
    // 2) NSBlockOperation添加多个ExecutionBlock的用法
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation用法---%@", [NSThread currentThread]);
    }];
    [op start];
    
    
    NSBlockOperation *multiOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task0---%@", [NSThread currentThread]);
    }];
    
    [multiOp addExecutionBlock:^{
        NSLog(@"task1----%@", [NSThread currentThread]);
    }];
    
    [multiOp addExecutionBlock:^{
        NSLog(@"task2----%@", [NSThread currentThread]);
    }];
    
    // 开始必须在添加其他操作之后
    [multiOp start];
    
    
    // 3) 自定义NSOperation
    // 该操作被执行时就会执行op内部定义的任务
    AROperation *customOperationOp = [[AROperation alloc] init];
    [customOperationOp start];
    
    // 4) 设置设置任务的执行顺序
    [self demoOp3];
    
    // 5) 线程间通信
    // 有时我们在子线程中执行完一些操作的时候,需要回到主线程做一些事情(如进行UI操作),因此需要从当前线程回到主线程,以下载并显示图片为例,方法如下:
    [self threadCommunication];
}


- (void)setImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:self.imageView];
}

- (void)threadCommunication {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 子线程下载图片
    [queue addOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1598552568,4236159349&fm=58"];
        //NSData *data = [NSData dataWithContentsOfURL:url];

        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            NSLog(@"Data has loaded successfully.");
        }
        
        
        UIImage *image = [[UIImage alloc] initWithData:data];
        // 回到主线程进行显示
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
        }];
    }];
}

- (void)run {
    NSLog(@"执行操作...");
}

- (void)demoOp:(id)obj
{
    NSLog(@"%@ - %@", [NSThread currentThread], obj);
}

#pragma mark - NSOperation方法
#pragma mark 设置任务的执行顺序
- (void)demoOp3
{
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片 %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"修饰图片 %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"保存图片 %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"更新UI %@", [NSThread currentThread]);
    }];
    
    // 设定执行顺序, Dependency依赖，可能会开多个，但不会太多
    // 依赖关系是可以跨队列的！
    [op2 addDependency:op1];
    [op3 addDependency:op2];
    [op4 addDependency:op3];
    // GCD是串行队列，异步任务，只会开一个线程
    
    [self.myQueue addOperation:op1];
    [self.myQueue addOperation:op2];
    [self.myQueue addOperation:op3];
    // 所有UI的更新需要在主线程上进行
    [[NSOperationQueue mainQueue] addOperation:op4];
}

#pragma mark NSInvocationOP
- (void)demoOp2
{
    // 需要定义一个方法，能够接收一个参数
    // 是用起来不够灵活
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(demoOp:) object:@"hello op"];
    
//    [self.myQueue addOperation:op];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark NSBlockOperation
- (void)demoOp1
{
//    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"%@", [NSThread currentThread]);
//    }];
//    
    // 所有的自定义队列，都是在子线程中运行
//    [self.myQueue addOperation:block];
    
    // 新建线程是有开销的
    // 在设定同时并发的最大线程数时，如果前一个线程工作完成，但是还没有销毁，会新建线程
    // 应用场景：网络开发中，下载工作！（线程开销：CPU,MEM）电量！
    // 如果是3G，开3个子线程
    // 如果是WIFI，开6个子线程
    
    for (int i = 0; i < 10; ++i) {
        [self.myQueue addOperationWithBlock:^{
            NSLog(@"%@ %d", [NSThread currentThread], i);
        }];
    }
    
    // 在主线程中执行
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        NSLog(@"%@", [NSThread currentThread]);
//    }];
}

@end
