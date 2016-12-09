//
//  LisztActionSheet.m
//  LisztActionSheetExmaple
//
//  Created by Liszt on 16/12/6.
//  Copyright © 2016年 https://github.com/LisztGitHub. All rights reserved.
//

#import "LisztActionSheet.h"
#define LISZTSHEET_COLOR(_A,_B,_C,_ALPHA) [UIColor colorWithRed:_A/255.0 green:_B/255.0 blue:_C/255.0 alpha:_ALPHA]
#define BUTTON_HEIGHT 50
#define TITLE_MARGIN 20

typedef NS_ENUM(NSUInteger,LisztActionSheetItemType) {
    /*LisztActionSheetButton*/
    LisztActionSheetItemButton,
    /*NSString*/
    LisztActionSheetItemString
};

@interface LisztActionSheet(){
    /*title*/
    NSString *sheetTitle;
}
/*content*/
@property (strong, nonatomic) UIView *contentView;
/*取消按钮*/
@property (strong, nonatomic) UIButton *cancelButton;
/*titleView*/
@property (strong, nonatomic) UIView *titleBgView;
/*titleLabel*/
@property (strong, nonatomic) UILabel *titleLabel;
/*选择回调*/
@property (copy, nonatomic) LisztSheetButtonActionBlock buttonSelectBlock;
@end

@implementation LisztActionSheet

