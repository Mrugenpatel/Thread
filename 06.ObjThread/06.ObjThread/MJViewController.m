//
//  MJViewController.m
//  06.ObjThread
//
//  Created by apple on 14-4-23.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJViewController.h"
/**
 需求分析
 
 1. UIImageView显示图片
 2. UIImage模拟从网络上下载
 3. NSString记录图片路径
 
 小结
 
 方法，看起来很简单，
 
 1> 不能够自动回收线程，如果并发数量多，会建立大量的子线程！
 2> 使用NSThread的线程，不会自动添加autoreleasepool
 
    意味着，如果在后台线程方法中，
 
 @autoreleasepool {} 自动释放池
 
 主线程中是有自动释放池的，使用GCD和NSOperation也会自动添加自动释放池
 
 NSThread和NSObject不会，如果在后台线程中创建了autorelease的对象，需要使用自动释放池，否则会出现内存泄漏！
 
 工作原理：
 
 1. 当自动释放池被销毁或者“耗尽”时，对池中的所有对象发送release消息，清空自动释放池
 2. 所有autorelease的对象，在出了作用域之后，会自动添加到【最近一次创建的自动释放池中】自动释放池中
 
 在ARC中，编译器在编译过程中，会自动根据代码结构，添加retain和release。
 */
@interface MJViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imagePath;

@end

@implementation MJViewController

// 0. 模拟使用图像路径加载图片
- (void)setImagePath:(NSString *)imagePath
{
    @autoreleasepool {
        NSLog(@"%@", [NSThread currentThread]);
        
        // 1> 模拟下载，延时
        [NSThread sleepForTimeInterval:1.0];

        // 2> 设置图像，苹果底层允许使用performSelectorInBackground方法
        // 在后台线程更新UI，强烈不建议大家这么做！
        // YES会阻塞住线程，直到调用方法完成
        // NO不会阻塞线程，会继续执行
        [self performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:imagePath] waitUntilDone:NO];
    }
}

// 1. 图像
- (void)setImage:(UIImage *)image
{
    
    self.imageView.image = image;
    
//    [NSThread sleepForTimeInterval:1.0];
    // 根据图片自动调整大小
    [self.imageView sizeToFit];
}

// 2. 创建imageView
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView];
    
    // 在后台线程执行这段代码即可
    for (int i = 0; i < 50; ++i) {
        [self performSelectorInBackground:@selector(setImagePath:) withObject:@"头像1.png"];
    }
//    [self setImagePath: @"头像1.png"];
}

- (void)demo
{
    // 提问：代码存在什么问题？如果循环次数非常大，会出现什么问题？应该如何修改？
    
    // 解决办法1：如果i比较大，可以
    // 解决方法2：如果i玩命大，一次循环都会造成自动释放池被填满
    for (int i = 0; i < 10000000; ++i) {
        @autoreleasepool {
            // *
            NSString *str = @"Hello World!";
            // new *
            str = [str uppercaseString];
            // new *
            str = [NSString stringWithFormat:@"%@ %d", str, i];
            
            NSLog(@"%@", str);
        }
    }
}

@end
