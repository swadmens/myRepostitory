//
//  UIImage+loadImage.m
//  GutouV3
//
//  Created by icash on 15-10-13.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import "UIImage+loadImage.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (loadImage)

+ (UIImage *)imageWithALAsset:(ALAsset *)asset
{
    UIImage *tmpImage = [UIImage fullSizeImageForAssetRepresentation:asset.defaultRepresentation];
    
    return tmpImage;
}

/// 解决fullscreenimage 的内存释放问题。
+ (UIImage *)fullSizeImageForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation
{
    UIImage *result = nil;
    
    
    CGSize dimensions = assetRepresentation.dimensions;
    CGFloat finalSize = MAX(dimensions.width, dimensions.height);
    if (CGSizeEqualToSize(dimensions, CGSizeZero)) {
        // assetRepresentation.fullScreenImage 的大小，是当前屏幕像素的大小的最大值
        CGSize msize = [UIScreen mainScreen].bounds.size;
        CGFloat size = MAX(msize.width, msize.height);
        CGFloat screenSize = size * [UIScreen mainScreen].scale;
        finalSize = MAX(finalSize, screenSize);
        finalSize = MIN(finalSize, 1920);
    }
    
    result = [UIImage imageThumbnailFromAsset:assetRepresentation maxPixelSize:finalSize];
    return result;
}
/// 第一种方法
+ (UIImage *)imageThumbnailFromAsset:(ALAssetRepresentation *)assetRepresentation maxPixelSize:(NSUInteger)size
{
    UIImage *result = nil;
    NSData *data = nil;
    
    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t)*[assetRepresentation size]);
    if (buffer != NULL) {
        NSError *error = nil;
        NSUInteger bytesRead = [assetRepresentation getBytes:buffer fromOffset:0 length:[assetRepresentation size] error:&error];
        data = [NSData dataWithBytes:buffer length:bytesRead];
        free(buffer);
    }
    
    if ([data length])
    {
        CGImageRef myThumbnailImage = MyCreateThumbnailImageFromData(data, (int)size);
        if (myThumbnailImage) {
            result = [UIImage imageWithCGImage:myThumbnailImage];
            CGImageRelease(myThumbnailImage); // 30.48
            /*
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = paths.firstObject;
            
            NSString *finalPath = [NSString stringWithFormat:@"%@/%@ -1.jpg",cachePath,assetRepresentation.filename];
            [[NSFileManager defaultManager] createFileAtPath:finalPath contents:UIImagePNGRepresentation(result) attributes:nil];

            NSData *finalData = UIImageJPEGRepresentation(result, 0.6); // 压缩一次
            NSString *finalPath2 = [NSString stringWithFormat:@"%@/%@ -3.jpg",cachePath,assetRepresentation.filename];
            [[NSFileManager defaultManager] createFileAtPath:finalPath2 contents:finalData attributes:nil];
            */
            /// 12.4M 压缩1.0是5.4M；压缩0.6后是1M
            /// 11.9M 压缩1.0是4.9M；压缩0.6后是807KB
            /*
                4 4s 5 5s 6 6s 
                以iphone6上面尺寸算是0.6压缩。最大也定为此，
                计算其他屏幕上的压缩
             }
             */
            float xishu = 0.5;
            float maxXiShu = (xishu*[UIScreen mainScreen].bounds.size.height)/667.0;
            xishu = MIN(maxXiShu, xishu); // 取最小
            NSData *finalData = UIImageJPEGRepresentation(result, xishu); // 压缩一次
            result = [UIImage imageWithData:finalData];
        }
    }
    
    return result;
}

CGImageRef MyCreateThumbnailImageFromData (NSData * data, int imageSize)
{    
    CGImageRef        myThumbnailImage = NULL;
    CGImageSourceRef  myImageSource;
    CFDictionaryRef   myOptions = NULL;
    
    // Create an image source from NSData; no options.
    myImageSource = CGImageSourceCreateWithData((CFDataRef)data,
                                                NULL);
    // Make sure the image source exists before continuing.
    if (myImageSource == NULL){
        fprintf(stderr, "Image source is NULL.");
        return  NULL;
    }

    myOptions = (__bridge CFDictionaryRef) @{
                                             (id)kCGImageSourceCreateThumbnailFromImageAlways : (id)kCFBooleanTrue,
                                             (id)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInteger:imageSize],
                                             (id)kCGImageSourceCreateThumbnailWithTransform : (id)kCFBooleanTrue,
                                             (id)kCGImageSourceShouldCache : (id)kCFBooleanFalse,
                                             (id)kCGImageSourceShouldCacheImmediately : (id)kCFBooleanFalse,
                                             };
    
    // Create the thumbnail image using the specified options.
    myThumbnailImage = CGImageSourceCreateThumbnailAtIndex(myImageSource,
                                                           0,
                                                           myOptions);
    // Release the options dictionary and the image source
    // when you no longer need them.
    if (myImageSource)
        CFRelease(myImageSource);
    // Make sure the thumbnail image exists before continuing.
    if (myThumbnailImage == NULL){
        fprintf(stderr, "Thumbnail image not created from image source.");
        return NULL;
    }
    
    return myThumbnailImage;
}

@end




