//
//  EPPageStatesControl.m
//  TaoChongYouPin
//
//  Created by 汪伟 on 2017/11/4.
//  Copyright © 2017年 FusionHK. All rights reserved.
//

#import "EPPageStatesControl.h"

@implementation EPPageStatesControl
-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    activeImage = [UIImage imageWithColor:[UIColor whiteColor]];
    inactiveImage = [UIImage imageWithColor:[UIColor grayColor]];
    
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) dot.image = activeImage;
        else dot.image = inactiveImage;
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    //修改图标大小
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        
        CGSize size;
        
        size.height = 10;
        
        size.width = 20;
        
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     
                                     size.width,size.height)];
        
    }
    
    
    [self updateDots];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
