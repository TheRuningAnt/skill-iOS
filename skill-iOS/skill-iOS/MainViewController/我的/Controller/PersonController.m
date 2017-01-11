//
//  PersonController.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/5.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PersonController.h"
#import "InputController.h"
#import "PTTPickView.h"
#import "PickViewController.h"
#import "UIImageView+PTT.h"


@implementation PersonInfoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        _uid = [value integerValue];
    }
}

@end

/**
   个人信息controller
 */
@interface PersonController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *personInfoTableView;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) PersonInfoModel *userInfomodel;

//选择照片进行拍摄
@property (nonatomic,strong) UIActionSheet *actionSheet;
//头像UIImageView
@property (nonatomic,strong) UIImageView *headImageV;

@end

@implementation PersonController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setShadowImage:nil];
    
    //每次进来页面的时候都更新数据
    [self loadData];
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"个人信息模块"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //退出友盟页面统计
    [MobClick endLogPageView:@"个人信息模块"];
}


-(void)setUpUI{
    
    self.view.backgroundColor = color_e8efed;
    
    //设置导航栏标题
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"个人信息";
    
    //导航栏返回按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItems = @[item1];
    
    //添加展示个人信息列表到页面上
    [self.view addSubview:self.personInfoTableView];
}

#pragma mark 加载网络请求
-(void)loadData{
    
    KCheckNetWorkAndRetuen(^{})
    
    WK(weakSelf);
    
    //创建请求参数
    NSString *uidStr = nil;
    NSString *token = nil;
    
    if (self.visitor) {
        
        if (self.visitorId > 0) {
            
            uidStr = [NSString stringWithFormat:@"%lu",self.visitorId];
            token = nil;
        }
    }else{
        
        uidStr = [NSString stringWithFormat:@"%lu",[UserTool userId]];
        token = [UserTool userModel].token;
    }
    
    NSDictionary *paramentsDic = [NSDictionary dictionaryWithObjectsAndKeys:uidStr,@"uids",token,@"token", nil];
    
    [HttpService sendGetHttpRequestWithUrl:API_PersonBaseInfo paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {
       
        if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
            
            NSArray *arrayOfUser = [jsonDic objectForKey:@"users"];
            if (arrayOfUser && arrayOfUser.count != 0) {
                
                NSDictionary *userInfoDic = [arrayOfUser firstObject];
                
                [weakSelf.userInfomodel setValuesForKeysWithDictionary:userInfoDic];
            }
        }
        
        [weakSelf.personInfoTableView reloadData];
    }];
}

//上传图像至服务器
-(void)putImageToService:(UIImage*)image{
    
    //创建请求参数
    NSDictionary *paramentsDic = [NSDictionary dictionaryWithObjectsAndKeys:[UserTool userModel].token,@"token",nil];
    
    WK(weakSelf);
    [HttpService sendPostImageHttpRequestWithUrl:API_PutImage paraments:paramentsDic image:image successBlock:^(NSDictionary *jsonDic) {
       
        if([[jsonDic objectForKey:@"message"] isEqualToString:@"success"]){
            
            NSDictionary *dataDic= [jsonDic objectForKey:@"data"];
            if (dataDic && dataDic.count != 0) {
                
                //发送修改个人信息请求
                NSString *serviceImageUrl = [dataDic objectForKey:@"url"];
                [weakSelf modifyPersonImageWithUrlString:serviceImageUrl];
            }            
        }else{
            
            [ShowMessageTipUtil showTipLabelWithMessage:@"图片上传失败"];
        }
    }];
}

