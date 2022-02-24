//
//  ViewController.m
//  fixFlutter
//
//  Created by 智华张 on 2021/8/16.
//

#import "ViewController.h"

@import Flutter;
#import "AppDelegate.h"
#import "ViewController.h"
#import "GeneratedPluginRegistrant.h"

@interface ViewController ()<FlutterStreamHandler>

//单项管道，有可能使用多次
@property (nonatomic, copy) FlutterEventSink eventSink;
@property (nonatomic, assign)NSInteger methodCount;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.methodCount = 0;

    
    [super viewDidLoad];

    
    // Make a button to call the showFlutter function when pressed.
       
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button addTarget:self
                   action:@selector(showFlutter)
         forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show Flutter!" forState:UIControlStateNormal];
    button.backgroundColor = UIColor.blueColor;
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    button.center = CGPointMake(self.view.frame.size.width/2, button.center.y);
    [self.view addSubview:button];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.titleLabel.center = self.view.center;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = UIColor.darkGrayColor;
    self.titleLabel.text = @"0";
    
    [self.view addSubview:self.titleLabel];

    
    
    
    
}

- (void)showFlutter {
    
//    FlutterEngine *flutterEngine =
//        ((AppDelegate *)UIApplication.sharedApplication.delegate).flutterEngine;
//    FlutterViewController *flutterViewController =
//        [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
//    [self presentViewController:flutterViewController animated:YES completion:nil];
//
//    //单项通信管道，Flutter向原生发送消息
//    FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:@"com.flutterToNative" binaryMessenger:flutterViewController];
//
//
//    [messageChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
//            //可以在这里实现flutter发给原生要实现的方法
//        NSLog(@"接受到flutter 传过来的消息参数 1[ %@ ]  2[ %@ ]",call,result);
//        [self dismissViewControllerAnimated:YES completion:^{
//
//        }];
//
//    }];
//
//
//
//    //单项通信管道，原生向Flutter发送消息
//        FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"com.nativeToFlutter" binaryMessenger:flutterViewController];
//        [eventChannel setStreamHandler:self];
    
    
    FlutterViewController *flvc = [[FlutterViewController alloc] init];
        //单项通信管道，Flutter向原生发送消息
        FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:@"com.flutterToNative" binaryMessenger:flvc];
        __weak typeof(self) weakSelf = self;
        [messageChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            if ([@"backToNative" isEqualToString:call.method]) {
                [weakSelf dismissViewControllerAnimated:true completion:nil];
                
                if(call.arguments){
                    self.titleLabel.text = call.arguments;
                }
                
                
            }
        }];
        
        //单项通信管道，原生向Flutter发送消息
        FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"com.nativeToFlutter" binaryMessenger:flvc];
        [eventChannel setStreamHandler:self];
    
    
    NSLog(@"好家伙");
    
    
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.methodCount ++;
        
        NSString *sendMsg = [NSString stringWithFormat:@"原生发过来的第 %ld条消息",self.methodCount];
        self.eventSink(sendMsg);
    }];
    
    [self presentViewController:flvc animated:true completion:^{
       
    }];
    
    
    
}

#pragma --mark FlutterStreamHandler代理
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    if (events) {
        self.eventSink  = events;
        NSLog(@"执行了");
        NSString *sendMsg = [NSString stringWithFormat:@"原生发过来的第 %ld条消息",self.methodCount];
        self.eventSink(sendMsg);
    }
    return nil;
}
// 不再需要向Flutter传递消息
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    NSLog(@"停止了");
    return nil;
}




@end


