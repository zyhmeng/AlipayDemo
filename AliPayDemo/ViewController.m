//
//  ViewController.m
//  AliPayDemo
//
//  Created by zyh on 15/12/1.
//  Copyright © 2015年 zyh. All rights reserved.
//

#import "ViewController.h"
#import "AliOrder.h"

#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    
    return resultStr;
}

- (void)alipay:(AliOrder *)order success:(void(^)(NSString *str))success
                        failure:(void(^)(NSString *error))failure
{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOyzGCdwl8k3yF4fdyJRe6tYiFcH+ILV/av53xY20zcygy0cQij85w1obEbRnkui5MeB4Uzw5iFocSguApsQDNsmfyshuZUCrxNztzetLOZbyzkXDmmh0oMb8/cU1EB6TDfNTh8h6xqTKHdpbxwK9ByCevLr80wKOVL+AerAbbJpAgMBAAECgYABAQl7MVkTe28YJx4EQUA7C9cYN2pwc6Pt1NODbpwawdYYnOQS9G+ueODss/rt6zT5O63O+76eKalBOGC+c6T6TurL4fADqSauaaHc4rbFvPdMH9tD9ZSMwrEhdXVKsfv3FSpWayj6CqB3MC3Cvy2XYSDRnq5PJa2ayojjiducOQJBAPot26EdPtsQdGgd2sYwnHmfacR5Q8V/2vsJDtMHdtzT4Ntejv66fxnY3dyzgp7mFXxBGlEPbY26EefHdjXvrZ8CQQDyNPK9e44s1G7fJNtzRYqVtO9pPsGg6zTMTGFEys33G0VUFMfaE9/7m0froPZ8UahvBZbDeTUPJJPWEAcxCBL3AkADBQCsniS/EiDFjO6yC64nzaPCKlCGFrf25bIXG/T0T15cZ3TEYE3eav6qhkQiVNaXjFWb+tqwpjlHGeI0XnMzAkBW9d+5XGUdf2AXSfpolq09NutGVDvc9NXODBZYRqBQekAYAiYHDF+8zHG0DeSxmffpdI4+vIPqXe2eS77pQcbdAkEA7iyWIXxwhxNcRfu4URzwg2UNOTzSFnheHW98Oxo8T8qOIPEUXaI0CzPIISPrsUJy9OHqAH2BmNN53VPS/5whHg==";
        
    //partner和seller获取失败,提示
    if([privateKey length] == 0)
    {
        NSString *error = @"privateKey的值为空";
        failure(error);
        return;
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSNumber *resultStatus = [resultDic objectForKey:@"resultStatus"];
            
            if (resultStatus.intValue == 9000) {
                NSString *successStr = [resultDic objectForKey:@"result"];
                
                
                success(successStr);
                
            }else
            {
                failure(@"支付失败");
            }
            NSLog(@"reslut = %@",resultDic);
        }];
    }

}


- (IBAction)alipay:(id)sender {
    
    AliOrder *order = [[AliOrder alloc]initWithAlipayTradeNo:@"123456788988" productDescription:@"iphone6sp" productName:@"iphone6sp" amount:@"0.01"];
    
    [self alipay:order success:^(NSString *successStr) {
        
        NSLog(@"%@",successStr);
        
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}



@end