//上传完图片并更新个人信息
-(void)modifyPersonImageWithUrlString:(NSString *)urlStr{
    
    //提取数组model 里的数据添加到修改个人信息的参数Dic里
    
    NSMutableDictionary *paramentsDic = [NSMutableDictionary dictionary];
    [paramentsDic setObject:urlStr forKey:@"thumb"];
    [paramentsDic setObject:self.userInfomodel.nick forKey:@"nick"];
    [paramentsDic setObject:[NSString stringWithFormat:@"%lu",self.userInfomodel.birthday] forKey:@"birthday"];
    [paramentsDic setObject:self.userInfomodel.qq forKey:@"qq"];
    [paramentsDic setObject:self.userInfomodel.school forKey:@"school"];
    [paramentsDic setObject:[NSString stringWithFormat:@"%lu",self.userInfomodel.city] forKey:@"city"];
    [paramentsDic setObject:[NSString stringWithFormat:@"%lu",self.userInfomodel.province] forKey:@"province"];    [paramentsDic setObject:self.userInfomodel.sign forKey:@"sign"];
    [paramentsDic setObject:[UserTool userModel].token forKey:@"token"];
    
    WK(weakSelf);
    //发送网络请求
    [HttpService sendPutHttpRequestWithUrl:API_ChangePersonInfo paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {
        
        if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
            
            if ([[jsonDic objectForKey:@"message"] isEqualToString:@"success"]) {
                
                [weakSelf loadData];
                [ShowMessageTipUtil showTipLabelWithMessage:@"图片修改成功"];
            }else{
                
                [ShowMessageTipUtil showTipLabelWithMessage:[jsonDic objectForKey:@"message"]spacingWithTop:kWindowHeight/2 stayTime:2];
            }
        }
    }];
}

