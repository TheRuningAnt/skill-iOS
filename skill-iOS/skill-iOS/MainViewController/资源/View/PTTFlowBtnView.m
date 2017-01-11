//
//  PTTFlowBtnView.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/1.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTFlowBtnView.h"

@interface PTTFlowBtnView()

{
    void (^pttBlock)(NSInteger tagValue);
    UIButton *lastButton;
}

@end

@implementation PTTFlowBtnView

/**
 根据给定的标题数据和属性创建一个按钮点击列表
 
 @param frame 该视图的frame
 @param titles 按钮标题数组
 @param btnWidth 按钮宽度
 @param btnHeight 按钮高度
 @param numberOfHori 水平方向放置几个按钮
 @param block block回调方法
 @return 返回创建好的流式按钮布局
 */

-(instancetype)initPttFolwBtnViewWithFrame:(CGRect)frame titles:(NSArray*)titles btnWith:(CGFloat)btnWidth btnHeight:(CGFloat)btnHeight numberOfHorizontal:(NSInteger)numberOfHori block:(void (^)(NSInteger tagValue))block{

    if (self = [super initWithFrame:frame]) {
        
        //创建背景虚化图片
        UIImageView *shadowImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        shadowImageV.alpha = 0.3f;
        shadowImageV.image = [UIImage imageNamed:@"Shadow-image"];
        [self addSubview:shadowImageV];
        
        //创建承载子按钮的容器View
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 4.0f*btnHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        //获取block
        pttBlock = block;
        
        /*
         *  在contentView上布局按钮
         */
    
        //计算横向间隙
        CGFloat horizontal_space = (kWindowWidth - numberOfHori * btnWidth)/(numberOfHori + 1);
        //垂直间隙固定为20.0f*HEIGHT_SCALE
        CGFloat vertical_space = 20.0f*HEIGHT_SCALE;
        //记录行数
        NSInteger lineNumber = 0;
        //记录列数
        NSInteger rowNumber = 0;
        
        //开始布局按钮
        for(int i =0; i < titles.count; i ++){
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.masksToBounds = YES;
            button.layer.borderColor = color_51d4b9.CGColor;
            button.layer.borderWidth = 1.0f;
            button.layer.cornerRadius = 3;
            [button setBackgroundColor:[UIColor whiteColor]];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.tag = i + 1;
            
            //设置未选中状态属性
            [button setTitleColor:color_51d4b9 forState:UIControlStateNormal];
            //设置选中状态属性
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            //更新行列数
            lineNumber = i / numberOfHori;
            rowNumber = i%numberOfHori;
            //布局按钮
            button.frame = CGRectMake(rowNumber * (btnWidth + horizontal_space) + horizontal_space, lineNumber * (btnHeight + vertical_space) + 20 *HEIGHT_SCALE, btnWidth, btnHeight);
            
            [contentView addSubview:button];
        }
    }
    
    return self;
}

-(void)clickBtn:(id)sender{
    
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton*)sender;
        
        if(!button.selected){
            
            [button setBackgroundColor:color_51d4b9];
            button.selected = YES;
        }else{
            
            [button setBackgroundColor:[UIColor whiteColor]];
            button.selected = NO;
        }
    
        //记录点击的button
        if(lastButton){

            lastButton.selected = NO;
            [lastButton setBackgroundColor:[UIColor whiteColor]];
            lastButton = button;
        }else{
            
            lastButton = button;
        }
        
        pttBlock(button.tag);
    }
}


@end
