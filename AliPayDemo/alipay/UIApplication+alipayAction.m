//
//  UIApplication+alipayAction.m
//  AliPayDemo
//
//  Created by zyh on 15/12/1.
//  Copyright © 2015年 zyh. All rights reserved.
//

#import "UIApplication+alipayAction.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliOrder.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"



@implementation UIApplication (alipayAction)

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    
    return YES;
}


@end