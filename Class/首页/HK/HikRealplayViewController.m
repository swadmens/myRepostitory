//
//  HikRealplayViewController.m
//  HikVideoPlayer
//
//  Created by wangchuanyin on 09/06/2018.
//  Copyright (c) 2018 wangchuanyin. All rights reserved.
//

@import AVKit;
@import AVFoundation;
@import Photos;

#import <Toast/Toast.h>
#import <HikVideoPlayer/HVPError.h>
#import <HikVideoPlayer/HVPPlayer.h>
#import "HikRealplayViewController.h"
//#import "CommonMacros.h"
#import "HikUtils.h"

#define kIndicatorViewSize 50
static NSTimeInterval const kToastDuration = 1;
/// 电子放大系数
static CGFloat const kZoomMinScale   = 1.0f;
static CGFloat const kZoomMaxScale   = 10.0f;

@interface HikRealplayViewController () <UIGestureRecognizerDelegate, HVPPlayerDelegate>

@property (nonatomic, strong) UIView 					*playView;
@property (nonatomic, strong) UIButton                  *fullScreenBtn;
@property (nonatomic, strong) UIActivityIndicatorView   *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton 					*playButton;
@property (weak, nonatomic) IBOutlet UITextField 				*realplayTextField;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (nonatomic, strong) HVPPlayer							*player;
@property (nonatomic, assign) BOOL         						 isPlaying;
@property (nonatomic, assign) BOOL         						 isRecording;
@property (nonatomic, copy) NSString         					*recordPath;

@property (nonatomic, strong) UIView *playerSuperView;
@property (nonatomic, assign) CGRect playerFrame;  /// 记录原始frame
@property (nonatomic, assign) BOOL isFullScreen;   /// 是否全屏标记

@property (nonatomic, assign) CGRect fullScreenBtnFrame;

@property (nonatomic, strong) UIPinchGestureRecognizer *zoomPinchRecognizer; ///电子放大捏合手势
@property (nonatomic, assign) CGFloat                   currentZoomScale;   ///当前电子放大的系数
@property (nonatomic, assign) CGFloat                   previousZoomScale;  ///上次电子放大的系数
@property (nonatomic, assign) CGRect                    specificRect;

@end

@implementation HikRealplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //实时预览
    
    [self configureSubviews];
    
    [self setupObservers];
	
	// 实际开发中需要根据平台获取
	_realplayTextField.text = @"rtsp://123.157.208.28:10001/EUrl/Q4gq5YQ";
    
}

