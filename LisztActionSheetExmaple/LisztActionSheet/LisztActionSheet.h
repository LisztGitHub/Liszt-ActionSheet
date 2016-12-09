//
//  LisztActionSheet.h
//  LisztActionSheetExmaple
//
//  Created by Liszt on 16/12/6.
//  Copyright © 2016年 https://github.com/LisztGitHub. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LisztActionSheet;
@class LisztActionSheetButton;

typedef void(^LisztSheetButtonActionBlock)(NSInteger index);
typedef void(^LisztActionSheetBlock)(LisztActionSheet *sheet);
typedef void(^LisztActionLoadButtonBlock)(NSInteger idx);

@interface LisztActionSheetButton:NSObject
/*标题*/
@property (copy, nonatomic) NSString *title;
/*标题颜色*/
@property (strong, nonatomic) UIColor *titleColor;
/*背景颜色*/
@property (strong, nonatomic) UIColor *backgroudColor;
/*高亮颜色*/
@property (strong, nonatomic) UIColor *highlightedColor;
/*font*/
@property (strong, nonatomic) UIFont *font;

+ (instancetype)configSheetItemTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroudColor:(UIColor *)backgroudColor highlightedColor:(UIColor *)highlightedColor font:(UIFont *)font;
@end

@interface LisztActionSheet : UIView
+ (instancetype)actionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonStrings:(NSArray <NSString *>*)otherButtons buttonDidSelectBlock:(LisztSheetButtonActionBlock)buttonSelectBlock;
+ (instancetype)actionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonItems:(NSArray <LisztActionSheetButton *>*)otherButtons buttonDidSelectBlock:(LisztSheetButtonActionBlock)buttonSelectBlock;
+ (instancetype)actionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonItems:(NSArray <LisztActionSheetButton *>*)otherButtons handleActionSheet:(LisztActionSheetBlock)actionSheetBlock buttonDidSelectBlock:(LisztSheetButtonActionBlock)buttonSelectBlock;
+ (instancetype)actionSheetTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonItems:(NSArray <LisztActionSheetButton *>*)otherButtons handleActionButton:(LisztActionLoadButtonBlock)actionButtonBlock handleActionSheet:(LisztActionSheetBlock)actionSheetBlock buttonDidSelectBlock:(LisztSheetButtonActionBlock)buttonSelectBlock;

- (void)setCancelTitle:(NSString *)title forState:(UIControlState)state;
- (void)setCancelTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setCancelButtonBackgroundImage:(UIImage *)image forState:(UIControlState)state;
@property (strong, nonatomic) UIFont *cancelButtonFont;
@property (strong, nonatomic) UIColor *titleBackgroudColor;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@end
