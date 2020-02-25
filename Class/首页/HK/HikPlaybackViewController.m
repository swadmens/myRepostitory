//
//  HikPlaybackViewController.m
//  HikVideoPlayer_Example
//
//  Created by westke on 2018/9/13.
//  Copyright © 2018年 wangchuanyin. All rights reserved.
//

@import AVKit;
@import AVFoundation;
@import Photos;

#import <Toast/Toast.h>
#import <HikVideoPlayer/HVPError.h>
#import <HikVideoPlayer/HVPPlayer.h>
#import "HikPlaybackViewController.h"
//#import "CommonMacros.h"
#import "HikUtils.h"

#define kIndicatorViewSize 50
static NSTimeInterval const kToastDuration = 1;
/// 电子放大系数
static CGFloat const kZoomMinScale   = 1.0f;
static CGFloat const kZoomMaxScale   = 10.0f;

@interface HikPlaybackViewController ()<HVPPlayerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView                    *playView;
@property (nonatomic, strong) UIButton                  *fullScreenBtn;
@property (nonatomic, strong) UIActivityIndicatorView   *indicatorView;
@property (weak, nonatomic) IBOutlet UISlider 					*progressSlider;
@property (weak, nonatomic) IBOutlet UILabel 					*currentPlayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel 					*endTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton 					*playButton;
@property (weak, nonatomic) IBOutlet UITextField 				*playbackTextField;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (nonatomic, strong) HVPPlayer							*player;
@property (nonatomic, assign) NSTimeInterval         			 startTime;
@property (nonatomic, assign) NSTimeInterval         			 endTime;
@property (nonatomic, assign) NSTimeInterval         			 currentPlayTime;
@property (nonatomic, strong) dispatch_source_t 				 timer;
@property (nonatomic, assign) BOOL         						 isPlaying;
@property (nonatomic, assign) BOOL         						 isRecording;
@property (nonatomic, copy) NSString         					*recordPath;

@property (nonatomic, strong) UIView *playerSuperView;
@property (nonatomic, assign) CGRect playerFrame;  /// 记录原始frame
@property (nonatomic, assign) BOOL isFullScreen;   /// 是否全屏标记
@property (nonatomic, strong) UIPinchGestureRecognizer *zoomPinchRecognizer; ///电子放大捏合手势
@property (nonatomic, assign) CGFloat                   currentZoomScale;   ///当前电子放大的系数
@property (nonatomic, assign) CGFloat                   previousZoomScale;  ///上次电子放大的系数
@property (nonatomic, assign) CGRect                    specificRect;

@end

@implementation HikPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //录像回放
    
    
    
    [self configureSubviews];
    [self setupObservers];
    [self setupStartEndTime];
	// 实际开发中需要根据平台获取
	_playbackTextField.text = @"rtsp://123.157.208.28:10001/EUrl/Q4gq5YQ";
}

- (void)dealloc {
    // 退出当前页面，需要停止播放
    if (_isRecording) {
        //如果在录像，先关闭录像
        [self recordVideo:_recordButton];
    }
    if (_isPlaying) {
        [_player stopPlay:nil];
    }
}

#pragma mark - Private methods
- (void)configureSubviews {
    /// playview需要旋转 不能使用storyboard托控件
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

- (void)setupStartEndTime {
    // 这里startTime和endTime是测试时随便指定的(当天0点到当天23点59分59秒)，真实情况下，应该从平台获取录像片段，然后取第一个片段的开始时间和最后一个片段的结束时间
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSString *startTimeStr = [NSString stringWithFormat:@"%02ld-%02ld-%02ld 00:00:00", dateComponents.year, dateComponents.month, dateComponents.day];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startTime = [dateFormatter dateFromString:startTimeStr];
    // 当天的0点0分0秒
    _startTime = [startTime timeIntervalSince1970];
    // 当天的23点59分59秒
    _endTime = _startTime + 24 * 3600 - 1;
    dateFormatter.dateFormat = @"HH:mm:ss";
    startTimeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startTime]];
    NSString *endTimeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_endTime]];
    _currentPlayTimeLabel.text = startTimeStr;
    _endTimeLabel.text = endTimeStr;
}

/// 进入全屏模式
- (void)entryFullScreen {
    if (self.isFullScreen) {
        return;
    }
    
    self.playerSuperView = self.playView.superview;
    self.playerFrame = self.playView.frame;
    
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
//        self.fullScreenBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
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
- (void)fullScreenBtnClick:(UIButton *)sender {
    if (self.isFullScreen) {
        [self exitFullScreen];
    }else {
        [self entryFullScreen];
    }
}

- (IBAction)switchOn:(id)sender {
    UISwitch *switchOn = sender;
    if (_isPlaying) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该项设置必须在开始播放前设置好" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        switchOn.on = !switchOn.on;
    }else {
        [self.player setHardDecodePlay:switchOn.on];
    }
}

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