+ (instancetype)actionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonItems:(NSArray<LisztActionSheetButton *> *)otherButtons buttonDidSelectBlock:(LisztSheetButtonActionBlock)buttonSelectBlock{
    return [[LisztActionSheet alloc]initWithTitle:title cancelButtonTitle:cancelTitle otherButtonItems:otherButtons handleActionButton:nil handleActionSheet:nil buttonDidSelectBlock:buttonSelectBlock];
}
+ (instancetype)actionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonStrings:(NSArray<NSString *> *)otherButtons buttonDidSelectBlock:(LisztSheetButtonActionBlock)buttonSelectBlock{
    return [[LisztActionSheet alloc]initWithTitle:title cancelButtonTitle:cancelTitle otherButtonItems:otherButtons handleActionButton:nil handleActionSheet:nil buttonDidSelectBlock:buttonSelectBlock];
}
+ (instancetype)actionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonItems:(NSArray<LisztActionSheetButton *> *)otherButtons handleActionSheet:(LisztActionSheetBlock)actionSheetBlock buttonDidSelectBlock:(LisztSheetButtonActionBlock)buttonSelectBlock{
    return [[LisztActionSheet alloc]initWithTitle:title cancelButtonTitle:cancelTitle otherButtonItems:otherButtons handleActionButton:nil handleActionSheet:actionSheetBlock buttonDidSelectBlock:buttonSelectBlock];
}
+ (instancetype)actionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonItems:(NSArray <LisztActionSheetButton *>*)otherButtons handleActionButton:(LisztActionLoadButtonBlock)actionButtonBlock handleActionSheet:(LisztActionSheetBlock)actionSheetBlock buttonDidSelectBlock:(LisztSheetButtonActionBlock)buttonSelectBlock{
    return [[LisztActionSheet alloc]initWithTitle:title cancelButtonTitle:cancelTitle otherButtonItems:otherButtons handleActionButton:actionButtonBlock handleActionSheet:actionSheetBlock buttonDidSelectBlock:buttonSelectBlock];
}
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonItems:(NSArray *)otherButtons handleActionButton:(LisztActionLoadButtonBlock)actionButtonBlock handleActionSheet:(LisztActionSheetBlock)actionSheetBlock buttonDidSelectBlock:(void (^)(NSInteger))buttonSelectBlock{
    self = [super init];
    if(self){
        if(!otherButtons.count)return nil;
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
        sheetTitle = title;
        self.buttonSelectBlock = buttonSelectBlock;
        [self addSubview:self.contentView];
        CGFloat titleHeight = title&&![title isEqualToString:@""]?[LisztActionSheet getHeightText:title font:[UIFont systemFontOfSize:13] labelWidth:CGRectGetWidth(self.frame)-30]+TITLE_MARGIN*2:0;
        CGFloat cancelHeight = cancelTitle&&![cancelTitle isEqualToString:@""]?BUTTON_HEIGHT:0;
        CGFloat otherHeight = otherButtons.count * BUTTON_HEIGHT;
        CGFloat totalHeight = titleHeight + cancelHeight + otherHeight + (titleHeight?10:0);
        self.contentView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), totalHeight);
        
        LisztActionSheetItemType type = [otherButtons[0] isKindOfClass:[NSString class]]?LisztActionSheetItemString:LisztActionSheetItemButton;
        
        [otherButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(actionButtonBlock){
                actionButtonBlock(idx);
            }
            
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            itemButton.frame = CGRectMake(0, cancelHeight?(self.contentView.frame.size.height - BUTTON_HEIGHT - 10) - BUTTON_HEIGHT * idx - BUTTON_HEIGHT:self.contentView.frame.size.height - BUTTON_HEIGHT * idx - BUTTON_HEIGHT, CGRectGetWidth(self.contentView.frame), BUTTON_HEIGHT);
            [itemButton setTitleColor:type==LisztActionSheetItemString?[UIColor blackColor]:[(LisztActionSheetButton *)otherButtons[otherButtons.count-idx-1] titleColor] forState:UIControlStateNormal];
            itemButton.tag = otherButtons.count-idx-1;
            [itemButton setTitle:type==LisztActionSheetItemString?otherButtons[otherButtons.count-idx-1]:[(LisztActionSheetButton *)otherButtons[otherButtons.count-idx-1] title] forState:UIControlStateNormal];
            itemButton.titleLabel.font = type==LisztActionSheetItemString?[UIFont systemFontOfSize:17.f]:[(LisztActionSheetButton *)otherButtons[otherButtons.count-idx-1] font];
            [itemButton setBackgroundImage:type==LisztActionSheetItemString?[LisztActionSheet buttonImageFromColor:LISZTSHEET_COLOR(124, 124, 124, 0.9)]:[LisztActionSheet buttonImageFromColor:[(LisztActionSheetButton *)otherButtons[otherButtons.count-idx-1] highlightedColor]] forState:UIControlStateHighlighted];
            [itemButton setBackgroundImage:type==LisztActionSheetItemString?[LisztActionSheet buttonImageFromColor:LISZTSHEET_COLOR(255, 255, 255, 0.95)]:[LisztActionSheet buttonImageFromColor:[(LisztActionSheetButton *)otherButtons[otherButtons.count-idx-1] backgroudColor]] forState:UIControlStateNormal];
            [itemButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:itemButton];
            
            if(idx-1<otherButtons.count-1){
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(itemButton.frame)-0.4, CGRectGetWidth(itemButton.frame), 0.4)];
                lineView.backgroundColor = LISZTSHEET_COLOR(0, 0, 0, 0.2);
                [itemButton addSubview:lineView];
            }
        }];
        if(cancelHeight){
            [self.contentView addSubview:self.cancelButton];
        }
        if(titleHeight){
            [self.contentView addSubview:self.titleBgView];
        }
        if(actionSheetBlock){
            actionSheetBlock(self);
        }
        [self showActionSheet];
    }
    return self;
}

#pragma mark - Button Action
- (void)buttonAction:(UIButton *)sender{
    [self dismiss];
    if(sender.tag==99){
        return;
    }
    if(self.buttonSelectBlock){
        self.buttonSelectBlock(sender.tag);
    }
}

