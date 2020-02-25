//
//  WWAssetModel.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/4.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface WWAssetModel : NSObject
/// 照片名
@property (nonatomic, strong) NSString *photoName;
/// 相册路径
@property (nonatomic, strong) NSURL *photoPath;


/// 缩略图
@property (nonatomic, strong) UIImage *thumbPhoto;
/// 小图图片大小
@property (nonatomic) CGSize smallSize;

/// 大图
@property (nonatomic, strong) UIImage *fullPhoto;
/// 大图图片大小
@property (nonatomic) CGSize photoSize;

+ (WWAssetModel *)photoModelWithAsset:(ALAsset *)asset;

@end