- (IBAction)startPlayBack:(UIButton *)sender {
	if ([sender.currentTitle isEqualToString:@"开始回放"]) {
		if (_playbackTextField.text.length == 0) {
			[self.view makeToast:@"请输入回放的URL" duration:kToastDuration position:CSToastPositionCenter];
			return;
		}
		// 开始加载动画
		[self.indicatorView startAnimating];
		// 为避免卡顿，开启回放可以放到子线程中，在应用中灵活处理
		if (![self.player startPlayback:_playbackTextField.text startTime:_startTime endTime:_endTime]) {
			[self.indicatorView stopAnimating];
		}
		return;
	}
	// 关闭录像
	if (_isRecording) {
		[self recordVideo:_recordButton];
	}
	[_player stopPlay:nil];
	_isPlaying = NO;
	_progressSlider.value = 0;
	_currentPlayTimeLabel.text = @"00:00:00";
	[sender setTitle:@"开始回放" forState:UIControlStateNormal];
	if (_timer) {
		dispatch_cancel(_timer);
		_timer = nil;
	}
}

#pragma mark - 其他操作, 只演示暂停和恢复播放、静音及seek操作，其他操作同预览的一样

// 暂停恢复
- (IBAction)pause:(UIButton *)sender {
	if (!_isPlaying) {
		[self.view makeToast:@"未播放视频，不能操作" duration:kToastDuration position:CSToastPositionCenter];
		return;
	}
	NSError *error;
	if ([sender.currentTitle isEqualToString:@"暂停"]) {
		if ([_player pause:&error]) {
			[sender setTitle:@"恢复" forState:UIControlStateNormal];
		}
		else {
			NSString *message = [NSString stringWithFormat:@"暂停失败，错误码是 0x%08lx", error.code];
			[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
		}
		return;
	}
	// 恢复
	if ([_player resume:&error]) {
		[sender setTitle:@"暂停" forState:UIControlStateNormal];
	}
	else {
		NSString *message = [NSString stringWithFormat:@"恢复回放失败，错误码是 0x%08lx", error.code];
		[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
	}
}

- (IBAction)capturePicture:(UIButton*)sender {
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
		// 请求权限时，系统弹窗会导致进入后台，停止播放
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

- (IBAction)record:(UIButton *)sender {
	if (!_isPlaying) {
		[self.view makeToast:@"未播放视频，不能录像" duration:kToastDuration position:CSToastPositionCenter];
		return;
	}
	
	[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
		if (status == PHAuthorizationStatusDenied) {
			[self.view makeToast:@"无保存录像到相册的权限，不能录像" duration:kToastDuration position:CSToastPositionCenter];
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

// 声音操作
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

- (IBAction)startToSeek:(UISlider *)sender {
	if (_timer) {
		dispatch_cancel(_timer);
		_timer = nil;
	}
}

// 定位操作
- (IBAction)seekToTime:(UISlider *)sender {
	CGFloat progress = sender.value;
	NSTimeInterval currentPlayTime = (_endTime - _startTime) * progress + _startTime;
	[self.indicatorView startAnimating];
	[_player seekToTime:currentPlayTime];
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
		if (self.indicatorView.isAnimating) {
			[self.indicatorView stopAnimating];
		}
		_isPlaying = NO;
		NSString *message;
		if (playStatus == HVPPlayStatusSuccess) {
			_isPlaying = YES;
			[_playButton setTitle:@"停止回放" forState:UIControlStateNormal];
			// 默认开启声音
			[_player enableSound:YES error:nil];
			// 开启定时器更新播放进度条
			[self startUpdatePlayProgressTimer];
		}
		else if (playStatus == HVPPlayStatusFailure) {
			if (errorCode == HVPErrorCodeURLInvalid) {
				message = @"URL输入错误请检查URL或者URL已失效请更换URL";
			}
			else {
				// 提示,自己判断是start还是seek
				message = [NSString stringWithFormat:@"开启预览失败, 错误码是 : 0x%08lx", errorCode];
			}
            _player = nil;
            // 关闭播放
            [_player stopPlay:nil];
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
			_progressSlider.value = 0;
			_currentPlayTimeLabel.text = @"00:00:00";
		}
		else {
			message = @"回放结束";
		}
		if (message) {
			[self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
		}
	});
}

#pragma mark - Private Method

/**
 每秒刷新两次
 */
- (void)startUpdatePlayProgressTimer {
	if (!_timer) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
		dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
		dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
		dispatch_source_set_event_handler(timer, ^{
			NSError *error;
			NSString *osdTime = [_player getOSDTime:&error];
			if (!error) {
				NSLog(@"osdTime : %@", osdTime);
				_currentPlayTimeLabel.text = [osdTime componentsSeparatedByString:@" "].lastObject;
				NSDate *date = [dateFormatter dateFromString:osdTime];
				NSTimeInterval currentPlayTime = date.timeIntervalSince1970;
				_currentPlayTime = currentPlayTime;
				_progressSlider.value =  (currentPlayTime - _startTime) / (_endTime - _startTime);
			}
		});
		dispatch_resume(timer);
		_timer = timer;
	}
}

- (void)applicationWillResignActive {
	if (_isRecording) {
		[self recordVideo:_recordButton];
	}
	_isPlaying = NO;
	[_player stopPlay:nil];
}

- (void)applicationDidBecomeActive {
	if ([_playButton.currentTitle isEqualToString:@"停止回放"]) {
		[self.indicatorView startAnimating];
		if (![_player startPlayback:_playbackTextField.text startTime:_currentPlayTime endTime:_endTime]) {
			[self.indicatorView stopAnimating];
		}
	}
}

#pragma mark - Override Method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[_playbackTextField resignFirstResponder];
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