#pragma mark - 懒加载
- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}
- (UIView *)titleBgView{
    if(!_titleLabel){
        CGFloat titleHeight = sheetTitle&&![sheetTitle isEqualToString:@""]?[LisztActionSheet getHeightText:sheetTitle font:[UIFont systemFontOfSize:13] labelWidth:CGRectGetWidth(self.frame)-30]+TITLE_MARGIN*2:0;
        
        _titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), titleHeight)];
        _titleBgView.backgroundColor = LISZTSHEET_COLOR(255, 255, 255, 0.95);
        
        /*1.标题*/
        [_titleBgView addSubview:self.titleLabel];
        self.titleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), (CGRectGetHeight(_titleBgView.frame)-titleHeight)/2, CGRectGetWidth(self.titleLabel.frame), titleHeight);
        
        /*2.线条*/
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_titleBgView.frame)-0.4, CGRectGetWidth(_titleBgView.frame), 0.4)];
        lineView.backgroundColor = LISZTSHEET_COLOR(0, 0, 0, 0.3);
        [_titleBgView addSubview:lineView];
    }
    return _titleBgView;
}
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.contentView.frame) - 30, 13)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = sheetTitle;
        _titleLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return _titleLabel;
}
- (UIButton *)cancelButton{
    if(!_cancelButton){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, self.contentView.frame.size.height - BUTTON_HEIGHT, CGRectGetWidth(self.contentView.frame), BUTTON_HEIGHT);
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.tag = 99;
        [_cancelButton setBackgroundImage:[LisztActionSheet buttonImageFromColor:LISZTSHEET_COLOR(124, 124, 124, 0.9)] forState:UIControlStateHighlighted];
        [_cancelButton setBackgroundImage:[LisztActionSheet buttonImageFromColor:LISZTSHEET_COLOR(255, 255, 255, 0.95)] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    }
    return _cancelButton;
}

#pragma mark - Utils
+ (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 20, 20);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}
+(CGFloat)getHeightText:(NSString *)text font:(UIFont *)font labelWidth:(CGFloat)width{
    NSDictionary *attrDic = @{NSFontAttributeName:font};
    CGRect strRect = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attrDic context:nil];
    return strRect.size.height;
}

#pragma mark - Set
- (void)setCancelTitle:(NSString *)title forState:(UIControlState)state{
    [self.cancelButton setTitle:title forState:UIControlStateNormal];
}
- (void)setCancelTitleColor:(UIColor *)color forState:(UIControlState)state{
    [self.cancelButton setTitleColor:color forState:state];
}
- (void)setCancelButtonBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    [self.cancelButton setBackgroundImage:image forState:state];
}
- (void)setCancelButtonFont:(UIFont *)cancelButtonFont{
    self.cancelButton.titleLabel.font = cancelButtonFont;
}
- (void)setTitleBackgroudColor:(UIColor *)titleBackgroudColor{
    self.titleBgView.backgroundColor = titleBackgroudColor;
}
- (void)setTitleColor:(UIColor *)titleColor{
    self.titleLabel.textColor = titleColor;
}
- (void)setTitleFont:(UIFont *)titleFont{
    self.titleLabel.font = titleFont;
}

#pragma mark - Frame Show
- (void)dismiss{
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 0.3;
        CGRect tempRect = self.contentView.frame;
        tempRect.origin.y = CGRectGetHeight(self.frame);
        self.contentView.frame = tempRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)showActionSheet{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = LISZTSHEET_COLOR(0, 0, 0, 0.3);
        CGRect tempRect = self.contentView.frame;
        tempRect.origin.y = CGRectGetHeight(self.frame)-tempRect.size.height;
        self.contentView.frame = tempRect;
    } completion:^(BOOL finished) {}];
}
@end

@implementation LisztActionSheetButton

+ (instancetype)configSheetItemTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroudColor:(UIColor *)backgroudColor highlightedColor:(UIColor *)highlightedColor font:(UIFont *)font{
    LisztActionSheetButton *tempItem = [[LisztActionSheetButton alloc]init];
    tempItem.title = title;
    tempItem.titleColor = titleColor;
    tempItem.backgroudColor = backgroudColor;
    tempItem.highlightedColor = highlightedColor;
    tempItem.font = font;
    return tempItem;
}

@end
