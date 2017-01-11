//
//  MessageCell.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/4.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "MessageCell.h"
#import "PTTStringFromHtml.h"

@interface MessageCell()

{
    //消息图片
   __block UIImageView *messageTip;
    //消息下方的时间label
   __block UILabel *timeLabeL;
    //内容label
   __block UILabel *contentL;
}

@end

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

-(void)setupUI{
    
    WK(weakSelf);
    
    //创建消息展示图片
    messageTip = [[UIImageView alloc] init];
    [self addSubview:messageTip];
    [messageTip mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(weakSelf.mas_top).offset(15);
        make.left.mas_equalTo(weakSelf.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 17));
    }];
    
    //创建消息下方的时间提示戳
    timeLabeL = [[UILabel alloc] init];
    timeLabeL.backgroundColor = [UIColor whiteColor];
    timeLabeL.font = [UIFont systemFontOfSize:10];
    timeLabeL.text = @"--";
    timeLabeL.textColor = color_7892a5;
    timeLabeL.backgroundColor = [UIColor whiteColor];
    timeLabeL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabeL];
    [timeLabeL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(messageTip.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(34, 15));
        make.centerX.mas_equalTo(messageTip.mas_centerX);
    }];
    
    contentL = [[UILabel alloc] init];
    contentL.backgroundColor = [UIColor whiteColor];
    contentL.font = [UIFont systemFontOfSize:14];
    contentL.text = @"--";
    contentL.numberOfLines = 2;
    contentL.textColor = color_0f4068;
    contentL.frame = CGRectMake(35 + 10, 10, kWindowWidth - 35 - 20, 40);
    [self addSubview:contentL];
}

-(void)setModel:(MessageModel *)model{
    
    if(model.unread){
        
        messageTip.image = [UIImage imageNamed:@"my-message-non-read"];
    }else{
        
        messageTip.image = [UIImage imageNamed:@"my-message-read"];
    }
    
    NSString *timeStr = [PTTDateKit dateTimeFrom1970WithTimeInterval:model.updateAt];
    timeLabeL.text = [timeStr substringWithRange:NSMakeRange(timeStr.length - 5, 5)];
    contentL .text = [PTTStringFromHtml stringFromHtml:model.content];
    //设置label对齐方式
    [contentL sizeToFit];
    
    if (contentL.frame.size.height < 20) {
        
        contentL.frame = CGRectMake(35 + 10, self.frame.size.height/2 - 20, kWindowWidth - 35 - 20, 40);
    }else{
        contentL.frame = CGRectMake(35 + 10, 10, kWindowWidth - 35 - 20, 40);
    }
    NSLog(@"%f  %f",contentL.frame.size.width,contentL.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