#pragma mark tableView 代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //如果不是访客模式 则显示右边的指示标志
    if (!self.visitor) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor = color_0f4068;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.titles[indexPath.row];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.textColor = color_7892a5;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    WK(weakSelf);
    
    if (indexPath.row == 0) {
        
            self.headImageV = [[UIImageView alloc] initWithframe:CGRectMake(0, 0, 60*HEIGHT_SCALE, 60*HEIGHT_SCALE) andImage:@"person-placeholder-image" contendMode:PTT_ImageView_Image_Contend_Mode_Fill withAction:^(id sender) {
           
                //如果是访客模式  不执行操作
                if (self.visitor) {
                    return ;
                }
                
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择",nil];
            }else{
                self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
            }
            
            self.actionSheet.tag = 1000;
            [self.actionSheet showInView:self.view];
        }];
        self.headImageV.layer.masksToBounds = YES;
        self.headImageV.layer.cornerRadius = 30*HEIGHT_SCALE;
        [cell addSubview:self.headImageV];
        [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(60*HEIGHT_SCALE, 60*HEIGHT_SCALE));
            make.top.mas_equalTo(cell.mas_top).offset(10*HEIGHT_SCALE);
            make.right.mas_equalTo(cell.mas_right).offset(-40*WIDTH_SCALE);
        }];
        
        [self.headImageV sd_setImageWithURL:[NSURL URLWithString:weakSelf.userInfomodel.thumb] placeholderImage:[UIImage imageNamed:@"person-placeholder-image"]];
    }
    
    switch (indexPath.row) {
        case 1:
            
            cell.detailTextLabel.text = weakSelf.userInfomodel.nick;
            if (weakSelf.userInfomodel.nick.length == 0) {
                cell.detailTextLabel.text = @"未设置";
            }
            break;
        case 2:
        {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",[PTTDateKit getAgeOfTimeStamp:self.userInfomodel.birthday]];
            if (self.userInfomodel.birthday == 0) {
                
                cell.detailTextLabel.text = @"未设置";
            }
        }
            break;
        case 3:
            
            cell.detailTextLabel.text = weakSelf.userInfomodel.qq;
            if (weakSelf.userInfomodel.qq.length == 0) {
                cell.detailTextLabel.text = @"未设置";
            }
            break;
        case 4:
            
            cell.detailTextLabel.text = weakSelf.userInfomodel.school;
            if (weakSelf.userInfomodel.school.length == 0) {
                cell.detailTextLabel.text = @"未设置";
            }
            break;
        case 5:
            
            cell.detailTextLabel.text = [PTTPickView pttCityOfProvinceId:self.userInfomodel.province andCityId:self.userInfomodel.city];
            if (cell.detailTextLabel.text.length == 0) {
                cell.detailTextLabel.text = @"未设置";
            }
            break;
        case 6:
            
            cell.detailTextLabel.text = weakSelf.userInfomodel.sign;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = NO;
            cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            if (weakSelf.userInfomodel.sign.length == 0) {
                cell.detailTextLabel.text = @"未设置";
            }
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 || indexPath.row == self.titles.count - 1) {
        
        return 80*HEIGHT_SCALE;
    }
    
    return 60*HEIGHT_SCALE;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    //如果是访客模式 不执行操作
    if (self.visitor) {
        return;
    }
    
    InputController *inputVC = [[InputController alloc] init];
    PickViewController *pickVC = [[PickViewController alloc] init];
    
    switch (indexPath.row) {
        case 1:
            
            inputVC.controlTitle  = @"修改昵称";
            inputVC.maxLength = 15;
            inputVC.type = @"nick";
            inputVC.tipString = @"好名字更容易让人记住你哦!";
            inputVC.userTipString = self.userInfomodel.nick;
            break;
        case 2:
        {
            pickVC.controlTitle = @"修改年龄";
            pickVC.type = @"birthday";
            pickVC.tipString = [NSString stringWithFormat:@"%lu",[PTTDateKit getAgeOfTimeStamp:self.userInfomodel.birthday]];
            pickVC.model = self.userInfomodel;
        }
            break;
        case 3:
            
            inputVC.controlTitle  = @"修改QQ";
            inputVC.tipString = @"请输入你的QQ号";
            inputVC.minLength = 4;
            inputVC.maxLength = 11;
            inputVC.type = @"qq";
            inputVC.userTipString = self.userInfomodel.qq;
            break;
        case 4:
            
            inputVC.controlTitle  = @"修改毕业院校";
            inputVC.tipString = @"请输入你的毕业院校";
            inputVC.maxLength = 20;
            inputVC.type = @"school";
            inputVC.userTipString = self.userInfomodel.school;
            break;
        case 5:
            
            pickVC.controlTitle = @"修改地址";
            pickVC.type = @"city";
            pickVC.tipString = [PTTPickView pttCityOfProvinceId:self.userInfomodel.province andCityId:self.userInfomodel.city];
            break;
        case 6:
            
            inputVC.controlTitle  = @"修改签名";
            inputVC.tipString = @"请输入新签名";
            inputVC.maxLength = 20;
            inputVC.type = @"sign";
            inputVC.userTipString = self.userInfomodel.sign;
            break;
    }
    
    if (indexPath.row != 0 && indexPath.row != 2 && indexPath.row != 5) {
        
        inputVC.model = self.userInfomodel;
        [self.navigationController pushViewController:inputVC animated:YES];
    }
    if (indexPath.row == 2 || indexPath.row == 5) {
        
        pickVC.model = self.userInfomodel;
        [self.navigationController pushViewController:pickVC animated:YES];
    }
}

#pragma mark 按钮触发方法

//返回上个页面
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 相机调用方法
- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择",nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 2) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

//获取图片并上传到服务器
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self putImageToService:image];
}



#pragma mark 懒加载
-(UITableView *)personInfoTableView{
    
    if (!_personInfoTableView) {
        
        _personInfoTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _personInfoTableView.delegate = self;
        _personInfoTableView.dataSource = self;
        _personInfoTableView.tableFooterView = [[UIView alloc] init];
        _personInfoTableView.separatorColor = color_dfeaff;
        _personInfoTableView.backgroundColor = color_e8efed;
    }
    
    return _personInfoTableView;
}

-(NSArray *)titles{
    
    if (!_titles) {
        _titles = @[@"头像",@"昵称",@"年龄",@"QQ",@"毕业院校",@"所在城市",@"签名"];
    }
    return _titles;
}

-(PersonInfoModel *)userInfomodel{
    if (!_userInfomodel) {
        _userInfomodel = [PersonInfoModel new];
    }
    return _userInfomodel;
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


