//
//  AliOrder.m
//  AlixPayDemo
//
//  Created by 方彬 on 11/2/13.
//
//

#import "AliOrder.h"

@implementation AliOrder

- (NSString *)description {
	NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
	if (self.tradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
    }
	if (self.productName) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
	
	if (self.productDescription) {
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
    }
	if (self.amount) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount];
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
	
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    if (self.rsaDate) {
        [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
    }
    if (self.appID) {
        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
    }
	for (NSString * key in [self.extraParams allKeys]) {
		[discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
	}
	return discription;
}

- (instancetype)initWithAlipayTradeNo:(NSString *)tradeNO productDescription:(NSString *)productDescription productName:(NSString *)productName amount:(NSString *)amount
{
    self = [super init];
    if (self) {
        //将商品信息赋予AlixPayOrder的成员变量
        NSString *partner = @"2088611881165043";
        NSString *seller = @"473276@qq.com";
        self.partner = partner;
        self.seller = seller;
        self.tradeNO = tradeNO; //订单ID（由商家自行制定）
        self.productName = productName; //商品标题
        self.productDescription = productDescription; //商品描述
        self.amount = [NSString stringWithFormat:@"%@",amount]; //商品价格
        self.notifyURL =  @"http://daping.api.yunfengapp.com:8888/Alipay/PayNotify.aspx"; //回调URL
        
        self.service = @"mobile.securitypay.pay";
        self.paymentType = @"1";
        self.inputCharset = @"utf-8";
        self.itBPay = @"30m";
        self.showUrl = @"m.alipay.com";
    }
    return self;
}
@end
