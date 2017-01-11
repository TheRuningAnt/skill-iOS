//
//  LibraryModel.h
//  skill-iOS
//
//  Created by 赵广亮 on 2016/11/1.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryModel : NSObject

/**
  文档ID
 */
@property (nonatomic,assign) NSInteger libraryId;
/**
 技能ID
 */
@property (nonatomic,assign) NSInteger sid;
/**
 职业ID
 */
@property (nonatomic,assign) NSInteger oid;
/**
  技能名称
 */
@property (nonatomic,strong) NSString *skillName;
/**
 type 类型	number	1.文档 2.视频 3.书籍
 */
@property (nonatomic,assign) NSInteger type;
/**
   文档地址
 */
@property (nonatomic,strong) NSString *url;
/**
点赞数
 */
@property (nonatomic,assign) int32_t like;
/*
  简介
 */
@property (nonatomic,strong) NSString *introduce;
/*
 来源
 */
@property (nonatomic,strong) NSString *resource;
/**
 推荐者id
 */
@property (nonatomic,assign) NSInteger author;
/**
 文档名
 */
@property (nonatomic,strong) NSString *name;
/**
 创建时间
 */
@property (nonatomic,assign) NSInteger createAt;
/**
 是否点赞
 */
@property (nonatomic,assign) BOOL ifLike;
/**
 是否收藏
 */
@property (nonatomic,assign) BOOL ifCollection;
/**
 图片链接
 */
@property (nonatomic,strong) NSString *img;
/**
   推荐者姓名
 */
@property (nonatomic,strong) NSString *authorName;

@end
