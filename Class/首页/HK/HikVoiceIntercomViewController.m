//
//  HikVoiceIntercomViewController.m
//  HikVideoPlayer_Example
//
//  Created by westke on 2018/12/13.
//  Copyright © 2018年 wangchuanyin. All rights reserved.
//

#import <Toast/Toast.h>
#import <HikVideoPlayer/HikVideoPlayer.h>
#import "HikVoiceIntercomViewController.h"

static NSTimeInterval const kToastDuration = 1;

@import AVFoundation;

@interface HikVoiceIntercomViewController ()
<
HVPVoiceIntercomClientDelegate
>
@property (weak, nonatomic) IBOutlet UITextField 				*intercomTextField;
@property (nonatomic, strong) HVPVoiceIntercomClient			*intercomClient;
@property (weak, nonatomic) IBOutlet UILabel *intercomingLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;


@end

@implementation HikVoiceIntercomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //语音对讲
    
    
	_intercomTextField.text = @"rtsp://123.157.208.28:10001/EUrl/Q4gq5YQ";
}
- (IBAction)orientationChanged:(id)sender {
}

- (IBAction)startVoiceIntercom:(UIButton *)sender {
	if (_intercomTextField.text.length == 0) {
		[self.view makeToast:@"请输入对讲URL" duration:kToastDuration position:CSToastPositionCenter];
		return;
	}
	[self.intercomTextField resignFirstResponder];
	[[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (granted) {
				[self.intercomClient startVoiceIntercom:_intercomTextField.text];
			}
			else {
				[self.view makeToast:@"无保存麦克风的使用权限，不能进行语音对讲，请到设置中开启麦克风权限" duration:2 position:CSToastPositionCenter];
			}
		});
	}];
}

- (IBAction)stopVoiceIntercom:(UIButton *)sender {
	if (!_intercomClient.isIntercoming) {
		[self.view makeToast:@"未开启对讲" duration:kToastDuration position:CSToastPositionCenter];
		return;
	}
	NSError *error;
	NSString *message;
	if ([self.intercomClient stopVoiceIntercom:&error]) {
		message = @"关闭对讲成功";
		self.intercomingLabel.hidden = YES;
	}
	else {
		message = [NSString stringWithFormat:@"关闭对讲失败：%@, 错误码", @(error.code)];
	}
	[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
}

#pragma mark - HVPVoiceIntercomClientDelegate

- (void)intercomClient:(HVPVoiceIntercomClient *)intercomClient playStatus:(HVPPlayStatus)playStatus errorCode:(HVPErrorCode)errorCode {
	dispatch_async(dispatch_get_main_queue(), ^{
		NSString *message;
		if (playStatus == HVPErrorCodeSuccess) {
			message = @"开启对讲成功";
			self.intercomingLabel.hidden = NO;
		}
		else if (playStatus == HVPPlayStatusFailure){
			if (errorCode == HVPErrorCodeURLInvalid) {
				message = @"URL输入错误请检查URL或者URL已失效请更换URL";
			}
			else {
				// 提示
				message = [NSString stringWithFormat:@"开启对讲失败：%@, 错误码", @(errorCode)];
			}
		} else {
			self.intercomingLabel.hidden = YES;
			message = [NSString stringWithFormat:@"语音对讲异常%@, 错误码", @(errorCode)];
		}
		[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
	});
}

#pragma mark - Override Method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.intercomTextField resignFirstResponder];
}

#pragma mark - Setter and Getter

- (HVPVoiceIntercomClient *)intercomClient {
	if (!_intercomClient) {
		_intercomClient = [[HVPVoiceIntercomClient alloc] init];
		_intercomClient.delegate = self;
	}
	return _intercomClient;
}

@end