- (void)dealloc {
    if (_isRecording) {
        //如果在录像，先关闭录像
        [self recordVideo:_recordButton];
    }
    // 退出当前页面，需要停止播放
    if (_isPlaying) {
        [_player stopPlay:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark - Private methods
- (void)configureSubviews {
    /// playview需要旋转 不能使用storyboard拖控件
    [self.view addSubview:self.playView];
    [self.view addSubview:self.fullScreenBtn];
    [self.view addSubview:self.indicatorView];
    
    self.playView.frame = CGRectMake(0, SafeAreaTopHeight, kScreenWidth, 250);
    self.fullScreenBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 110, 200 + SafeAreaTopHeight, 140, 50);
    [self.playView addGestureRecognizer:self.zoomPinchRecognizer];
    self.indicatorView.frame = CGRectMake(kScreenWidth/2 - kIndicatorViewSize/2, SafeAreaTopHeight + 125 - kIndicatorViewSize/2, kIndicatorViewSize, kIndicatorViewSize);
    
    self.currentZoomScale = kZoomMinScale;
    self.previousZoomScale = kZoomMinScale;
    self.specificRect = _playView.bounds;
}

- (void)setupObservers {
    // 注册前后台切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/// 进入全屏模式
- (void)entryFullScreen {
    if (self.isFullScreen) {
        return;
    }
    
    self.playerSuperView = self.playView.superview;
    self.playerFrame = self.playView.frame;
    self.fullScreenBtnFrame = self.fullScreenBtn.frame;
    
    CGRect rectInWindow = [self.playView convertRect:self.playView.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGRect btnRect = [self.fullScreenBtn convertRect:self.fullScreenBtn.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self.playView removeFromSuperview];
    [self.fullScreenBtn removeFromSuperview];
    self.playView.frame = rectInWindow;
    self.fullScreenBtn.frame = btnRect;
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.playView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.fullScreenBtn];
    
    [UIView animateWithDuration:0.3 animations:^{

        self.playView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.playView.bounds = CGRectMake(0, 0, CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds), CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds));
        self.playView.center = CGPointMake(CGRectGetMidX([UIApplication sharedApplication].keyWindow.bounds), CGRectGetMidY([UIApplication sharedApplication].keyWindow.bounds));
    } completion:^(BOOL finished) {
        [self.fullScreenBtn setTitle:@"退出全屏" forState:UIControlStateNormal];
        self.isFullScreen = YES;
    }];
}

/// 退出全屏模式
- (void)exitFullScreen {
    if (!self.isFullScreen) {
        return;
    }
    
    CGRect frame = [self.playerSuperView convertRect:self.playerFrame toView:[UIApplication sharedApplication].keyWindow];
    [UIView animateWithDuration:0.3 animations:^{
        self.playView.transform = CGAffineTransformIdentity;
        self.playView.frame = frame;
    } completion:^(BOOL finished) {
        [self.playView removeFromSuperview];
        [self.fullScreenBtn removeFromSuperview];
        self.playView.frame = self.playerFrame;
        [self.playerSuperView addSubview:self.playView];
        [self.playerSuperView addSubview:self.fullScreenBtn];
        self.isFullScreen = NO;
        [self.fullScreenBtn setTitle:@"切为全屏" forState:UIControlStateNormal];
    }];
}

#pragma mark - Actions
/// 硬解码开关，开关开启表示启用硬解码，关闭表示使用软解码
- (IBAction)switchOn:(id)sender {
    UISwitch *switchOn = sender;
    if (_isPlaying) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该项设置必须在开始播放前设置好" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        switchOn.on = !switchOn.on;
    }else {
        /// 开启硬解码
        [self.player setHardDecodePlay:switchOn.on];
    }
}
/// 智能信息显示开关，开启表示显示智能信息，关闭表示不显示智能信息
- (IBAction)smartModeOn:(id)sender {
    UISwitch *switchOn = sender;
    if (_isPlaying) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该项设置必须在开始播放前设置好" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        switchOn.on = !switchOn.on;
    }else {
        [self.player setSmartDetect:switchOn.on];
    }
}

/// 开始预览按钮
- (IBAction)startRealPlay:(UIButton *)sender {
	if ([sender.currentTitle isEqualToString:@"开始预览"]) {
		if (_realplayTextField.text.length == 0) {
			[self.view makeToast:@"请输入预览URL" duration:kToastDuration position:CSToastPositionCenter];
			return;
		}
		// 开始加载动画
		[self.indicatorView startAnimating];
		// 为避免卡顿，开启预览可以放到子线程中，在应用中灵活处理
		if (![self.player startRealPlay:_realplayTextField.text]) {
			[self.indicatorView stopAnimating];
		}
		return;
	}
	if (_isRecording) {
		//如果在录像，先关闭录像
		[self recordVideo:_recordButton];
	}
	[_player stopPlay:nil];
	_isPlaying = NO;
	[sender setTitle:@"开始预览" forState:UIControlStateNormal];
}

/// 全屏按钮点击
- (void)fullScreenBtnClick:(UIButton *)sender {
    if (self.isFullScreen) {
        [self exitFullScreen];
    }else {
        [self entryFullScreen];
    }
}

// 抓图
- (IBAction)capturePicture:(UIButton *)sender {
	if (!_isPlaying) {
		[self.view makeToast:@"未播放视频，不能抓图" duration:kToastDuration position:CSToastPositionCenter];
		return;
	}
	[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (status == PHAuthorizationStatusDenied) {
				[self.view makeToast:@"无保存图片到相册的权限，不能抓图" duration:kToastDuration position:CSToastPositionCenter];
			}
			else {
				[self capture];
			}
		});
	}];
}

