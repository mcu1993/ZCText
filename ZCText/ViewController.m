//
//  ViewController.m
//  asyncView
//
//  Created by 黄镇城 on 2018/8/23.
//  Copyright © 2018年 黄镇城. All rights reserved.
//

#import "ViewController.h"
#import "ZCAsyncLayer.h"
#import "ZCLabel.h"
#import "ZCTestAsyncTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong)ZCAsyncLayer *asLayer;
//@property (nonatomic,strong)ZCLabel *asLabel;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = NO;
//    self.asLayer = [[ZCAsyncLayer alloc] initWithFrame:CGRectMake(100, 100, [UIScreen mainScreen].bounds.size.width - 200, 200)];
//    self.asLayer.backgroundColor = [UIColor greenColor].CGColor;
////    self.asLayer.frame = CGRectMake(100, 100, [UIScreen mainScreen].bounds.size.width - 200, 200);
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.alignment = NSTextAlignmentCenter;
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest硕大的所多硕大的所多硕大的所多硕大的所多硕大的所多硕大的所多硕大的所多硕大的所多硕大的所多硕大的所多硕大的所多硕大的所多" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor redColor],NSParagraphStyleAttributeName:style}];
//    self.asLayer.attributeText  =attr;
//    [self.view.layer addSublayer:self.asLayer];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"第二次渲染" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor redColor],NSParagraphStyleAttributeName:style}];
//        self.asLayer.attributeText  =attr;
//        self.asLayer.frame = CGRectMake(100, 100, [UIScreen mainScreen].bounds.size.width - 200, 100);
//    });
    
//    self.asLabel = [[ZCLabel alloc] initWithFrame:CGRectMake(100, 350, 100, 100)];
//    self.asLabel.attributedText = attr;
//    self.asLabel.numberOfLines = 0;
//    self.asLabel.text = @"123123";
    
//    self.asLabel.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:self.asLabel];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 99;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZCTestAsyncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
    if (!cell) {
        cell = [[ZCTestAsyncTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.asyncLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
//    cell.asyncLabel.text = [NSString stringWithFormat:@"teteteettsdtdr%zd",indexPath.row];
//    
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.alignment = NSTextAlignmentCenter;
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"异步渲染test异步渲染test异步渲染test异步渲染test异步渲染test异步渲染test异步渲染test异步渲染test" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor redColor],NSParagraphStyleAttributeName:style}];
//    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor greenColor]} range:NSMakeRange(2, 2)];
//    cell.asyncLabel2.attributedText = attr;
//    cell.asyncLabel2.backgroundColor = [UIColor blueColor];
//    cell.asyncLabel3.text = [NSString stringWithFormat:@"3333333异步渲染test%zd",indexPath.row];
    return cell;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
