//
//  LGXNavigationController.h
//  
//
//  Created by icash on 15-7-24.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UINavigationBar+Background.h"
#define kNavgationControllerWillPop      @"_kNavgationControllerWillPopout"
#define kNavgationControllerWillPush     @"_kNavgationControllerWillPushin"



@interface LGXNavigationController : UINavigationController


@property (nonatomic, assign) BOOL asChild;

@property (nonatomic, assign) CGSize childSize;

//- (void)setNavigationBarAppearance;

- (void)layoutSubviewsFrame;

@end