- (void)capture {
	if (!_isPlaying) {
		return;
	}
	// 生成图片路径
	NSString *documentDirectorie = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
	NSString *filePath = [documentDirectorie stringByAppendingFormat:@"/%.f.jpg", [NSDate date].timeIntervalSince1970];
	NSError *error;
	if (![_player capturePicture:filePath error:&error]) {
		NSString *message = [NSString stringWithFormat:@"抓图失败，错误码是 0x%08lx", error.code];
		[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
	}
	else {
		[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
			[PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL URLWithString:filePath]];
		} completionHandler:^(BOOL success, NSError * _Nullable error) {
			NSString *message;
			if (success) {
				message = @"抓图成功，并保存到系统相册";
			}
			else {
				message = @"保存到系统相册失败";
			}
			[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
			});
		}];
	}
}

// 录像
- (IBAction)record:(UIButton *)sender {
	if (!_isPlaying) {
		[self.view makeToast:@"未播放视频，不能录像" duration:kToastDuration position:CSToastPositionCenter];
		return;
	}
	[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
		if (status == PHAuthorizationStatusDenied) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.view makeToast:@"无保存录像到相册的权限，不能录像" duration:1 position:CSToastPositionCenter];
			});
		}
		else {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self recordVideo:sender];
			});
		}
	}];
}

- (void)recordVideo:(UIButton *)sender {
	if (!_isPlaying) {
		return;
	}
	NSError *error;
	// 开始录像
	if ([sender.currentTitle isEqualToString:@"开始录像"]) {
		// 生成图片路径
		NSString *documentDirectorie = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
		NSString *filePath = [documentDirectorie stringByAppendingFormat:@"/%.f.mp4", [NSDate date].timeIntervalSince1970];
		_recordPath = [filePath copy];
		if ([_player startRecord:filePath error:&error]) {
			_isRecording = YES;
			[sender setTitle:@"停止录像" forState:UIControlStateNormal];
		}
		else {
			NSString *message = [NSString stringWithFormat:@"开始录像失败，错误码是 0x%08lx", error.code];
			[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
		}
		return;
	}
	if (!_isRecording) {
		return;
	}
	// 停止录像
	if ([_player stopRecord:&error]) {
		_isRecording = NO;
		[sender setTitle:@"开始录像" forState:UIControlStateNormal];
        //可在自定义recordPath路径下取录像文件
		[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
			[PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL URLWithString:_recordPath]];
		} completionHandler:^(BOOL success, NSError * _Nullable error) {
			NSString *message;
			if (success) {
				message = @"录像成功，并保存到系统相册";
			}
			else {
				message = @"保存到系统相册失败";
			}
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
			});
		}];
	}
	else {
		NSString *message = [NSString stringWithFormat:@"停止录像失败，错误码是 0x%08lx", error.code];
		[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
	}
}

// 声音
- (IBAction)sound:(UIButton *)sender {
	if (!_isPlaying) {
		[self.view makeToast:@"未播放视频，不能静音" duration:kToastDuration position:CSToastPositionCenter];
		return;
	}
	NSError *error;
	if ([sender.currentTitle isEqualToString:@"静音"]) {
		if ([_player enableSound:NO error:&error]) {
			[sender setTitle:@"开启声音" forState:UIControlStateNormal];
		}
		else {
			NSString *message = [NSString stringWithFormat:@"静音失败，错误码是 0x%08lx", error.code];
			[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
		}
		return;
	}
	// 开启声音
	if ([_player enableSound:YES error:&error]) {
		[sender setTitle:@"静音" forState:UIControlStateNormal];
	}
	else {
		NSString *message = [NSString stringWithFormat:@"开启声音失败，错误码是 0x%08lx", error.code];
		[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
	}
}

/// 手势捏合放大缩小player
/// @param pinchRecognizer 捏合手势
- (void)zoomPinchRecognizerDidTapped:(UIPinchGestureRecognizer *)pinchRecognizer {
    if (!_isPlaying) {
        return;
    }
    CGPoint touchPoint = [pinchRecognizer locationInView:self.playView];
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        pinchRecognizer.scale = _currentZoomScale;
    }
    else if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
        if (pinchRecognizer.scale > kZoomMaxScale) {
            pinchRecognizer.scale = kZoomMaxScale;
            return;
        }
        if (pinchRecognizer.scale <= kZoomMinScale) {
            pinchRecognizer.scale = kZoomMinScale;
            _currentZoomScale = kZoomMinScale;
            BOOL closed = [_player closeDigitalZoom];
            if (!closed) {
                NSLog(@"电子放大关闭");
            }
            return;
        }
        _currentZoomScale = pinchRecognizer.scale;
        // 先将对PlayView上的操作转换成可视播放视图的Rect
        [HikUtils convertPlayViewRect:_playView.frame toSpecificRect:&_specificRect zoomScale:_currentZoomScale touchPoint:touchPoint];
        [HikUtils rectIntersectionBetweenRect:_playView.bounds specificRect:&_specificRect];
        
        BOOL zoomed = [_player openDigitalZoom:_specificRect];
        if (!zoomed) {
            NSLog(@"电子放大失败");
        }
        _previousZoomScale = _currentZoomScale;
    }

}

