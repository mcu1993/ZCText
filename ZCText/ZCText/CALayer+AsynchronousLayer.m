//
//  CALayer+AsynchronousLayer.m
//  testCoreText
//
//  Created by hzc on 2018/4/18.
//  Copyright © 2018年 hzc. All rights reserved.
//

#import "CALayer+AsynchronousLayer.h"
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
@implementation CALayer (AsynchronousLayer)

- (void)drawAttributedText:(NSAttributedString *)attributedText
                 textRange:(NSRange)textRange
                    inRect:(CGRect)rect
              numberOfLine:(NSUInteger)numberOfLine
{
    if (!attributedText || attributedText.length == 0) {
        return;
    }
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    /* Push a copy of the current graphics state onto the graphics state stack.*/
    CGContextSaveGState(context);
    {
        //coretext 坐标系反转
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGContextScaleCTM(context, 1.0f, -1.0f);

        CGSize size = [self sizeWithConstrainedToWidth:rect.size.width attributedString:attributedText];
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedText);
        //是否全是中文
        NSString *regex = @"[\u4e00-\u9fa5]+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isAllChinese = [pred evaluateWithObject:[attributedText string]];
        BOOL isBigScreen = [UIScreen mainScreen].bounds.size.width > 375.0;
//        NSLog(@"%zd--%@",isAllChinese,[attributedText string]);
        CGRect _rect = CGRectMake(0,isAllChinese && !isBigScreen ? (rect.size.height - size.height) / 2 + 1 : (rect.size.height - size.height) / 2 ,
                                  CGRectGetWidth(rect),
                                  size.height);

        CGPathRef path = CGPathCreateWithRect(_rect,nil);

        CFRange _textRange = CFRangeMake(textRange.location, textRange.length);

        CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                    _textRange,
                                                    path,
                                                    nil);
        
        CFArrayRef lines = CTFrameGetLines(frame);
        CFIndex lineCount = CFArrayGetCount(lines);
        CGPoint lineOrigins[lineCount];
        // 把ctFrame里每一行的初始坐标写到数组里，注意CoreText的坐标是左下角为原点
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
        CGFloat frameY = 0;
        for (CFIndex i = 0; i < lineCount; i++){
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            CGFloat lineAscent = 0;
            CGFloat lineDescent = 0;
            CGFloat lineLeading = 0; // 行距
            // 该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
            CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
            CGPoint lineOrigin = lineOrigins[i];
            
            if (i > 0){
                frameY = frameY - lineAscent - lineLeading;//减去一个行间距，再减去第二行，字形的上部分 （循环）
            } else{
                frameY = lineOrigin.y + lineLeading;
                if (i == 0) {
                    if (lineCount > 1) {
                        frameY = rect.size.height  - lineAscent - lineLeading;
                    }else {
                        frameY = rect.size.height / 2  - (lineAscent + lineLeading) / 2 + 1;
                    }
                }
            }
            lineOrigin.y = frameY;
            //调整坐标
            CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
            
            //判断是否最后一行
            BOOL islastLine = NO;
            if (i < lineCount - 1) {//判断下一行是否能显示的下
                CTLineRef line = CFArrayGetValueAtIndex(lines, i + 1);
                CGFloat lineAscent = 0;
                CGFloat lineDescent = 0;
                CGFloat lineLeading = 0; // 行距
                // 该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
                CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
                CGFloat nextLineY =  frameY - lineDescent - lineAscent - lineLeading;
                if (nextLineY < 0 || i == numberOfLine - 1) {//显示不下
                    islastLine = YES;
                }
            }else {//已经是最后一行了
                islastLine = YES;
            }
            // 最后一行,显示不下，加上省略号
            static NSString* const kEllipsesCharacter = @"\u2026";
            CFRange lastLineRange = CTLineGetStringRange(line);
            if (lastLineRange.location + lastLineRange.length < (CFIndex)attributedText.length && islastLine && frameY > 0){
                // 这一行放不下所有的字符（下一行还有字符），则把此行后面的回车、空格符去掉后，再把最后一个字符替换成省略号
                CTLineTruncationType truncationType = kCTLineTruncationEnd;
                NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
                // 拿到最后一个字符的属性字典
                NSDictionary *tokenAttributes = [attributedText attributesAtIndex:truncationAttributePosition                                                                    effectiveRange:NULL];
                // 给省略号字符设置字体大小、颜色等属性
                NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:kEllipsesCharacter                                                                                      attributes:tokenAttributes];
                // 用省略号单独创建一个CTLine，下面在截断重新生成CTLine的时候会用到
                CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenString);
                // 把这一行的属性字符串复制一份，如果要把省略号放到中间或其他位置，只需指定复制的长度即可
                NSUInteger copyLength = lastLineRange.length;
                NSMutableAttributedString *truncationString = [[attributedText attributedSubstringFromRange:NSMakeRange(lastLineRange.location, copyLength)] mutableCopy];
                
                if (lastLineRange.length > 0)
                {
                    // Remove any whitespace at the end of the line.
                    unichar lastCharacter = [[truncationString string] characterAtIndex:copyLength - 1];
                    
                    // 如果复制字符串的最后一个字符是换行、空格符，则删掉
                    if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:lastCharacter])
                    {
                        [truncationString deleteCharactersInRange:NSMakeRange(copyLength - 1, 1)];
                    }
                }
                
                // 拼接省略号到复制字符串的最后
                [truncationString appendAttributedString:tokenString];
                
                // 把新的字符串创建成CTLine
                CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
                
                // 创建一个截断的CTLine，该方法不能少，具体作用还有待研究
                CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
                
                if (!truncatedLine)
                {
                    // If the line is not as wide as the truncationToken, truncatedLine is NULL
                    truncatedLine = CFRetain(truncationToken);
                }
                
                CFRelease(truncationLine);
                CFRelease(truncationToken);
                
                CTLineDraw(truncatedLine, context);
                CFRelease(truncatedLine);
                break;
            } else{
                if (frameY < 0) {//当前行显示不下
                    break;
                }
                // 这一行刚好是最后一行，且最后一行的字符可以完全绘制出来
                CTLineDraw(line, context);
            }
            frameY = frameY - lineDescent;
        }
        CFRelease(frame);
        CFRelease(path);
        CFRelease(framesetter);
    }
    /* Restore the current graphics state from the one on the top of the
     graphics state stack, popping the graphics state stack in the process. */
    CGContextRestoreGState(context);
}

