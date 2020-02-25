//
//  RetrievePasswordController.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/21.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "RetrievePasswordController.h"
//#import "LoginChooseCountriesCell.h"
//#import "RetrievePasswordCell.h"
//#import "CountryAreaCodeController.h"
//#import "LGXThirdEngine.h"
//#import "LGXSMSEngine.h"
#import "WWTableView.h"
#import "RequestSence.h"
//#import "LoginButtonCell.h"
//#import "ResetPwdSence.h"


@interface RetrievePasswordController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RetrievePasswordController

//-(void)setupTableView
//{
////    self.tableView = [[WWTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.tableView = [[WWTableView alloc] init];
//    self.tableView.backgroundColor = kColorBackgroundColor;
//    [self.view addSubview:self.tableView];
//    [self.tableView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 50;
//    [self.tableView registerClass:[LoginChooseCountriesCell class] forCellReuseIdentifier:[LoginChooseCountriesCell getCellIDStr]];
//    [self.tableView registerClass:[RetrievePasswordCell class] forCellReuseIdentifier:[RetrievePasswordCell getCellIDStr]];
//    [self.tableView registerClass:[LoginButtonCell class] forCellReuseIdentifier:[LoginButtonCell getCellIDStr]];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"findPassword", nil);
   
    
//    [self setupTableView];
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 5;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    if (indexPath.row == 0) {
//        LoginChooseCountriesCell *cell = [tableView dequeueReusableCellWithIdentifier:[LoginChooseCountriesCell getCellIDStr] forIndexPath:indexPath];
//        [cell makeCellData:self.countryCode withBackColor:[UIColor whiteColor] withLineHide:YES];
//        cell.lineHidden = NO;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        return cell;
//    }else if (indexPath.row == 4){
//        LoginButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[LoginButtonCell getCellIDStr] forIndexPath:indexPath];
//        cell.lineHidden = NO;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell makeCellData:@"sure"];
//        [cell setLoginButtonClick:^{
//            //找回密码
//            [self firstChenckYanZhengMa];
//        }];
//
//        return cell;
//
//    }else{
//        RetrievePasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:[RetrievePasswordCell getCellIDStr] forIndexPath:indexPath];
//        cell.lineHidden = NO;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        NSString *icon = [self.dataArray objectAtIndex:indexPath.row-1];
//
//        NSString *place = [self.placeArray objectAtIndex:indexPath.row-1];
//
//        [cell makeCellData:icon withPlace:place withTag:indexPath.row withStyle:self.sendCode];
//
//        cell.textFieldText = ^(NSString *text) {
//            if(indexPath.row == 1){
//                self.phoneNum = text;
//            }else if(indexPath.row == 2){
//                self.codeNum = text;
//            }else{
//                self.password = text;
//            }
//        };
//        cell.sendCodeButton = ^{
//            //发送验证码
//            [self action_getVers];
//        };
//        return cell;
//    }
//
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [UIView new];
//    headerView.backgroundColor = kColorBackgroundColor;
//
//    UILabel *textLabel = [UILabel new];
//    textLabel.text = [NSString stringWithFormat:@"%@ +%@ %@",NSLocalizedString(@"nowPhoneNumIs", nil),_kUserModel.userInfo.zone_number,_kUserModel.userInfo.mobile];
//    textLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
//    textLabel.textColor = kColorMainViceTextColor;
//    [headerView addSubview:textLabel];
//    [textLabel leftToView:headerView withSpace:15];
//    [textLabel yCenterToView:headerView];
//
//    return headerView;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 45;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == 0) {
//        CountryAreaCodeController *cvc = [CountryAreaCodeController new];
//        cvc.sortedNameDict = [NSDictionary dictionaryWithDictionary:self.sortedNameDict];
//        cvc.delegate = self;
//        [self.navigationController pushViewController:cvc animated:YES];
//    }
//}
//-(void)sendValue:(NSString *)value withid:(NSString *)zone_number
//{
//    self.countryCode = value;
//    self.zone_number = zone_number;
//    [self.tableView reloadData];
//}

//#pragma mark - 获取验证码
///// 获取验证码
//- (void)getVerificationCodeWithPhone:(NSString *)phoneNumber result:(SMSFinishedResultHandler)result
//{
//    [self.view endEditing:YES];
//
//    NSString *theString = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([WWPublicMethod isNumberString:theString] == NO) { // 不是电话号码
//        [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"phoneNumError", nil) isSuccess:NO];
//
//        if (result) {
//            result(NO);
//        }
//        return;
//    }
//    [_kHUDManager showActivityInView:nil withTitle:NSLocalizedString(@"obtaining", nil)];
//
//    RequestSence *sence = [[RequestSence alloc] init];
//    sence.pathURL = @"phonecode";
//
//    NSMutableDictionary *parDic=[NSMutableDictionary dictionaryWithDictionary:[MyMD5 updataDic:phoneNumber]];
//    [parDic setObject:@"lpwd" forKey:@"type"];
//    [parDic setObject:self.zone_number forKey:@"zone_number"];
//
//    sence.params = parDic;
//
//    sence.successBlock = ^(id obj) {
//        [_kHUDManager showSuccessInView:nil withTitle:[obj objectForKey:@"msg"] hideAfter:_kHUDDefaultHideTime onHide:nil];
//        if (result) {
//            result(YES);
//        }
//    };
//    sence.errorBlock = ^(NSError *error){
//        id obj = error.userInfo;
//        [_kHUDManager showMsgInView:nil withTitle:[obj objectForKey:@"msg"] isSuccess:NO];
//    };
//    [sence sendRequest];
//
//}
//- (void)action_getVers
//{
//    [self getVerificationCodeWithPhone:self.phoneNum result:^(BOOL success) {
//        if (success) {
//            //开始获取验证码，并显示倒计时，在cell内进行
//            self.sendCode = @"startSendCode";
//            [self.tableView reloadData];
//        }
//    }];
//}

#pragma mark - 提交之前先检查验证码
- (void)firstChenckYanZhengMa
{
//    if ([self checkWithUName:self.phoneNum andYanzheng:self.codeNum andPassword:self.password] == NO) {
//        return;
//    }
//
//    RequestSence *sence = [[RequestSence alloc] init];
//    sence.pathURL = @"phonecode/check";
//    sence.params = [NSMutableDictionary dictionaryWithDictionary:@{
//                                                                   @"phone":self.phoneNum,
//                                                                   @"code" :self.codeNum,
//                                                                   @"type" :@"lpwd",
//                                                                   @"zone_number" :self.zone_number,
//                                                                   }];
//    sence.successBlock = ^(id obj) {
//        [_kHUDManager showSuccessInView:nil withTitle:[obj objectForKey:@"msg"] hideAfter:_kHUDDefaultHideTime onHide:nil];
//
//        NSDictionary *dicObj=(NSDictionary*)[obj objectForKey:@"data"];
//
//        self.token=[NSString stringWithFormat:@"%@",[dicObj objectForKey:@"token"]];
//        [self resetPasswordWithUName:self.phoneNum pwd:self.password];
//
//    };
//    sence.errorBlock = ^(NSError *error){
//        NSString *msg=[error.userInfo objectForKey:@"msg"];
//        [_kHUDManager showMsgInView:nil withTitle:msg isSuccess:YES];
//    };
//
//    [sence sendRequest];
//
}
#pragma mark - 输入检测
- (BOOL)checkWithUName:(NSString *)uname andYanzheng:(NSString *)code andPassword:(NSString*)password
{
    if ([WWPublicMethod isStringEmptyText:uname] == NO) {
        [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"phoneNumError", nil) isSuccess:NO];
        
        return NO;
    }
    
    if ([WWPublicMethod isStringEmptyText:code] == NO) {
        [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"fillCode", nil) isSuccess:NO];
        return NO;
    }
    
    if ([WWPublicMethod isStringEmptyText:password] == NO || password.length < 6) { // 密码要求6位
        [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"keyLastSix", nil) isSuccess:NO];
        return NO;
    }
    
    return YES;
}



