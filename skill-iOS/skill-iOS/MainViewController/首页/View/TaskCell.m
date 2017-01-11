//
//  TaskCell.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/24.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell()

{
    UILabel *titleL;
    UIButton *buttom;
    
@public
    TaskView *taskView;
}

@end

@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

//布局页面
-(void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置上方分割线
    UILabel *lineOfTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 1)];
    lineOfTop.backgroundColor = color_dfeaff;
    [self addSubview:lineOfTop];
    
    WK(weakSelf);
    //添加标题Label
    titleL = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:titleL];
    titleL.text = @"任务1";
    titleL.numberOfLines = 0;
    titleL.textColor = color_0f4068;
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:14*HEIGHT_SCALE];
    titleL.lineBreakMode = NSLineBreakByCharWrapping;
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.mas_left).offset(10);
        make.top.mas_equalTo(weakSelf.mas_top).offset(10*HEIGHT_SCALE);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-55*HEIGHT_SCALE);
        make.height.mas_equalTo(60*HEIGHT_SCALE);
    }];
    
    /**
     *  button的tag 默认为1,点击之后设置为2  以此为标志来决定图标的朝向
     */
    buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttom setImage:[UIImage imageNamed:@"tip-down"] forState:UIControlStateNormal];
    buttom.tag = 1;
    [buttom addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttom];
    
    [buttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*HEIGHT_SCALE, 60*HEIGHT_SCALE));
        make.right.mas_equalTo(self.mas_right).offset(-15*WIDTH_SCALE);
        make.centerY.mas_equalTo(titleL.mas_centerY);
    }];
}

-(void)clickBtn:(id)sender{
    
    self.block(self.indexPath);
}

-(void)setTaskTitle:(NSString *)taskTitle{
    titleL.text = taskTitle;
}


-(void)setCellTag:(NSInteger)cellTag{
    
    if (_cellTag != cellTag) {
        _cellTag = cellTag;
    }else{
        return;
    }
    
    if (cellTag == 2) {
        
        [buttom setImage:[UIImage imageNamed:@"tip-up"] forState:UIControlStateNormal];
    }else{
        
        [buttom setImage:[UIImage imageNamed:@"tip-down"] forState:UIControlStateNormal];
    }
}

//添加子视图
-(void)setContentArray:(NSArray *)contentArray{
    
    taskView = [[TaskView alloc] initWithFrame:CGRectMake(0, 80*HEIGHT_SCALE, kWindowWidth, contentArray.count * 50 * HEIGHT_SCALE)];
    
    taskView.backgroundColor = color_fafafa;
    taskView.contentArray = contentArray;
    [self addSubview:taskView];
}

//移除子视图
-(void)removeContentView{
    NSLog(@"移除了子视图");
    if (taskView && taskView.superview ) {
        [taskView removeFromSuperview];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