- (void)drawTextInRect:(CGRect)textRect AttributedString:(NSAttributedString *)attr numberOfLine:(NSUInteger)numberOfLine{
    //异步绘制文字
    __weak typeof(self)weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("com.huiaj.drawtext", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        // 开始上下文，下面不使用时一定要关闭，从上下文栈中移除
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO
                                               ,[UIScreen mainScreen].scale);
        [weakSelf drawAttributedText:attr textRange:NSMakeRange(0, attr.length) inRect:textRect numberOfLine:numberOfLine];
        //渲染成一张图
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程渲染到layer上
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            weakSelf.contents = (id)image.CGImage;
            [CATransaction commit];
        });
    });
}

- (void)drawTextInRect:(CGRect)textRect AttributedString:(NSAttributedString *)attr{
    [self drawTextInRect:textRect AttributedString:attr numberOfLine:0];
}

- (void)drawTextInRect:(CGRect)textRect bgImgName:(NSString *)bgImgName AttributedString:(NSAttributedString *)attr{
    
    //异步绘制文字
    __weak typeof(self)weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("com.ZCText.drawtext", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        // 开始上下文，下面不使用时一定要关闭，从上下文栈中移除
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO
                                               ,[UIScreen mainScreen].scale);
        [weakSelf drawImage:[UIImage imageNamed:bgImgName] inRect:textRect];
        [weakSelf drawAttributedText:attr textRange:NSMakeRange(0, attr.length) inRect:textRect numberOfLine:0];
        //渲染成一张图
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程渲染到layer上
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            weakSelf.contents = (id)image.CGImage;
            [CATransaction commit];
        });
    });
}


-(void)drawImageInRect:(CGRect)imageRect imageName:(NSString *)imageName{
    __weak typeof(self)weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("com.ZCText.drawimg", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        // 开始上下文，下面不使用时一定要关闭，从上下文栈中移除
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO
                                               ,[UIScreen mainScreen].scale);
        [weakSelf drawImage:[UIImage imageNamed:imageName] inRect:imageRect];
        //渲染成一张图
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程渲染到layer上
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            weakSelf.contents = (id)image.CGImage;
            [CATransaction commit];
        });
    });
    
}

-(void)drawImageInRect:(CGRect)imageRect image:(UIImage *)image{
    __weak typeof(self)weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("com.ZCText.drawimg", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        // 开始上下文，下面不使用时一定要关闭，从上下文栈中移除
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO
                                               ,[UIScreen mainScreen].scale);
        [weakSelf drawImage:image inRect:imageRect];
        //渲染成一张图
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程渲染到layer上
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            weakSelf.contents = (id)image.CGImage;
            [CATransaction commit];
        });
    });
}


- (void)drawImage:(UIImage *)image inRect:(CGRect)rect{
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    //翻转起来---上下颠倒
    CGContextTranslateCTM(ctx, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds));
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    ////假设想在10,30,80,80的地方绘制,颠倒过来后的Rect应该是 10, self.bounds.size.height - 80 - 30, 80, 80
    CGContextDrawImage(ctx, CGRectMake(rect.origin.x, self.bounds.size.height - rect.size.height -  rect.origin.y, rect.size.width, rect.size.height), image.CGImage);
    CGContextRestoreGState(ctx);
}



- (CGSize)sizeWithConstrainedToWidth:(float)width attributedString:(NSAttributedString *)attributedString{
    return [self sizeWithConstrainedToSize:CGSizeMake(width, CGFLOAT_MAX) attributedString:attributedString];
}

- (CGSize)sizeWithConstrainedToSize:(CGSize)size attributedString:(NSAttributedString *)string {
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)string;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGSize result = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [string length]), NULL, size, NULL);
    CFRelease(framesetter);
    string = nil;
    return result;
}

@end