#pragma mark - 重置密码
- (void)resetPasswordWithUName:(NSString *)uname pwd:(NSString *)upwd
{
    [_kHUDManager showActivityInView:nil withTitle:NSLocalizedString(@"submission", nil)];
//    self.resetSence.phone = uname;
//    self.resetSence.token = self.token;
//    self.resetSence.password = upwd;
//    self.resetSence.zone_number = self.zone_number;
//
//    [self.resetSence sendRequest];
}

//- (ResetPwdSence *)resetSence
//{
//    if (!_resetSence) {
//        _resetSence = [[ResetPwdSence alloc] init];
//        __unsafe_unretained typeof(self) weak_self = self;
//        _resetSence.successBlock = ^(id obj) {
//            [weak_self successedToReset:obj];
//        };
//        _resetSence.errorBlock = ^(NSError *error) {
//            [weak_self errorToReset:error];
//        };
//    }
//    return _resetSence;
//}
//- (void)successedToReset:(id)obj
//{
//    // 记录登录帐号
//    _kUserModel.loginAcount = self.phoneNum;
//    [_kHUDManager showMsgInView:nil withTitle:[obj objectForKey:@"msg"] isSuccess:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:YES];
//    });
//}
//- (void)errorToReset:(NSError *)error
//{
//    NSString *msg = [error.userInfo objectForKey:@"msg"];
//    if (msg) {
//        [_kHUDManager showMsgInView:nil withTitle:msg isSuccess:NO];
//    } else {
//        [_kHUDManager showFailedInView:nil withTitle:NSLocalizedString(@"requestFailed", nil) hideAfter:_kHUDDefaultHideTime onHide:nil];
//    }
//}


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
