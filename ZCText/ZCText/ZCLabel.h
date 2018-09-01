//
//  ZCLabel.h
//  asyncView
//
//  Created by 黄镇城 on 2018/8/27.
//  Copyright © 2018年 黄镇城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCLabel : UIView

@property (nullable, nonatomic, copy) NSString *text;

@property (nullable, nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic, assign) NSUInteger numberOfLines;

@property (nonatomic) NSTextAlignment textAlignment;

@property (null_resettable, nonatomic, strong) UIColor *textColor;

@property (null_resettable, nonatomic, strong) UIFont *font;

@end
