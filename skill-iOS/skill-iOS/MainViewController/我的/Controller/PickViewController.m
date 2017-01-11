//
//  ChangeBirthdayAndCityController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/7.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PickViewController.h"
#import "PersonController.h"
#import "PTTDateKit.h"
#import "PTTPickView.h"

@interface PickViewController()

/**
  创建提示文本
 */
@property (nonatomic,strong) __block UILabel *tipLabel;

/**
 选择出生日期控件
 */
@property (nonatomic,strong) PTTPickView *timePickView;
/**
 选择地址控件
 */
@property (nonatomic,strong) PTTPickView *addressPickView;
/**
   创建保存用户生日的时间戳
 */
@property (nonatomic,assign) __block NSInteger birthdayTimeStamp;
/**
   创建保存当前用户选择的省份编号的变量
 */
@property (nonatomic,strong) __block NSString *provinceNumber;
/**
 创建保存当前用户选择的城市编号的变量
 */
@property (nonatomic,strong) __block NSString *cityNumber;

@end

@implementation PickViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setShadowImage:nil];
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"选择地址或出生日期模块"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //退出友盟页面统计
    [MobClick endLogPageView:@"选择地址或出生日期模块"];
}

-(void)setUpUI{
    
    self.view.backgroundColor = color_e8efed;
    
    //设置导航栏标题
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = self.controlTitle;
    
    //导航栏返回按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItems = @[item1];
    
    //导航栏右边的按钮
    UIButton *rigthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rigthBtn.frame = CGRectMake(0,0, 50*HEIGHT_SCALE, 50*HEIGHT_SCALE) ;
    [rigthBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rigthBtn setTitleColor:color_24c8a8 forState:UIControlStateNormal];
    [rigthBtn setTitleColor:color_ffffff forState:UIControlStateHighlighted];
    rigthBtn.titleLabel.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
    [rigthBtn addTarget:self action:@selector(clikcSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rigthBtn];
    self.navigationItem.rightBarButtonItems = @[rightBarItem];
    
    //添加输入提示按钮
    [self.view addSubview:self.tipLabel];
    
    //添加时间选择器到页面上  由于创建选择器耗时略长,所以放到子线程来做
    [self addPickView];
}

#pragma mark 按钮触发方法

//返回上个页面
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 发起网络请求
/**
 点击保存按钮的时候发起更新个人信息的网络请求
 如果修改成功则返回上个页面,如果修改失败则停留在本页面
 */
-(void)clikcSaveBtn{
    
    //提取数组model 里的数据添加到修改个人信息的参数Dic里
    
    NSMutableDictionary *paramentsDic = [NSMutableDictionary dictionary];
    [paramentsDic setObject:self.model.thumb forKey:@"thumb"];
    [paramentsDic setObject:self.model.nick forKey:@"nick"];
    [paramentsDic setObject:[NSString stringWithFormat:@"%lu",self.model.birthday] forKey:@"birthday"];
    [paramentsDic setObject:self.model.qq forKey:@"qq"];
    [paramentsDic setObject:self.model.school forKey:@"school"];
    [paramentsDic setObject:self.model.sign forKey:@"sign"];
    [paramentsDic setObject:[UserTool userModel].token forKey:@"token"];
    
    //更新请求参数里该次修改的数据
    if ([self.type isEqualToString:@"birthday"]) {
        
        if (_birthdayTimeStamp == 0) {
            
            [ShowMessageTipUtil showTipLabelWithMessage:@"请选择出生日期"];
            return;
        }else{
            
            [paramentsDic setObject:[NSString stringWithFormat:@"%lu",_birthdayTimeStamp] forKey:self.type];
        }
    }
    
    if ([self.type isEqualToString:@"city"] && self.provinceNumber && self.cityNumber) {
        
        [paramentsDic setObject:self.provinceNumber forKey:@"province"];
        [paramentsDic setObject:self.cityNumber forKey:@"city"];
    }

    //发送网络请求
    WK(weakSelf);
    [HttpService sendPutHttpRequestWithUrl:API_ChangePersonInfo paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {
        
        if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
            
            if ([[jsonDic objectForKey:@"message"] isEqualToString:@"success"]) {
                
                [ShowMessageTipUtil showTipLabelWithMessage:@"修改成功" spacingWithTop:kWindowHeight/2 stayTime:2];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                
                [ShowMessageTipUtil showTipLabelWithMessage:[jsonDic objectForKey:@"message"]spacingWithTop:kWindowHeight/2 stayTime:2];
            }
        }
    }];
}

