//
//  ZCLabel.m
//  asyncView
//
//  Created by 黄镇城 on 2018/8/27.
//  Copyright © 2018年 黄镇城. All rights reserved.
//

#import "ZCLabel.h"
#import "ZCAsyncLayer.h"
#import "CALayer+AsynchronousLayer.h"

@interface ZCLabel()<ZCAsyncLayerDelegate>

@end

@implementation ZCLabel


+ (Class)layerClass {
    return [ZCAsyncLayer class];
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    _attributedText = attributedText;
    [self.layer setNeedsDisplay];
}

-(void)setNumberOfLines:(NSUInteger)numberOfLines{
    _numberOfLines = numberOfLines;
    [self.layer setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    [self.layer setNeedsDisplay];
}

-(void)setText:(NSString *)text{
    _text = text;
    [self.layer setNeedsDisplay];
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self.layer setNeedsDisplay];
}

-(void)setFont:(UIFont *)font{
    _font = font;
    [self.layer setNeedsDisplay];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    self.layer.backgroundColor = backgroundColor.CGColor;
}

#pragma mark - layer异步渲染代理
-(void)asyncDisplayTask{
    
    if (!self.attributedText) {
        //如果富文本为空
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = self.textAlignment;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor,NSParagraphStyleAttributeName:style}];
        [self.layer drawTextInRect:self.bounds AttributedString:attr numberOfLine:self.numberOfLines];
    }else {
        [self.layer drawTextInRect:self.bounds AttributedString:self.attributedText numberOfLine:self.numberOfLines];
    }
    //如果有图片数组不为空，则绘制图片
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
