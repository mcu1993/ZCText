//
//  CALayer+AsynchronousLayer.h
//  testCoreText
//
//  Created by hzc on 2018/4/18.
//  Copyright © 2018年 hzc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface CALayer (AsynchronousLayer)
/**
 *   绘制文本到指定范围
 @param textRect 文本绘制区域
 @param attr 富文本
 @param numberOfLine 行数
 */
- (void)drawTextInRect:(CGRect)textRect AttributedString:(NSAttributedString *)attr numberOfLine:(NSUInteger)numberOfLine;
/**
 *   绘制文本到指定范围
 @param textRect 文本绘制区域
 @param attr 富文本
 */
- (void)drawTextInRect:(CGRect)textRect AttributedString:(NSAttributedString *)attr;
/**
 *   绘制文本到指定范围（有背景图片）
 @param textRect 文本绘制区域
 @param bgImgName 背景图片
 @param attr 富文本
 */
- (void)drawTextInRect:(CGRect)textRect bgImgName:(NSString *)bgImgName AttributedString:(NSAttributedString *)attr;
/**
 *   绘制图片到指定范围
 @param contentRect 图片绘制区域
 @param imageName 图片名字
 */
- (void)drawImageInRect:(CGRect)contentRect imageName:(NSString *)imageName;
/**
 *   绘制图片到指定范围
 @param imageRect 图片绘制区域
 @param image 图片
 */
-(void)drawImageInRect:(CGRect)imageRect image:(UIImage *)image;
@end
