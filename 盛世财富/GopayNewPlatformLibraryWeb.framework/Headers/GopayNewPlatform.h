//
//  GopayNewPlatform.h
//  GopayNewPlatformLibraryWeb
//
//  Created by Gopay_y on 14/12/26.
//  Copyright (c) 2014年 Gopay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GopayNewPlatformDelegate;
@interface GopayNewPlatform : NSObject

@property(weak ,nonatomic)id<GopayNewPlatformDelegate> delegate;

/**
 *  获取国付宝插件标识符
 */
+(NSString *)getGopayIdentifierForPayment;

/**
 *  通过调用该方法来进入国付宝页面
 *
 *  @param parameters 需要传入的参数
 */
- (void)startGopayWithParameters:(NSDictionary *)parameters;


@end

@protocol GopayNewPlatformDelegate <NSObject>

-(void)gopayDidClosed;

@end