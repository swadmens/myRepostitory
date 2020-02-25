//
//  RefreshControlView.h
//  
//
//  Created by icash on 16/5/19.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshControlView : UIView

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat triggerHeight;

///
@property (nonatomic) BOOL isLoading;

@end
