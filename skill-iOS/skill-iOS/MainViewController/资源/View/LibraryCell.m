//
//  LibraryCell.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/2.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "LibraryCell.h"
#import "LoginViewController.h"

@interface LibraryCell()

{
    __block UILabel *titleL;
    __block UILabel *describL;
    __block UILabel *introduceL;
    __block UILabel *timeLabel;
    
    __block UIButton *supportBtn;
    __block UILabel *supportL;
    __block UIButton *collectBtn;
}

@end

@implementation LibraryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    WK(weakSelf);
    
    //创建标题label
    
    titleL = [[UILabel alloc] init];
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = color_0f4068;
    titleL.numberOfLines = 0;
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(weakSelf.mas_top).offset(7*HEIGHT_SCALE);
        make.left.mas_equalTo(weakSelf.mas_left).offset(8*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(kWindowWidth - 12*WIDTH_SCALE, 20*HEIGHT_SCALE));
    }];
    
    //创建描述label
    describL = [[UILabel alloc] init];
    describL.font = [UIFont systemFontOfSize:12];
    describL.textColor = color_7892a5;
    describL.adjustsFontSizeToFitWidth = YES;
    describL.numberOfLines = 0;
    describL.alpha = 1.f;
    [self addSubview:describL];
    [describL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(titleL.mas_bottom).offset(4*HEIGHT_SCALE);
        make.left.mas_equalTo(weakSelf.mas_left).offset(10*WIDTH_SCALE);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-14*WIDTH_SCALE);
        make.height.mas_equalTo(40*HEIGHT_SCALE);
    }];
    
    //创建推荐Label
    introduceL = [[UILabel alloc] init];
    introduceL.font = [UIFont systemFontOfSize:10];
    introduceL.textColor = color_7892a5;
    [self addSubview:introduceL];
    [introduceL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-6*HEIGHT_SCALE);
        make.left.mas_equalTo(weakSelf.mas_left).offset(8*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(80*WIDTH_SCALE, 25*HEIGHT_SCALE));
    }];
    
    //创建时间Label
    timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor = color_7892a5;
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.numberOfLines = 0;
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.alpha = 1.f;
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(introduceL.mas_centerY);
        make.left.mas_equalTo(introduceL.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(100*WIDTH_SCALE, 25*HEIGHT_SCALE));
    }];

    //创建收藏btn
    collectBtn = [[UIButton alloc] init];
    collectBtn.backgroundColor = [UIColor whiteColor];
    [collectBtn setImage:[UIImage imageNamed:@"library-non-collect"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"library-collect"] forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(clickCollection) forControlEvents:UIControlEventTouchUpInside];
    collectBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    collectBtn.alpha = 1.f;
    [self addSubview:collectBtn];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(timeLabel.mas_centerY);
        make.right.mas_equalTo(weakSelf.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(50*WIDTH_SCALE, 25*HEIGHT_SCALE));
    }];
    
    //创建点赞label
    supportL = [[UILabel alloc] init];
    supportL.font = [UIFont systemFontOfSize:13*WIDTH_SCALE];
    supportL.textColor = color_7892a5;
    supportL.adjustsFontSizeToFitWidth = YES;
    supportL.numberOfLines = 0;
    supportL.alpha = 1.f;
    [self addSubview:supportL];
    [supportL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(collectBtn.mas_centerY);
        make.right.mas_equalTo(collectBtn.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(20*WIDTH_SCALE, 25*HEIGHT_SCALE));
    }];
    
    //创建点赞btn
    supportBtn = [[UIButton alloc] init];
    supportBtn.alpha = 1.f;
    supportBtn.backgroundColor = [UIColor whiteColor];
    [supportBtn setImage:[UIImage imageNamed:@"library-non-support"] forState:UIControlStateNormal];
    [supportBtn setImage:[UIImage imageNamed:@"library-support"] forState:UIControlStateSelected];
    [supportBtn addTarget:self action:@selector(clickSupport) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:supportBtn];
    [supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(supportL.mas_centerY);
        make.right.mas_equalTo(supportL.mas_left).offset(-5*WIDTH_SCALE);
        make.size.mas_equalTo(CGSizeMake(30*HEIGHT_SCALE, 25*HEIGHT_SCALE));
    }];
}

