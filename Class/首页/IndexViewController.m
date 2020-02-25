//
//  IndexViewController.m
//  YanGang
//
//  Created by 汪伟 on 2018/11/7.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "IndexViewController.h"
#import <ThinkVerb.h>
#import "HikRealplayViewController.h"
#import "HikPlaybackViewController.h"
#import "HikVoiceIntercomViewController.h"
#import "WWTableView.h"





@interface IndexViewController ()<BMKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,BMKGeoFenceManagerDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService* locService;

@property (nonatomic,strong) UIView *testView;


@property (nonatomic,strong) WWTableView *tbView;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"听";
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem=nil;
    
    
    
    _tbView = [[WWTableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    
    
    
    
//
//    _testView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
//    [self.view addSubview:_testView];
//    _testView.backgroundColor = [UIColor blackColor];
//

    
    
    
//    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 40, 40)];
//    [button setBGColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.view addSubview:button];
//    [button addTarget:self action:@selector(testButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//
//    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(200, 500, 40, 40)];
//   [button2 setBGColor:[UIColor blueColor] forState:UIControlStateNormal];
//   [self.view addSubview:button2];
//   [button2 addTarget:self action:@selector(testButton2Click) forControlEvents:UIControlEventTouchUpInside];
//
    
    
    
    
    
    return;
    self.FDPrefersNavigationBarHidden = YES;
    
    _mapView = [BMKMapView new];
    [self.view addSubview:_mapView];
    [_mapView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];

    //地图缩放级别
    [_mapView setZoomLevel:16.5];

    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;


    //隐藏比例尺和指南针,精度圈
    _mapView.showMapScaleBar = NO;
    _mapView.rotateEnabled = NO;   //此属性用于地图旋转手势的开启和关闭

//    //隐藏精度圈
//    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
//    param.isAccuracyCircleShow = NO;
//    [_mapView updateLocationViewWithParam:param];

    _mapView.overlookEnabled = YES;
    _mapView.delegate = self;
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

-(void)testButtonClick
{
//    NSString *rotation = _testView.TVAnimation.rotate.z.endAngle(M_PI * 2).repeat(-1).activate();
//    _testView.TVAnimation.rotate.z.endAngle(M_PI * 2).repeat(-1).activateAs(@"rotation");

    
    HikRealplayViewController *hvc = [HikRealplayViewController new];
    [self.navigationController pushViewController:hvc animated:YES];
    
}

#pragma UITableViewDasoure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellID"];
       
       if (cell == nil) {
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
       }
  
 
    NSArray *arr = @[@"实时预览",@"录像回放",@"语音对讲"];
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    #import "HikRealplayViewController.h"
//    #import "HikPlaybackViewController.h"
//    #import "HikVoiceIntercomViewController.h"
    
    if (indexPath.row == 0) {
     
        HikRealplayViewController *view = [HikRealplayViewController new];
        [self.navigationController pushViewController:view animated:YES];
    }else if (indexPath.row == 1){
        HikPlaybackViewController *view = [HikPlaybackViewController new];
        [self.navigationController pushViewController:view animated:YES];
    }else{
        HikVoiceIntercomViewController *view = [HikVoiceIntercomViewController new];
        [self.navigationController pushViewController:view animated:YES];
    }
    
  
}




-(void)testButton2Click
{
    _testView.TVAnimation.clear();
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
