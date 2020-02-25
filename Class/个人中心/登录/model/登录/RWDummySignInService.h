//
//  RWDummySignInService.h
//  YanGang
//
//  Created by 汪伟 on 2018/11/14.
//  Copyright © 2018 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RWSignInResponse)(BOOL);

NS_ASSUME_NONNULL_BEGIN

  
@interface RWDummySignInService : NSObject
  
- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                  complete:(RWSignInResponse)completeBlock;
                   
@end

NS_ASSUME_NONNULL_END
