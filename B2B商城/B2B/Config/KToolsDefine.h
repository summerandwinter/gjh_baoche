//
//  KToolsDefine.h
//  MuBan
//
//  Created by 龚 俊慧 on 15/11/13.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#ifndef KToolsDefine_h
#define KToolsDefine_h

// 设备相关
#define isIPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

// 判断设备型号
#define iPhone4                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS6                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) // 判断是否是IOS6的系统
#define IOS7                        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) // 判断是否是IOS7的系统

// 动态获取设备高度
#define IPHONE_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define IPHONE_WIDTH                [UIScreen mainScreen].bounds.size.width

// 设置颜色
#define HEXCOLOR(rgbValue)          [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 设置颜色与透明度
#define HEXCOLORAL(rgbValue, al)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

// block self
#define WEAKSELF                    typeof(self) __weak weakSelf = self;
#define STRONGSELF                  typeof(weakSelf) __strong strongSelf = weakSelf;

#define SharedAppDelegate           ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define JustWifiDefaultValue        ([[NSUserDefaults standardUserDefaults] boolForKey:UserDefault_JustWifiKey])
#define NoPictureModeDefaultValue   ([[NSUserDefaults standardUserDefaults] boolForKey:UserDefault_NoPictureModeKey])

// 无网络连接操作
#define NoNetworkConnectionAction   SimpleAlert(UIAlertViewStyleDefault, AlertTitle, NoConnectionNetwork, 1000, nil, nil, Confirm)

// 安全的对象
#define SafetyObject(obj)           ([obj isSafeObject] ? obj : nil)

// 以iPhone6为换算基数获得比例值
#define kGetScaleValueBaseIP6(__A)  (__A * IPHONE_WIDTH / 375)

// 系统版本号
#define APP_VERSION                 ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

// 应用名称
#define APP_NAME                    ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

/**
 * A helper macro to keep the interfaces compatiable with pre ARC compilers.
 * Useful when you put nimbus in a library and link it to a GCC LLVM compiler.
 */

// log
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// property keywords
#if defined(__has_feature) && __has_feature(objc_arc_weak)
#define NI_WEAK weak
#define NI_STRONG strong
#elif defined(__has_feature)  && __has_feature(objc_arc)
#define NI_WEAK unsafe_unretained
#define NI_STRONG retain
#else
#define NI_WEAK assign
#define NI_STRONG retain
#endif

// 单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__ = nil; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

// int转字符串
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
#define KKD_NSINETGER_2_NSSTRING(__value) [NSString stringWithFormat:@"%ld",__value]
#define KKD_INT(__value) ((NSInteger)__value)
#else
#define KKD_NSINETGER_2_NSSTRING(__value) [NSString stringWithFormat:@"%d",__value]
#define KKD_INT(__value) (__value)
#endif

#endif /* KToolsDefine_h */