#pragma mark 添加选择器到页面上

-(void)addPickView{
    
    WK(weakSelf);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if([weakSelf.type isEqualToString:@"birthday"]){
            
            if (weakSelf.timePickView) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.view addSubview:weakSelf.timePickView];
                    if (weakSelf.model.birthday == 0) {
                        
                        [weakSelf.timePickView selectTimeWithYear:1990 month:1 day:1];
                    }else{
                        _birthdayTimeStamp = weakSelf.model.birthday;
                        [weakSelf.timePickView selectTimeWithTimeStamp:weakSelf.model.birthday];
                    }
                });
            }
        }
        
        if ([weakSelf.type isEqualToString:@"city"]) {
            
            if (weakSelf.addressPickView) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.view addSubview:weakSelf.addressPickView];
                    [weakSelf.addressPickView selectPlaceWithProvinceId:weakSelf.model.province andCityId:weakSelf.model.city];
                });
            }
        }
    });
}


#pragma mark 懒加载
-(UILabel *)tipLabel{
    if(!_tipLabel){
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kWindowWidth, 40)];
        _tipLabel.backgroundColor = [UIColor whiteColor];
        _tipLabel.textColor = color_0f4068;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:18*WIDTH_SCALE];
        _tipLabel.adjustsFontSizeToFitWidth = YES;
        _tipLabel.text = self.tipString;
        if([_type isEqualToString:@"birthday"] && _model.birthday == 0){
            
            _tipLabel.text = self.tipString;
        }
    }
    
    return _tipLabel;
}

-(PTTPickView *)timePickView{
    
    if (!_timePickView) {
        
        WK(weakSelf);
        _timePickView = [[PTTPickView alloc] createTimePickerWithFrame:CGRectMake(0, 100*HEIGHT_SCALE, kWindowWidth, 200*HEIGHT_SCALE)
                                                            rowHeight:40*HEIGHT_SCALE
                                                             fontSize:15*HEIGHT_SCALE
                                                            fontColor:color_0f4068
                                                         selectAction:^(UIPickerView *timePickView, NSInteger compoent, NSInteger row, NSString *timeStr, NSInteger timeInterval) {
                                                             
                                                             weakSelf.tipLabel.text = [NSString stringWithFormat:@"%lu",[PTTDateKit getAgeOfTimeStamp:timeInterval]];
                                                             _birthdayTimeStamp = timeInterval;
                                                         }];
    }
    return _timePickView;
}

-(PTTPickView *)addressPickView{
    
    if (!_addressPickView) {
        
        WK(weakSelf);
        
        _addressPickView = [[PTTPickView alloc] createPTTPlacePickerWithFrame:CGRectMake(0, 100*HEIGHT_SCALE, kWindowWidth, 200*HEIGHT_SCALE)
                                                                    rowHeight:40*HEIGHT_SCALE
                                                                     fontSize:15*HEIGHT_SCALE
                                                                    fontColor:color_0f4068
                                                                 selectAction:^(UIPickerView *pickView, NSString *currentProvince, NSString *proviceNumber, NSString *currentCity, NSString *cityNumber) {
                                                                     
                                                                     weakSelf.tipLabel.text = currentCity;
                                                                     weakSelf.provinceNumber = proviceNumber;
                                                                     weakSelf.cityNumber = cityNumber;
                                                                 }];
    }
    return _addressPickView;
}

@end
