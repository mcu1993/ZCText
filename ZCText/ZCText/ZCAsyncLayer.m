//
//  ZCAsyncLayer.m
//  asyncView
//
//  Created by 黄镇城 on 2018/8/27.
//  Copyright © 2018年 黄镇城. All rights reserved.
//

#import "ZCAsyncLayer.h"
#import "CALayer+AsynchronousLayer.h"

@implementation ZCAsyncLayer

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.frame = frame;
        [self setNeedsDisplay];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [super setFrame:frame];
    [self setNeedsDisplay];
    [CATransaction commit];
}

-(void)dealloc{
    
}

-(void)setAttributeText:(NSMutableAttributedString *)attributeText{
    _attributeText = attributeText;
    [self setNeedsDisplay];
}

-(void)setNeedsDisplay{
    [super setNeedsDisplay];
}

- (void)display {
    super.contents = super.contents;
    if (self.attributeText) {
        [self drawTextInRect:self.bounds AttributedString:self.attributeText];
    }else {
        __strong id<ZCAsyncLayerDelegate> delegate = (id)self.delegate;
        [delegate asyncDisplayTask];
    }
}

@end
