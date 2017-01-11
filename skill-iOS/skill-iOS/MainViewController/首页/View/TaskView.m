//
//  TaskView.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/25.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "TaskView.h"

@implementation TaskView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setContentArray:(NSArray *)contentArray{
    
    //使用该Label 指向最后一个Label  以便在任务详情页面使用的时候修改最后一个Label的颜色
    UILabel *lastLabel = nil;
    
    //添加显示标题的label
    for(int i = 0 ; i < contentArray.count; i ++){
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14*HEIGHT_SCALE];
        label.text = contentArray[i];
        label.numberOfLines = 0;
        label.adjustsFontSizeToFitWidth = YES;
        label.frame = CGRectMake(30*WIDTH_SCALE, 50*HEIGHT_SCALE * i, kWindowWidth - 40*WIDTH_SCALE, 50*HEIGHT_SCALE);
        
        lastLabel = label;
        
        if (i != contentArray.count - 1) {
            
            label.textColor = color_7892a5;
        }else{
            
            label.textColor = color_fdb92c;
        }
        
        [self addSubview:label];
        
        /**
         * 特殊界面使用该控件的时候设置背景颜色 需要在外层传入
         * 否则使用默认的背景颜色
         */
        if(self.titleBackgroundColor){
            
            label.backgroundColor = self.titleBackgroundColor;
        }
        else{
            
            label.backgroundColor = color_fafafa;
        }
    }
    
    //修改最后一个Label的颜色
    lastLabel.textColor = color_7892a5;
    
    //添加指示图片
    for (int i = 0 ; i < contentArray.count ; i ++){
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*WIDTH_SCALE, 50*HEIGHT_SCALE  * i, 16*WIDTH_SCALE, 50*HEIGHT_SCALE)];
        
        /**
         *  如果当前使用该View的是职业详情页面,使用下面的逻辑处理
         *  逻辑:先判断特殊情况
         *  1.当有两个数据时:
         *     第一条为圆
         *     第二条为时间标志
         *  2.当有一条数据时,只显示一个时间标志
         *
         *  3.数据大于2条:
         *    3.1 当前为第一条数据  显示上方的圆
         *    3.2 当前为倒数第二条数据 显示下方的圆
         *    3.3 当前为第最后一条数据  显示时间标志
         *    3.4 该数据肯定为中间的数据 显示中间的圆
         */
        if (self.currentView == K_JOB_DETAIL_VIEW) {
            
            //如果是职业详情页面并且数组只有两个元素 那么第一个Image应该是个圆圈
            if(contentArray.count == 2 && i == 0){
                
                imageView.image = [UIImage imageNamed:@"tip-line-cycle"];
                imageView.frame = CGRectMake(10*WIDTH_SCALE, 50*HEIGHT_SCALE - 35*HEIGHT_SCALE, 16*WIDTH_SCALE, 16*WIDTH_SCALE);
            }else if(contentArray.count == 1 && i == 0){
                
                imageView.image = [UIImage imageNamed:@"job-detail-time"];
                imageView.contentMode = UIViewContentModeCenter;
                imageView.frame = CGRectMake(10*WIDTH_SCALE, 8*HEIGHT_SCALE , 11*WIDTH_SCALE, 35*HEIGHT_SCALE);
            }else if (i == 0){
                
                imageView.image = [UIImage imageNamed:@"tip-line-up"];
                imageView.frame = CGRectMake(10*WIDTH_SCALE, 50*HEIGHT_SCALE - 35*HEIGHT_SCALE, 16*WIDTH_SCALE, 35*HEIGHT_SCALE);
            }else if (i == contentArray.count - 2){
                
                imageView.image = [UIImage imageNamed:@"tip-line-down"];
                imageView.frame = CGRectMake(10*WIDTH_SCALE, 50*HEIGHT_SCALE  * i, 16*WIDTH_SCALE, 35*HEIGHT_SCALE);
            }
            else if (i == contentArray.count - 1){
                
                imageView.image = [UIImage imageNamed:@"job-detail-time"];
                imageView.contentMode = UIViewContentModeCenter;
                imageView.frame = CGRectMake(10*WIDTH_SCALE, 50*HEIGHT_SCALE  * i + 8*HEIGHT_SCALE , 11*WIDTH_SCALE, 35*HEIGHT_SCALE);
            }else{
                imageView.image = [UIImage imageNamed:@"tip-line-mid"];
            }
        }
        
        /**
         *  如果当前使用该View的是任务详情页面,使用下面的逻辑
         */
        if (self.currentView == K_TASK_DETAIL_VIEW) {
            
            if(contentArray.count == 1 && i == 0){
                
                imageView.image = [UIImage imageNamed:@"tip-line-cycle"];
                imageView.frame = CGRectMake(10*WIDTH_SCALE, 50*HEIGHT_SCALE - 35*HEIGHT_SCALE, 16*WIDTH_SCALE, 16*WIDTH_SCALE);
            }else if (i == 0){
                
                imageView.image = [UIImage imageNamed:@"tip-line-up"];
                imageView.frame = CGRectMake(10*WIDTH_SCALE, 50*HEIGHT_SCALE - 35*HEIGHT_SCALE, 16*WIDTH_SCALE, 35*HEIGHT_SCALE);
            }else if (i == contentArray.count - 1){
                
                imageView.image = [UIImage imageNamed:@"tip-line-down"];
                imageView.frame = CGRectMake(10*WIDTH_SCALE, 50*HEIGHT_SCALE  * i, 16*WIDTH_SCALE, 35*HEIGHT_SCALE);
            }
            else{
                
                imageView.image = [UIImage imageNamed:@"tip-line-mid"];
            }
        }
        
        [self addSubview:imageView];
    }
    
    //添加上方分割线
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 1)];
    topLine.backgroundColor = color_dfeaff;
    [self addSubview:topLine];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
