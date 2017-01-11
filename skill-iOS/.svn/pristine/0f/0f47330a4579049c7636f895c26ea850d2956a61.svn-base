//
//  TaskDetailTipView.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/25.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "TaskDetailTipView.h"

@implementation TaskDetailTipView

-(void)setTitle:(NSString *)title{
    
    self.backgroundColor = [UIColor whiteColor];
    
    //创建标题装饰Tip
    UILabel *tip = [[UILabel alloc] init];
    tip.backgroundColor = color_24c9a7;
    tip.frame = CGRectMake(10, (self.height - 23*HEIGHT_SCALE)/2, 4, 23*HEIGHT_SCALE);
    [self addSubview:tip];
    
    //标题Label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(22, 0, 100*WIDTH_SCALE, self.frame.size.height);
    titleLabel.textColor = color_0f4068;
    titleLabel.font = [UIFont systemFontOfSize:16*WIDTH_SCALE];
    titleLabel.text = title;
    [self addSubview:titleLabel];
    
    if (!self.hideLine) {
        //下方分割线
        UILabel *lineOfDown = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
        lineOfDown.backgroundColor = color_dfeaff;
        [self addSubview:lineOfDown];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