/**
 点击收藏按钮触发方法
 */
-(void)clickCollection{
    
    //如果当前用户的token为空,则说明未登录,提示去登录
    if (![UserTool userModel].token) {
        
        [PTTShowAlertView showAlertViewWithTitle:@"提示" message:@"请登录后对文档点赞,去登录?" cancleBtnTitle:nil cancelAction:nil sureBtnTitle:@"确定" sureAction:nil];
        return;
    }
    
    //如果收藏按钮已经是选择状态 则发送取消收藏的请求
    //如果是为选择的状态  则发送收藏请求
    
    //创建请求参数
    NSString *strOfUrl = [NSString stringWithFormat:@"%@%lu",API_LibraryCollect,self.model.libraryId];
    NSDictionary *paramentsDic = [NSDictionary dictionaryWithObjectsAndKeys:[UserTool userModel].token,@"token", nil];
    
    if (collectBtn.selected) {
        
        //取消收藏
        [HttpService sendDeleteHttpRequestWithUrl:strOfUrl paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {

            if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
                
                if ([[jsonDic objectForKey:@"message"] isEqualToString:@"success"]) {
                    
                    //更新界面
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        collectBtn.selected = NO;
                    });
                }else{
                    
                    [ShowMessageTipUtil showTipLabelWithMessage:[jsonDic objectForKey:@"message"] spacingWithTop:kWindowHeight/2 stayTime:2];
                }
            }
        }];
        
    }else{
        
        //发送收藏请求
        [HttpService sendPostHttpRequestWithUrl:strOfUrl paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {

            if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
                
                if ([[jsonDic objectForKey:@"message"] isEqualToString:@"success"]) {
                    
                    //更新界面
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        collectBtn.selected = YES;
                    });
                }else{
                    
                     [ShowMessageTipUtil showTipLabelWithMessage:[jsonDic objectForKey:@"message"] spacingWithTop:kWindowHeight/2 stayTime:2];
                }
            }
        }];
    }
}

/**
 点击点赞按钮触发方法
 */
-(void)clickSupport{

    //如果当前用户的token为空,则说明未登录,提示去登录
    if (![UserTool userModel].token) {
        
        [PTTShowAlertView showAlertViewWithTitle:@"提示" message:@"请登录后对文档点赞,去登录?" cancleBtnTitle:nil cancelAction:nil sureBtnTitle:@"确定" sureAction:nil];
        return;
    }
    
    //如果点赞按钮已经是选择状态 则发送取消点赞的请求
    //如果是为选择的状态  则发送点赞请求
    
    //创建请求参数
    NSString *strOfUrl = [NSString stringWithFormat:@"%@%lu",API_LibraryLike,self.model.libraryId];
    NSDictionary *paramentsDic = [NSDictionary dictionaryWithObjectsAndKeys:[UserTool userModel].token,@"token", nil];
    
    //当点击一次后在网络请求返回之前  禁止点选
    WK(weakSelf);
    self.userInteractionEnabled = NO;
    if (supportBtn.selected) {
        
        [HttpService sendDeleteHttpRequestWithUrl:strOfUrl paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {
            if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
                
                if ([[jsonDic objectForKey:@"message"] isEqualToString:@"success"]) {
                    
                    //更新界面
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        supportBtn.selected = NO;
                        supportL.textColor = color_7892a5;
                        int32_t numberOfSupport = [supportL.text intValue];
                        numberOfSupport --;
                        supportL.text = [NSString stringWithFormat:@"%d",numberOfSupport];
                        weakSelf.userInteractionEnabled = YES;
                    });
                }else{
                    
                    weakSelf.userInteractionEnabled = YES;
                     [ShowMessageTipUtil showTipLabelWithMessage:[jsonDic objectForKey:@"message"] spacingWithTop:kWindowHeight/2 stayTime:2];
                }
            }
        } failBlock:^{
            
            weakSelf.userInteractionEnabled = YES;
        }];
    }else{
        
        [HttpService sendPostHttpRequestWithUrl:strOfUrl paraments:paramentsDic successBlock:^(NSDictionary *jsonDic) {
            
                if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
            
                    if ([[jsonDic objectForKey:@"message"] isEqualToString:@"success"]) {
            
                        //更新界面
                        dispatch_async(dispatch_get_main_queue(), ^{
            
                            supportBtn.selected = YES;
                            supportL.textColor = color_fdb92c;
                            int32_t numberOfSupport = [supportL.text intValue];
                            numberOfSupport ++;
                            supportL.text = [NSString stringWithFormat:@"%d",numberOfSupport];
                            weakSelf.userInteractionEnabled = YES;
                         });
                    }else{
                        
                        [ShowMessageTipUtil showTipLabelWithMessage:[jsonDic objectForKey:@"message"] spacingWithTop:kWindowHeight/2 stayTime:2];
                        weakSelf.userInteractionEnabled = YES;
                    }
                }
           } failBlock:^{
               
               weakSelf.userInteractionEnabled = YES;
        }];
    }
}

