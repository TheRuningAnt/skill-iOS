//
//  TaskCell.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/24.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskView.h"

/**
 *  职位详情页面下方 任务展示使用的cell
 */
@interface TaskCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;

/**
 *  展示任务的title
 */
@property (nonatomic,strong) NSString *taskTitle;

/**
 *  响应点击事件的block
 */
@property (nonatomic,copy) void (^block)(NSIndexPath* index);
/**
 *  标记显示的点击图标样式
 */
@property (nonatomic,assign) NSInteger cellTag;
/**
 *  当伸出视图的时候  保存数据的数组
 */
@property (nonatomic,strong)NSArray *contentArray;
/**
 *  移除任务详情子视图
 */
-(void)removeContentView;


@end
