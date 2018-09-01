//
//  ZCTestCollectionViewCell.m
//  asyncView
//
//  Created by 黄镇城 on 2018/8/29.
//  Copyright © 2018年 黄镇城. All rights reserved.
//

#import "ZCTestCollectionViewCell.h"
#import "ZCLabel.h"
@implementation ZCTestCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.label1.frame = CGRectMake(0, 0, 100, 20);
        self.label2.frame = CGRectMake(0, 20, 100, 20);
        self.label3.frame = CGRectMake(0, 40, 100, 20);
        self.label4.frame = CGRectMake(0, 60, 100, 20);
    }
    return self;
}


-(ZCLabel *)label1{
    if (!_label1) {
        _label1 = [[ZCLabel alloc] init];
        _label1.opaque = NO;
        _label1.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _label1.text = @"label1";
        _label1.textColor = [UIColor redColor];
        [self.contentView addSubview:_label1];
    }
    return _label1;
}
-(ZCLabel *)label2{
    if (!_label2) {
        _label2 = [[ZCLabel alloc] init];
        _label2.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _label2.text = @"label2";
        _label2.textColor = [UIColor greenColor];
        [self.contentView addSubview:_label2];
    }
    return _label2;
}
-(ZCLabel *)label3{
    if (!_label3) {
        _label3 = [[ZCLabel alloc] init];
        _label3.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _label3.text = @"label3";
        _label3.textColor = [UIColor blueColor];
        [self.contentView addSubview:_label3];
    }
    return _label3;
}
-(ZCLabel *)label4{
    if (!_label4) {
        _label4 = [[ZCLabel alloc] init];
        _label4.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _label4.text = @"label4";
        _label4.textColor = [UIColor yellowColor];
        [self.contentView addSubview:_label4];
    }
    return _label4;
}

@end