-(void)setModel:(LibraryModel *)model{
    
    _model = model;
    
    titleL.text = model.skillName;
    
    //设置描述文本的时候  需要添加间距
    NSMutableAttributedString *describeStr = [[NSMutableAttributedString alloc] initWithString:model.introduce];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [describeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, describeStr.length)];
    if (describeStr.length > 42) {
        describeStr = [describeStr attributedSubstringFromRange:NSMakeRange(0, 42)];
        [describeStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"..."]];
    }
    describL.attributedText = describeStr;
    
    //设置创建时间label
    timeLabel.text = [PTTDateKit dateLineFormatFrom1970WithTimeInterval:model.createAt];
    supportL.text = [NSString stringWithFormat:@"%d",model.like];
    
    //更新 点赞按钮和收藏按钮的显示图片
    if (model.ifLike) {
        
        supportBtn.selected = YES;
        supportL.textColor = color_fdb92c;
    }else{
        
        supportBtn.selected = NO;
        supportL.textColor = color_7892a5;
    }
    
    if (model.ifCollection) {
        
        collectBtn.selected = YES;;
    }else{
        
        collectBtn.selected = NO;
    }
    
    
    //设置推荐Label 文字参数
    NSString *originalStr = nil;
    if (model.authorName) {
        
        originalStr = [NSString stringWithFormat:@"由 %@ 推荐",model.authorName];
        
        //截取推荐人名的前6位
        if (model.authorName.length > 6) {
            
            originalStr = [NSString stringWithFormat:@"由 %@... 推荐",[model.authorName substringToIndex:6]];
        }
    }else{
        
        originalStr = [NSString stringWithFormat:@"由 推荐"];
    }
    
    NSMutableAttributedString *describeString = [[NSMutableAttributedString alloc] initWithString:originalStr];
    //如果推荐者字段有值的话,则对这个字段进行富文本处理
    if (model.authorName) {
        
        //创建查找推荐者名字字段
        NSString *searchName = nil;
        if (model.authorName.length > 6) {
            
            searchName = [NSString stringWithFormat:@"%@...",[model.authorName substringToIndex:6]];
        }else{
            
            searchName = model.authorName;
        }
        
        NSRange range = [originalStr rangeOfString:searchName];
        
        [describeString addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"Helvetica-Bold" size:12*WIDTH_SCALE]
                               range:range];
        [describeString addAttribute:NSForegroundColorAttributeName value:color_265074 range:range];
    }

    //设置推荐人字段宽度

    introduceL.text = [NSString stringWithFormat:@" %@ ",originalStr];
    introduceL.attributedText = describeString;
    
    CGSize fitSize = [introduceL sizeThatFits:CGSizeZero];
    [introduceL sizeToFit];

    [introduceL mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(fitSize);
    }];
}

@end
