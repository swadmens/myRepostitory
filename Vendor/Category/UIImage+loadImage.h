//
//  UIImage+loadImage.h
//  GutouV3
//
//  Created by icash on 15-10-13.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (loadImage)

+ (UIImage *)imageWithALAsset:(ALAsset *)asset;
+ (UIImage *)fullSizeImageForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation;
CGImageRef MyCreateThumbnailImageFromData (NSData * data, int imageSize);

@end
