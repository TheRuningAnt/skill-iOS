//
//  SuggestionTextView.m
//  MakeLearn-iOS
//
//  Created by Hoop on 16/7/14.
//  Copyright © 2016年 董彩丽. All rights reserved.
//

#import "SuggestionTextView.h"

@implementation SuggestionTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 2.5f;//圆角
//        self.layer.borderWidth = 0.5f;    边框颜色
        self.GZplaceholderColor = [UIColor colorWithHexString:@"999999"];
        self.editable = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GZtextChanged:)   name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
-(void)setPlaceholder:(NSString *)placeholder{
    if (_GZplaceholder != placeholder) {
        _GZplaceholder = placeholder;
        [self.GZplaceHolderLabel removeFromSuperview];
        self.GZplaceHolderLabel = nil;
        [self setNeedsDisplay];
    }
}
- (void)GZtextChanged:(NSNotification *)notification{
    if ([[self GZplaceholder] length] == 0) {
        return;
    }
    if ([[self text] length] == 0) {
        [[self viewWithTag:666] setAlpha:1.0];
    }
    else{
        [[self viewWithTag:666] setAlpha:0];
    }
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if ([[self GZplaceholder] length] > 0) {
        if (_GZplaceHolderLabel == nil) {
            _GZplaceHolderLabel = [[UILabel    alloc]initWithFrame:CGRectMake(8*HEIGHT_SCALE, 8*HEIGHT_SCALE, self.bounds.size.width - 16, 0)];
            _GZplaceHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _GZplaceHolderLabel.numberOfLines = 0;
            _GZplaceHolderLabel.font = self.font;
            _GZplaceHolderLabel.backgroundColor = [UIColor clearColor];
            _GZplaceHolderLabel.textColor = self.GZplaceholderColor;
            _GZplaceHolderLabel.alpha = 0;
            _GZplaceHolderLabel.tag = 666;
            [self addSubview:_GZplaceHolderLabel];
        }
        _GZplaceHolderLabel.text = self.GZplaceholder;
        [_GZplaceHolderLabel sizeToFit];
        [self sendSubviewToBack:_GZplaceHolderLabel];
    }
    if ([[self text] length] == 0 && [[self GZplaceholder] length] >0) {
        [[self viewWithTag:666] setAlpha:1.0];
    } 
}
@end
