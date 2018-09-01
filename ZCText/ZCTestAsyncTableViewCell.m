//
//  ZCTestAsyncTableViewCell.m
//  asyncView
//
//  Created by 黄镇城 on 2018/8/28.
//  Copyright © 2018年 黄镇城. All rights reserved.
//

#import "ZCTestAsyncTableViewCell.h"
#import "ZCLabel.h"
#import "ZCTestCollectionViewCell.h"

@interface ZCTestAsyncTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@end

@implementation ZCTestAsyncTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.collectionView.hidden = NO;
    }
    return self;
}

#pragma mark ---- collectionView

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//item 间隔
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//定义每个UICollectionView 的内边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 200);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}


#pragma mark - collectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    [_collectionView registerClass:[ZCTestCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"ZoneCollectionViewCell%zd",indexPath.row]];
    ZCTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"ZoneCollectionViewCell%zd",indexPath.row] forIndexPath:indexPath];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"异步渲染" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor redColor],NSParagraphStyleAttributeName:style}];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor greenColor],NSParagraphStyleAttributeName:style} range:NSMakeRange(0, 1)];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor greenColor],NSParagraphStyleAttributeName:style} range:NSMakeRange(2, 1)];
    cell.label1.attributedText = attr;
    return cell;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
