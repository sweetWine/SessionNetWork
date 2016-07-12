//
//  ViewController.m
//  网络编程
//
//  Created by ios on 16/7/1.
//  Copyright © 2016年 ios. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    // 创建按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn1.frame = CGRectMake(100, 100, 50, 50);
    [btn1 addTarget:self action:@selector(btn1Action) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn2.frame = CGRectMake(100, 200, 50, 50);
    [btn2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn2];
    
}

// 直接请求网络
- (void)btn1Action
{
    // 创建URL
    NSURL *url = [NSURL URLWithString:@"http://c.hiphotos.baidu.com/zhidao/pic/item/241f95cad1c8a7862356b5796109c93d70cf504d.jpg"];
    
    // 创建网络请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置请求时间以及请求方式
    request.timeoutInterval = 20;
    request.HTTPMethod = @"GET";
    
    // 创建Session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建网咯请求对象
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        UIImage *img = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _imgView.image = img;
        });
    }];
    
    // 手动开始任务
    [task resume];
}

// 使用代理方式请求网络
- (void)btn2Action
{
    // 构建URL
    NSURL *url = [NSURL URLWithString:@"http://f.hiphotos.baidu.com/zhidao/pic/item/e850352ac65c1038f6604160b0119313b07e8972.jpg"];
    
    // 创建SessionConfiguration对象
    NSURLSessionConfiguration *configuation = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 设置时间
    configuation.timeoutIntervalForRequest = 20;
    
    // 是否可以使用移动网络
    configuation.allowsCellularAccess = NO;
    
    /*
    // 使用block请求数据
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuation];
    [session dataTaskWithRequest:<#(nonnull NSURLRequest *)#> completionHandler:<#^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)completionHandler#>]
    */
    
    // 使用代理
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuation delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建数据请求对象
    NSURLSessionDataTask *task = [session dataTaskWithURL:url];
    
    [task resume];
}

#pragma mark - NSURLSessionDelegate
// 当服务器做出响应时调用的协议方法
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    // 获取响应头数据
    NSDictionary *headerDic = ((NSHTTPURLResponse *)response).allHeaderFields;
    NSLog(@"headerDic:%@",headerDic);
    
    // 是否接收数据
    completionHandler(NSURLSessionResponseAllow);
}

// 当数据接收完成调用的协议方法
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
//    NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"htmlString:%@",htmlString);
    
    UIImage *img = [UIImage imageWithData:data];
    if ([NSThread isMainThread]) {
        _imgView.image = img;
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _imgView.image = img;
        });
    }
}

// 监听读取进度
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"1:%lld,2:%lld,3:%lld",bytesSent,totalBytesSent,totalBytesExpectedToSend);
}


@end
