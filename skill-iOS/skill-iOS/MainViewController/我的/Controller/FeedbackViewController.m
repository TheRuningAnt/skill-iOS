//
//  FeedbackViewController.m
//  skill-iOS
//
//  Created by ptteng on 16/11/4.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SuggestionTextView.h"

@interface FeedbackViewController ()<UITextViewDelegate>


/**
 *  自定义意见框
 */
@property(strong ,nonatomic) SuggestionTextView* feedTextView;
/**
 *  显示字数的label
 */
@property(strong ,nonatomic) UILabel * numLabel;
/**
 *  提交意见按钮
 */
@property(strong ,nonatomic) UIButton *upDataButton;
/**
 *  存放 意见框数据
 */
@property(nonatomic ,copy) NSString *str;

@end

@implementation FeedbackViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    //启动友盟页面统计
    [MobClick beginLogPageView:@"反馈模块"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationUI];
    [self addSubViews];
    [self initViewLayout];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //退出友盟页面统计
    [MobClick endLogPageView:@"反馈模块"];
}


//自定义导航栏
-(void)setupNavigationUI{
    
    self.view.backgroundColor = color_e8efed;
    //设置导航栏标题
    NSDictionary *dict = @{NSForegroundColorAttributeName:color_0f4068,
                           NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                           };
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"沟通交流";
    
    //导航栏返回按钮
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Utils-Kit-back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 30*HEIGHT_SCALE, 30*HEIGHT_SCALE) ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *submitButton = [[UIButton alloc] init];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.frame = CGRectMake(0, 0, 40, 40);
    submitButton.font = [UIFont systemFontOfSize:14];
    [submitButton setTitleColor:color_24c9a7 forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(onclickSubmitButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    
    self.navigationItem.leftBarButtonItems = @[item1];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    
}
#pragma - -- - -- --- -- 页面布局部分 - - - -  - -
-(void)addSubViews{

    _feedTextView= [[SuggestionTextView alloc]init];
    _feedTextView.backgroundColor = color_ffffff;
    _feedTextView.delegate = self;
    _feedTextView.font = [UIFont systemFontOfSize:14.f];
    _feedTextView.textColor = [UIColor blackColor];
    _feedTextView.textAlignment = NSTextAlignmentLeft;
    _feedTextView.GZplaceholder = @"请输入您对我们的意见";
    [self.view addSubview:_feedTextView];
    
    _numLabel= [[UILabel alloc]init];
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.text = @"0/150";
    _numLabel.backgroundColor = color_ffffff;
    _numLabel.textColor = [UIColor colorWithHexString:@"999999"];
    _numLabel.font = [UIFont systemFontOfSize:(12*HEIGHT_SCALE)];
    [self.view addSubview:_numLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reKeyBoard)];
    [self.view addGestureRecognizer:tap];
}
-(void)initViewLayout{
    WK(weakself);
    [self.feedTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.view.mas_left);
        make.right.mas_equalTo(weakself.view.mas_right);
        make.centerX.equalTo(weakself.view);
        make.top.mas_equalTo(20);
        make.height.equalTo(@150);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(62*HEIGHT_SCALE, 12*HEIGHT_SCALE));
        make.bottom.mas_equalTo(weakself.feedTextView.mas_bottom).offset(-10);
        make.right.mas_equalTo(weakself.feedTextView.mas_right).offset(-10);
    }];

}
#pragma  - - -  - -点击方法  - -  - - - -
//返回上个页面
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark textField的字数限制
//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger wordCount = textView.text.length;
    self.numLabel.text = [NSString stringWithFormat:@"%ld/150",  (long)wordCount];
}
#pragma mark 超过150字不能输入
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    //判断加上输入的字符，是否超过界限
    self.str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (_str.length > 150)
    {
        textView.text = [textView.text substringToIndex:150];
        self.numLabel.text = [NSString stringWithFormat:@"%d/%d",150,150];
        return NO;
    }
    self.numLabel.text = [NSString stringWithFormat:@"%ld/%d",_str.length,150];
    return YES;
}
//提交方法
-(void)onclickSubmitButtonMethod{
    NSLog(@"提交");

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//实现方法//取消textView ,textField的第一响应者即可
- (void)reKeyBoard
{
    [_feedTextView resignFirstResponder];
    
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
