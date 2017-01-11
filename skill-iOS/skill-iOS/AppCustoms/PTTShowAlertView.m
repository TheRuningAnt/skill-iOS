//
//  PTTShowAlertView.m
//  skill-iOS
//
//  Created by 赵广亮 on 2016/10/29.
//  Copyright © 2016年 zhaoguangliangzhaoguanliang. All rights reserved.
//

#import "PTTShowAlertView.h"
#import <objc/runtime.h>


/**
 *  执行点击事件的内部代理对象
 */
@interface __Target : NSObject<UIAlertViewDelegate>

{
   @private
    void (^_cancelBlock)();
    void (^_sureBlock)();
}
-(instancetype)initWithCancelAction:(void (^)())cancelBlock sureAction:(void (^)())sureBlock;

@end

@implementation __Target

-(instancetype)initWithCancelAction:(void (^)())cancelBlock sureAction:(void (^)())sureBlock{
    
    self = [super init];
    if (self) {
        
        _cancelBlock = cancelBlock;
        _sureBlock = sureBlock;
    }
    
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0 && _cancelBlock){
        
        _cancelBlock();
    }
    
    if (buttonIndex == 1 && _sureBlock) {
        
        _sureBlock();
    }
}

@end

@interface PTTShowAlertView()<UIAlertViewDelegate>

@end

@implementation PTTShowAlertView

static const int bind_Key;

/**创建alertView
 *  根据给定的描述文本和按钮标题以及对应的Block块创建一个alertView
 *  自己管理自己的生命周期
 *
 *  @param title       描述文本
 *  @param cancelTitle 取消按钮标题
 *  @param cancelBlock 取消按钮调用Block块
 *  @param sureTitle   确定按钮标题
 *  @param sureBlock   确定按钮调用block块
 */
+(void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message cancleBtnTitle:(NSString*)cancelTitle cancelAction:(void (^)())cancelBlock sureBtnTitle:(NSString*)sureTitle sureAction:(void (^)())sureBlock{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:sureTitle, nil];
    
    //绑定代理处理对象
    __Target *target = [[__Target alloc] initWithCancelAction:cancelBlock sureAction:sureBlock];
    alertView.delegate = target;
    objc_setAssociatedObject(self, &bind_Key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [alertView show];
}


@end
