# ZCText
### 概述
本工程主要是使用`CoreText`进行异步渲染，能有效解决tableView滑动卡顿的问题。

### 使用
```
>NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
style.alignment = NSTextAlignmentLeft;
NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"异步渲染" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor redColor],NSParagraphStyleAttributeName:style}];
[attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor greenColor],NSParagraphStyleAttributeName:style} range:NSMakeRange(0, 1)];
[attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor greenColor],NSParagraphStyleAttributeName:style} range:NSMakeRange(2, 1)];
cell.label1.attributedText = attr;
```
