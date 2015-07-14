//
//  Const.h
//  mystock
//
//  Created by Ryan on 14-5-19.
//  Copyright 2014年 Ryan. All rights reserved.
//


////*******************************************
////*******************************************
////调试开关 //For test Only    Release版本一定要关闭本开关，切记切记！！！！！！！！！！！！！！
#define DEBUG_LOG
//#define DEBUG_TEST
////*******************************************//
////*******************************************//


#ifdef DEBUG_LOG
#define DMLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DMLog(...) do { } while (0)
#endif

#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9) ? 1 : 0)


#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define VIEW_HEIGHT SCREEN_HEIGHT - 20
#define VIEW_WIDTH_HORIZONTAL SCREEN_HEIGHT
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define VIEW_HEIGHT_HORIZONTAL SCREEN_WIDTH - 20
#define VIEW_WIDTH SCREEN_WIDTH

//api url
#ifdef DEBUG_TEST
#define apiHost             @"http://192.168.2.5/api_call.php?"   //For test Only
#else
#define apiHost             @"http://www.hkebuyer.com/stock/api_call.php?"
#endif


#ifndef IOS_VERSION
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] 
#endif

#define kDocumentDir                        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kDBFileName                         @"stock.db"
#define kDBFilePath                         [kDocumentDir stringByAppendingPathComponent:kDBFileName]

//搜索存储
#define SEARCH_FILEPATH  [kDocumentDir stringByAppendingPathComponent:@"search_history"]

//判断iOS版本
#define SYSTEM_VERSION_GREATER_THAN(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define kNetworkErrorMessage                @"网络不给力，请稍候重试"

#define HEI_(xx) [UIFont boldSystemFontOfSize:xx]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 基本色值
#define BACKGROUND_COLOR                    RGBCOLOR(16, 20, 25)
#define NAVI_COLOR                          RGBCOLOR(29, 34, 39)
#define BLUE_COLOR                          RGBCOLOR(69, 99, 129)
#define TITLE_BLUE_COLOR                    RGBCOLOR(22, 119, 236)
#define RED_COLOR                           RGBCOLOR(166, 51, 20)  //大红
#define DARK_GREEN_COLOR                    RGBCOLOR(40, 115, 40)  //深绿

#define kAppDelegate \
((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kSArray \
[(AppDelegate *)[[UIApplication sharedApplication] delegate] sArray]

// 消息通知
#define kNotificationOpenDrawer             @"open_drawer"
#define kNotificationRefreshSelection       @"refresh_selection"
// ==========================================================================================================

//正在获取位置
#define kDefaultLocationDesc                @"当前位置"

#pragma mark - notifaction
#define kEventMyCollectionChanged           @"kEventMyCollectionChanged"

#define kDefaultLat                         39.913968913551543
#define kDefaultLon                         116.478278804781269
#define kDefaultLatitudeDelta               0.03
#define kDefaultLongitudeDelta              0.03
#define kInvalidLocation                    1000.000

//GPS
#define kGPSInterval                        5

#define kScreenWidth                        320
#define kScreenHeight                       SCREEN_HEIGHT
#define kLeftInterval                       10


//全局参数宏定义
//设置参数
#define kSettingResultsHelper \
[kAppDelegate settingResultHelper]

//历史数据类
#define kHistoryStoreHelper \
[kAppDelegate historyStoreHelper]

#define KRANDOM(x) (rand()%x)




#define PLACEHOLDER_COLOR	RGBCOLOR(150, 150, 150)
//基础页面的背景色值
#define BASE_PAGE_BG_COLOR      RGBACOLOR(238, 238, 238, 1.0)
//基础咖啡色字体色值
#define BASE_COFFEE_TEXT_COLOR  RGBCOLOR(120, 85, 60)
//浅咖色字体色值
#define LIGHT_COFFEE_TEXT_COLOR RGBCOLOR(170, 150, 130)
//桔红色字体色值
#define BASE_ORANGE_TEXT_COLOR  RGBCOLOR(240, 100, 60)

//绿色字体色值
#define BASE_GREEN_TEXT_COLOR  RGBCOLOR(0, 153, 0)
//副标题的浅灰字体色值
#define BASE_LIGHTGREY_TEXT_COLOR  RGBCOLOR(136, 136, 136)

//论坛中分割线的色值
#define LUNTAN_LINE_COLOR           RGBCOLOR(220, 220, 220)
#define LUNTAN_REPLY_LINE_COLOR     RGBCOLOR(244, 244, 240)

//论坛中字体的颜色
#define LUNTAN_WORD_COLOR           RGBCOLOR(72,206,29)


typedef struct
{
	double lat;
	double lon;
} GPoint;


//用于异步请求返回时判断
#define kRequestDeviceToken                 9999

//基础URL
#define kBaseURL \
[NSString stringWithFormat:@"%@uuid=%@&via=%@&cver=%@&version=%@&app=%@&pid=%@&sdk=%@&token=%@",apiHost,kUDID,kVia,kClientVersion,kServerVersion,kApp,kPid,kBuildForSDK,kToken]

#define kLoginConnectionErrorMessage		@"网络问题，请稍候重试"

//上传device token
#define UPLOAD_DEVICETOKEN(xx_devicetoken) \
[NSString stringWithFormat:@"%@&m=device_token&device_token=%@", kBaseURL,xx_devicetoken]

