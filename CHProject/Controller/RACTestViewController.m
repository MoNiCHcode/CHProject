//
//  RACTestViewController.m
//  CHProject
//
//  Created by hulni on 2018/5/22.
//  Copyright © 2018年 中资. All rights reserved.
//

#import "RACTestViewController.h"

@interface RACTestViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UIButton *racbutton;
@property (nonatomic,strong)UILabel *testLab;
@property (nonatomic,strong)UITextField *testField;
@end

@implementation RACTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - RAC_action
-(void)rac_butttonaction
{
    [[self.racbutton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

-(void)buttonClick
{
    NSLog(@"点击了");
}

#pragma mark - kvo 监听 lab的text变化
-(void)KVO_method
{
    [self.testLab addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"] && object == self.testLab) {
        NSLog(@"%@",change);
    }
}

#pragma mark - RAC_KVO
-(void)RAC_KVO{
    [RACObserve(self, self.testLab) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - RACTextFieldDelegate
-(void)RACTextFieldDelegate
{
//    @weakify(self)
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
//        @strongify(self)
        NSLog(@"%@",x);
    }];
    
    self.testField.delegate = self;
}
#pragma mark - RAC_Notification
-(void)RAC_Notification
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - TACTimer
-(void)RACTimer{
    
}

#pragma mark - RAC_BASE_USE rac 的基本用法和流程
-(void)RAC_Base
{
    //1.创建singal信号
    RACSignal *singal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //subscriber 不是一个对象
        //3.发送信号
        [subscriber sendNext:@"sendOneMessage"];
        
        //发送错误信号
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:1001 userInfo:@{@"errorMsg":@"this is a error"}];
        [subscriber sendError:error];
        
        //销毁信号
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号已销毁");
        }];
        
        
    }];
    
    //2.1 订阅信号
    [singal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //2.2 订阅error信号
    [singal subscribeError:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - lazy load

- (UIButton *)racbutton{
    if(!_racbutton){
        _racbutton=[[UIButton alloc] init];
        [_racbutton addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _racbutton;
}

- (UILabel *)testLab{
    if(!_testLab){
        _testLab=[[UILabel alloc] init];
    }
    return _testLab;
}

- (UITextField *)testField{
    if(!_testField){
        _testField=[[UITextField alloc] init];
    }
    return _testField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
