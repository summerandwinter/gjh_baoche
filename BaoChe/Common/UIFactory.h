//
//  UIFactory.h
//
//  Created by zzc on 12-3-30.
//  Copyright (c) 2012年 Twin-Fish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface UIFactory : NSObject <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

AS_SINGLETON(UIFactory);

#pragma mark - Common Function

+ (BOOL)isValidIPAddress:(NSString *)address;                   //校验IP
+ (BOOL)isValidPortAddress:(NSString *)address;                 //校验Port
+ (BOOL)isRetina;                                               //是否Retina屏
+ (float)getSystemVersion;                                      //获得系统版本

+ (NSString *)getDeviceTokenFromData:(NSData *)deviceToken;     //获取APNS设备令牌

+ (void)showAppCommentWithAppID:(int)appID;                     //显示AppStore应用评论
+ (void)invokeVibration;                                        //震动
+ (void)call:(NSString *)telephoneNum;                          //拨打电话
- (void)sendSMS:(NSString *)telephoneNum;                       //发送短信
- (void)sendEmail:(NSString *)emailAddr;                        //发送邮件
+ (void)openUrl:(NSString *)url;                                //打开网页

/// 本地通知
+ (BOOL)isRegisteredForLocalNotifications;
+ (BOOL)addLocalNotificationWithFireDate:(NSDate *)fireDate
                            alertBodyStr:(NSString *)alertBody
                          alertActionStr:(NSString *)alertAction;

/// 清空通知数字显示
+ (void)clearApplicationBadgeNumber;

+ (NSStringEncoding)getGBKEncoding;                             //获得中文gbk编码

/*
+ (NSData *)useAES256Encrypt:(NSString *)plainText;             //加密
+ (NSString *)useAES256Decrypt:(NSData *)cipherData;            //解密
 */

@end





