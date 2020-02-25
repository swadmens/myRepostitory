//
//  WWAssetModel.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWAssetModel.h"
#import "UIImage+loadImage.h"

@implementation WWAssetModel
+ (WWAssetModel *)photoModelWithAsset:(ALAsset *)asset
{
    WWAssetModel * model = [[WWAssetModel alloc] init];
    
    
    ALAssetRepresentation *defaultRepresentation = asset.defaultRepresentation;
    model.photoName = defaultRepresentation.filename;
    
    /// 下面是原图的获取方法，有点大。要自己转方向
    /*
     aPhotoObj.fullPhoto = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
     scale:asset.defaultRepresentation.scale
     orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
     */
    UIImage *image = [UIImage fullSizeImageForAssetRepresentation:defaultRepresentation];
    model.fullPhoto = image;
    model.photoSize = image.size;
    
    model.photoPath = defaultRepresentation.url; //model.photoPath = [asset valueForProperty:ALAssetPropertyAssetURL];
    model.thumbPhoto = [UIImage imageWithCGImage:asset.thumbnail];
    model.smallSize = model.thumbPhoto.size;
    
    return model;
}
@end
