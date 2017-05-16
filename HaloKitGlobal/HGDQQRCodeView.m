//
//  HGDQQRCodeView.m
//  HGDQQRCode
//
//  Created by myhg on 16/3/4.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "HGDQQRCodeView.h"
#import <CoreImage/CoreImage.h>

@implementation HGDQQRCodeView
/**
 *  生成带logo的二维码
 *  二维码和logo都是正方形的
 *  @param urlString     二维码中的链接
 *  @param QRCodeCGRect  二维码的CGRect
 *  @param logoImage     二维码中的logo
 *  @param logoImageSize logo的大小
 *  @param cornerRadius  logo的圆角值大小
 *
 *  @return 生成的二维码
 */
+ (HGDQQRCodeView *)creatQRCodeWithURLString:(NSString *)urlString superView:(UIView *)superView logoImage:(UIImage *)logoImage logoImageSize:(CGSize)logoImageSize logoImageWithCornerRadius:(CGFloat)cornerRadius{
    // 先移除子视图
    HGDQQRCodeView *oldQRCodeView = [superView viewWithTag:123];
    [oldQRCodeView removeFromSuperview];
    
    HGDQQRCodeView *QRCodeView = [[HGDQQRCodeView alloc] init];
    QRCodeView.tag = 123;
    QRCodeView.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
    CIImage *ciImage = [QRCodeView creatQRcodeWithUrlstring:urlString]; // 生成二维码
    UIImage *qrImage = [QRCodeView changeImageSizeWithCIImage:ciImage andSize:superView.frame.size.width]; // 改变二维码的大小
    if (logoImage != nil) {
        if (cornerRadius < 0) {
            cornerRadius = 0;
            NSLog(@"cornerRadius 不能小于0");
        }
        qrImage = [QRCodeView addImageToSuperImage:qrImage withSubImage:[QRCodeView imageWithCornerRadius:cornerRadius image:logoImage] andSubImagePosition:CGRectMake((superView.frame.size.width - logoImageSize.width)/2, (superView.frame.size.height - logoImageSize.height)/2, logoImageSize.width, logoImageSize.height)]; // 增加logo
    }
    QRCodeView.layer.contents = (__bridge id)qrImage.CGImage;
    [superView addSubview:QRCodeView];
    return QRCodeView;
}


/**
 *  根据字符串生成二维码 CIImage 对象
 *
 *  @param urlString 需要生成二维码的字符串
 *
 *  @return 生成的二维码
 */
- (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString{
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}
/**
 *  改变图片大小 (正方形图片)
 *
 *  @param ciImage 需要改变大小的CIImage 对象的图片
 *  @param size    图片大小 (正方形图片 只需要一个数)
 *
 *  @return 生成的目标图片
 */
- (UIImage *)changeImageSizeWithCIImage:(CIImage *)ciImage andSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}
/**
 *  图片增加水印
 *
 *  @param superImage 需要增加水印的图片
 *  @param subImage   水印图片
 *  @param posRect    水印的位置 和 水印的大小
 *
 *  @return 加水印后的新图片
 */
- (UIImage *)addImageToSuperImage:(UIImage *)superImage withSubImage:(UIImage *)subImage andSubImagePosition:(CGRect)posRect{
    
    UIGraphicsBeginImageContext(superImage.size);
    [superImage drawInRect:CGRectMake(0, 0, superImage.size.width, superImage.size.height)];
    //四个参数为水印图片的位置
    [subImage drawInRect:posRect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

/**
 *  图片设置圆角
 *
 *  @param cornerRadius 圆角值
 *  @param original     图片
 *
 *  @return 圆角图片
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius image:(UIImage *)image
{
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    // 画图
    [image drawInRect:frame];
    // 获取新的图片
    UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return im;
}
#pragma mark - 读取图片中的二维码
/**
 *  读取图片中的二维码
 *
 *  @param image 图片
 *
 *  @return 图片中的二维码数据集合 CIQRCodeFeature对象
 */
+ (NSArray *)readQRCodeFromImage:(UIImage *)image{
    // 创建一个CIImage对象
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
    // 注意这里的CIDetectorTypeQRCode
    NSArray *features = [detector featuresInImage:ciImage];
    NSLog(@"features = %@",features); // 识别后的结果集
    for (CIQRCodeFeature *feature in features) {
        NSLog(@"msg = %@",feature.messageString); // 打印二维码中的信息
    }
    return features;
}

/**
 *  截图
 *
 *  @param view 需要截取的视图
 *
 *  @return 截图 图片
 */
+ (UIImage *)screenShotFormView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
