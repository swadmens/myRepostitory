//
//  GuideNewController.m
//  TaoChongYouPin
//
//  Created by 汪伟 on 2018/4/16.
//  Copyright © 2018年 FusionHK. All rights reserved.
//

#import "GuideNewController.h"
#import "EPBannerView.h"
#import "RequestSence.h"
#import "UIImageView+WebCache.h"

@interface GuideNewController ()

@property (nonatomic, strong) EPBannerView *adView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) UIButton *jumpBtn;

@end

@interface GuideNewModel:NSObject

@property(nonatomic,strong) NSString *ad_code;
@property(nonatomic,strong) NSDictionary *ad_link;

+(GuideNewModel*)makeUpData:(NSDictionary*)dic;
@end


@implementation GuideNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor=[UIColor whiteColor];
    
    [self reloadDataIfNeed];
    [self creadBottomViewUI];
    
}
-(void)creadNotification
{
    //注册通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GuideNewController" object:nil userInfo:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//底部的视图
-(void)creadBottomViewUI
{
    UIView *bView=[UIView new];
    bView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bView];
    [bView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    [bView addHeight:127];
    
    
    UIImageView *iconImage=[UIImageView new];
    iconImage.image=UIImageWithFileName(@"about_us_logo");
    [bView addSubview:iconImage];
    [iconImage yCenterToView:bView];
    [iconImage addCenterX:-64 toView:bView];
    [iconImage addWidth:51];
    [iconImage addHeight:51];
    
    UILabel *nameLabel=[UILabel new];
    nameLabel.text = NSLocalizedString(@"yubei", nil);
    nameLabel.textColor=kColorMainTextColor;
    nameLabel.font=[UIFont customFontWithSize:30];
    [nameLabel sizeToFit];
    [bView addSubview:nameLabel];
    [nameLabel yCenterToView:bView];
    [nameLabel leftToView:iconImage withSpace:10];
    
}
//轮播图的
-(void)topEpbannerViewUI
{
    NSMutableArray *adList=[NSMutableArray array];
    NSMutableArray *adTarget=[NSMutableArray array];
    for (GuideNewModel *gModel in self.dataArray) {
        NSString *list=[NSString stringWithFormat:@"%@",gModel.ad_code];
        NSDictionary *dicList=(NSDictionary*)gModel.ad_link;
        [adList addObject:list];
        [adTarget addObject:dicList];
    }
    
    if (adList.count <=0) {
        return;
    }
    
    CGFloat height = kMainScreenSize.height - 127;
    if (self.adView.superview == nil) {
        self.adView = [[EPBannerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSize.width, height)];
        self.adView.backgroundColor = kColorBackgroundColor;
        self.adView.PControlType = EPPageControlDefault;
        self.adView.autoScroll = NO;
        self.adView.shouldLoop = NO;
    }
    self.adView.frame = CGRectMake(0, 0, kMainScreenSize.width, height);
    [self.adView reloadWithData:adList];
    self.adView.selectedColor = [UIColor whiteColor];
    self.adView.unSelectedColor = UIColorFromRGB(0xe0e0e0, 1);
    [self.view addSubview:self.adView];
    
    //轮播图点击跳转
    self.adView.clickedBlock = ^(NSInteger index) {
        NSString *targetId=[WWPublicMethod jsonTransFromObject:[adTarget objectAtIndex:index]];
        [TargetEngine  pushViewController:nil fromController:nil withTarget:targetId];
    };
    
    self.adView.moreTriggerBlock = ^{
//        [self action_finish_click];
    };
}

//直接顶部一张图
-(void)creadTopOneImageUI
{
    GuideNewModel *model=[self.dataArray firstObject];
    
    UIImageView *topImageView=[UIImageView new];
    topImageView.userInteractionEnabled=YES;
    [topImageView sd_setImageWithURL:[NSURL URLWithString:model.ad_code]];
    [self.view addSubview:topImageView];
    [topImageView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [topImageView addHeight:kMainScreenSize.height-127];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topImageViewClick:)];
    [topImageView addGestureRecognizer:tap];
    
    
    
    
    UIColor *bgcolor=UIColorFromRGB(0x333333, 0.3);
    
    NSString *title = [NSString stringWithFormat:@"3 %@",NSLocalizedString(@"jump", nil)];
    
    _jumpBtn=[UIButton new];
    _jumpBtn.clipsToBounds=YES;
    _jumpBtn.layer.cornerRadius=12.5;
    _jumpBtn.titleLabel.font=[UIFont customFontWithSize:kFontSizeTwelve];
    [_jumpBtn setBGColor:bgcolor forState:UIControlStateNormal];
    [_jumpBtn setTitle:title forState:UIControlStateNormal];
    [_jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_jumpBtn addTarget:self action:@selector(action_finish_click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jumpBtn];
    [_jumpBtn topToView:self.view withSpace:30];
    [_jumpBtn rightToView:self.view withSpace:19];
    [_jumpBtn addWidth:60];
    [_jumpBtn addHeight:25];
    
    [self startTimer];
}
/// 跳过倒计时
- (void)startTimer
{
    __block int timeout = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self action_finish_click];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *timerStr=[NSString stringWithFormat:@"%@ %@",strTime,NSLocalizedString(@"jump", nil)];
                [_jumpBtn setTitle:timerStr forState:UIControlStateNormal];
                
                timeout--;
            });
        }
    });
    dispatch_resume(_timer);
}

-(void)topImageViewClick:(UITapGestureRecognizer*)tp
{
    [self hideGuideView];
    
    GuideNewModel *model=[self.dataArray firstObject];
    NSString *targetId=[WWPublicMethod jsonTransFromObject:model.ad_link];
    [TargetEngine  pushViewController:nil fromController:nil withTarget:targetId];
    
}


-(void)action_finish_click
{
    [self hideGuideView];
    [self creadNotification];
}
-(void)hideGuideView
{
    [UIView animateWithDuration:0.4 animations:^{
        self.view.alpha = 0.0;
        self.view.transform = CGAffineTransformMakeScale(6.0, 6.0);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

//请求数据
- (void)reloadDataIfNeed
{
    RequestSence *sence=[[RequestSence alloc]init];
    sence.pathURL = @"home/ad_load";
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:^{
            [weak_self didFinishedRequest:obj];
        }];
    };
    sence.errorBlock = ^(NSError *error) {
       
    };
    [sence sendRequest];
}
- (void)didFinishedRequest:(id)obj
{
    [[GCDQueue mainQueue] queueBlock:^{
        NSArray *data=[obj objectForKey:@"data"];
        NSMutableArray *tempArr=[NSMutableArray arrayWithCapacity:data.count];
        for (NSDictionary *dic in data) {
            GuideNewModel *model=[GuideNewModel makeUpData:dic];
            [tempArr addObject:model];
        }
        self.dataArray=[NSMutableArray arrayWithArray:tempArr];
        
        
        if (self.dataArray.count==0) {
            [self action_finish_click];
            return ;
        }
        
//        [self topEpbannerViewUI];
        [self creadTopOneImageUI];
        
        
//        //延时执行，3秒后自动跳过
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            [self action_finish_click];
//        });
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation GuideNewModel
+(GuideNewModel*)makeUpData:(NSDictionary*)dic
{
    GuideNewModel *model=[[GuideNewModel alloc]init];
    
    model.ad_code=[dic objectForKey:@"ad_code"];
    model.ad_link = [dic objectForKey:@"ad_link"];
    
    return model;
}

@end