#pragma mark - HVPPlayerDelegate

- (void)player:(HVPPlayer *)player playStatus:(HVPPlayStatus)playStatus errorCode:(HVPErrorCode)errorCode {
	dispatch_async(dispatch_get_main_queue(), ^{
		// 如果有加载动画，结束加载动画
        if ([self.indicatorView isAnimating]) {
            [self.indicatorView stopAnimating];
        }
		_isPlaying = NO;
		NSString *message;
		// 预览时，没有HVPPlayStatusFinish状态，该状态表明录像片段已播放完
		if (playStatus == HVPPlayStatusSuccess) {
			_isPlaying = YES;
			[_playButton setTitle:@"停止预览" forState:UIControlStateNormal];
			// 默认开启声音
			[_player enableSound:YES error:nil];
		}
		else if (playStatus == HVPPlayStatusFailure) {
			if (errorCode == HVPErrorCodeURLInvalid) {
				message = @"URL输入错误请检查URL或者URL已失效请更换URL";
			}
			else {
				message = [NSString stringWithFormat:@"开启预览失败, 错误码是 : 0x%08lx", errorCode];
			}
            _player = nil;
		}
		else if (playStatus == HVPPlayStatusException) {
			// 预览过程中出现异常, 可能是取流中断，可能是其他原因导致的，具体根据错误码进行区分
			// 做一些提示操作
			message = [NSString stringWithFormat:@"播放异常, 错误码是 : 0x%08lx", errorCode];
			if (_isRecording) {
				//如果在录像，先关闭录像
				[self recordVideo:_recordButton];
			}
			// 关闭播放
			[_player stopPlay:nil];
		}
		if (message) {
			[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
		}
	});
}

#pragma mark - Private Method

- (void)applicationWillResignActive {
	if (_isRecording) {
		[self recordVideo:_recordButton];
	}
	_isPlaying = NO;
	[_player stopPlay:nil];
}

- (void)applicationDidBecomeActive {
	if ([_playButton.currentTitle isEqualToString:@"停止预览"]) {
		[self.indicatorView stopAnimating];
		if (![_player startRealPlay:_realplayTextField.text]) {
			[self.indicatorView stopAnimating];
		}
	}
}

#pragma mark - Override Method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[_realplayTextField resignFirstResponder];
}

#pragma mark - Setter or Getter

- (HVPPlayer *)player {
	if (!_player) {
		// 创建player
		_player = [[HVPPlayer alloc] initWithPlayView:self.playView];
		// 或者 _player = [HVPPlayer playerWithPlayView:self.playView];
		// 设置delegate
		_player.delegate = self;
	}
	return _player;
}

- (UIView *)playView {
    if (!_playView) {
        _playView = [[UIView alloc] init];
        _playView.backgroundColor = [UIColor grayColor];
    }
    return _playView;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [[UIButton alloc] init];
        [_fullScreenBtn setTitle:@"切为全屏" forState:  UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fullScreenBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _indicatorView;
}

- (UIPinchGestureRecognizer *)zoomPinchRecognizer {
    if (!_zoomPinchRecognizer) {
        _zoomPinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomPinchRecognizerDidTapped:)];
        _zoomPinchRecognizer.delegate = self;
    }
    return _zoomPinchRecognizer;
}

@end
