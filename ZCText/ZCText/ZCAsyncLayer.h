//
//  ZCAsyncLayer.h
//  asyncView
//
//  Created by 黄镇城 on 2018/8/27.
//  Copyright © 2018年 黄镇城. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol ZCAsyncLayerDelegate<NSObject>
@required
- (void)asyncDisplayTask;
@end

@interface ZCAsyncLayer : CALayer

-(instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic, strong)NSMutableAttributedString *attributeText;
@end
