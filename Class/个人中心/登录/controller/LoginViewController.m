//
//  LoginViewController.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/19.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import <RACSignal.h>

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = NSLocalizedString(@"registeredAccount", nil);

    self.FDPrefersNavigationBarHidden=YES;
//    self.isSmsLogin = NO;
    
    

    
    UIButton *testBtn = [UIButton new];
    [testBtn setTitle:@"测试按钮" forState:UIControlStateNormal];
    [testBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    [[testBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
        RACSignal * singel = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            // subscriber 是订阅者，这是一个协议，不是一个类。发送信号 1
            [subscriber sendNext:@2];
            // 发送完成
            [subscriber  sendCompleted];
            
            // RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
            // 执行完Block后，当前信号就不在被订阅了。
            return [RACDisposable disposableWithBlock:^{
                
                NSLog(@"信号被销毁");
                
            }];
        }];
        
        //singel信号类调用subscribeNext方法订阅信号。订阅之后才会激活这个信号，注意顺序！
        [singel subscribeNext:^(id x) {
            // block调用时刻：每当有信号发出数据，就会调用block.
            NSLog(@"接收到数据:%@",x);
        }];
        
        
        RACSubject  * subject = [RACSubject subject];
        // 自己订阅了信号
        [subject subscribeNext:^(id x) {
            
            NSLog(@"第一个订阅者%@",x);
            
        }];
        
        [subject subscribeNext:^(id x) {
            
            NSLog(@"第二个订阅者%@",x );
            
        }];
        
        // 自己发送了信号
        [subject sendNext:@"520"];
        
        
        // 1.创建信号
        RACReplaySubject *replaySubject = [RACReplaySubject subject];
        
        // 2.发送信号
        [replaySubject sendNext:@11];
        [replaySubject sendNext:@22];
        
        // 3.订阅信号
        [replaySubject subscribeNext:^(id x) {
            
            NSLog(@"第一个订阅者接收到的数据%@",x);
        }];
        
        // 订阅信号
        [replaySubject subscribeNext:^(id x) {
            
            NSLog(@"第二个订阅者接收到的数据%@",x);
        }];
        
        
        //遍历数组
        NSArray *numbers = @[@1,@2,@3,@4];
        
        // 这里其实是三步
        // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
        // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
        // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
        [numbers.rac_sequence.signal subscribeNext:^(id x) {
            
            NSLog(@"%@",x);
            
        }];
        
        // 遍历字典,遍历出来的键值对会包装成RACTuple(元组对象
        NSDictionary *dict = @{@"name":@"张旭",@"age":@24};
        [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
            
            // RACTuple 就是一个元组，元组的概念在Swift有专门的介绍，没掌握的可以自己上网查一下！
            NSLog(@"RACTuple = %@",x);
            // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
            RACTupleUnpack(NSString *key,NSString *value) = x;
            
            //        相当于以下写法
            //        NSString *key = x[0];
            //        NSString *value = x[1];
            
            NSLog(@"%@ %@",key,value);
            
        }];
        
        
        
        return;
        
        
        [_kHUDManager showActivityInView:nil withTitle:@"开始请求"];
        
        
        dispatch_group_t group = dispatch_group_create();

        [self request1:group];
        [self request2:group];
        [self request3:group];
        [self request4:group];

//        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//            DLog(@"请求完成");
//            [_kHUDManager hideAfter:3 onHide:nil];
//        });
        
         [[GCDQueue mainQueue] queueBlock:^{
             DLog(@"请求完成");
             [_kHUDManager hideAfter:3 onHide:nil];

         }];
  
    }];
    
    [self.view addSubview:testBtn];
    testBtn.frame = CGRectMake(100, 100, 100, 40);
    
    
    
    
    UITextField *textFiled = [UITextField new];
    textFiled.backgroundColor = [UIColor grayColor];
    [self.view addSubview:textFiled];
    textFiled.frame =CGRectMake(100, 180, 200, 40);
    textFiled.textColor = kColorMainColor;
    
    UITextField *passTextFiled = [UITextField new];
    passTextFiled.backgroundColor = [UIColor grayColor];
    [self.view addSubview:passTextFiled];
    passTextFiled.frame =CGRectMake(100, 290, 200, 40);
    passTextFiled.textColor = kColorMainColor;
    
//    [textFiled.rac_textSignal subscribeNext:^(id x){
//        DLog(@"%@", x);
//    }];
    
//    [[textFiled.rac_textSignal
//      filter:^BOOL(id value){
//          NSString*text = value; // implicit cast
//          return text.length > 3;
//      }]
//     subscribeNext:^(id x){
//         NSLog(@"%@", x);
//     }];
    
//    [[textFiled.rac_textSignal
//      filter:^BOOL(NSString*text){
//          return text.length > 3;
//      }]
//     subscribeNext:^(id x){
//         NSLog(@"%@", x);
//     }];
    
    [[[textFiled.rac_textSignal
       map:^id(NSString*text){
           return @(text.length);
       }]
      filter:^BOOL(NSNumber*length){
          return[length integerValue] > 3;
      }]
     subscribeNext:^(id x){
         NSLog(@"%@", x);
     }];
    
//    RACSignal *validUsernameSignal =
//    [textFiled.rac_textSignal
//     map:^id(NSString *text) {
//         return @([self isValidUsername:text]);
//     }];
//    RACSignal *validPasswordSignal =
//    [self.passwordTextField.rac_textSignal
//     map:^id(NSString *text) {
//         return @([self isValidPassword:text]);
//     }];
    
    RACSignal *validUsernameSignal =
    [textFiled.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidUsername:text]);
     }];
    RACSignal *validPasswordSignal =
    [passTextFiled.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];

    RAC(textFiled, backgroundColor) =
    [validPasswordSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor blackColor]:[UIColor yellowColor];
     }];
    
    RAC(passTextFiled, backgroundColor) =
    [validUsernameSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor blackColor]:[UIColor yellowColor];
     }];
    
    
    
    [[[[testBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x){
           testBtn.enabled =NO;
//           self.signInFailureText.hidden =YES;
       }]
      flattenMap:^id(id x){
//          return [self signInSignal];
          return nil;
      }]
     subscribeNext:^(NSNumber*signedIn){
         testBtn.enabled =YES;
         BOOL success =[signedIn boolValue];
//         self.signInFailureText.hidden = success;
         if(success){
             [self performSegueWithIdentifier:@"signInSuccess" sender:self];
         }
     }];
    
    
}
-(NSInteger)isValidUsername:(NSString*)text
{
    return text.length;
}
-(NSInteger)isValidPassword:(NSString*)text
{
    return text.length;
}
-(void)updateUI
{
    
}
//- (RACSignal *)signInSignal {
//    return [RACSignal createSignal:^RACDisposable *(id subscriber){
//        [self
//         signInWithUsername:self.usernameTextField.text
//         password:self.passwordTextField.text
//         complete:^(BOOL success){
//             [subscriber sendNext:@(success)];
//             [subscriber sendCompleted];
//         }];
//        return nil;
//    }];
//}

- (void)request1:(dispatch_group_t)group {
    dispatch_group_enter(group);
    DLog(@"请求11111111");
    
}

- (void)request2:(dispatch_group_t)group {
    dispatch_group_enter(group);
    DLog(@"请求22222222");
}

- (void)request3:(dispatch_group_t)group {
    dispatch_group_enter(group);
    DLog(@"请求333333333");

}

- (void)request4:(dispatch_group_t)group {
    dispatch_group_enter(group);
    DLog(@"请求4444444444");
    
}

@end
