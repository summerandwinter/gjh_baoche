//
//  NewsManagerVC.m
//  JmrbNews
//
//  Created by swift on 14/12/2.
//
//

#import "NewsManagerVC.h"
#import "NewsVC.h"
#import "CommonEntity.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "LXActivity.h"
#import "SettingVC.h"
#import "LoginVC.h"
#import "MyMessageVC.h"
#import "UserInfoModel.h"
#import "LoginBC.h"
#import "UserCenterVC.h"
#import "ChannelEditVC.h"
#include <objc/runtime.h>

@interface NewsManagerVC () <SUNSlideSwitchViewDelegate, LXActivityDelegate>
{
    NSMutableArray *_netNewsTypeEntityArray;
    
    NSMutableArray *_newsViewControllersArray;
    
    LoginBC        *_loginBC;
}

@end

@implementation NewsManagerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _loginBC = [[LoginBC alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    if ([UserInfoModel getUserDefaultSelectedNewsTypesArray])
    {
        [self initialization];
    }
    else
    {
        [self getNetworkData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)autoLogin
{
    if ([[UserInfoModel getUserDefaultLoginName] isAbsoluteValid] && [[UserInfoModel getUserDefaultPassword] isAbsoluteValid])
    {
        [_loginBC loginWithUserName:[UserInfoModel getUserDefaultLoginName]
                           password:[UserInfoModel getUserDefaultPassword]
                          autoLogin:YES
                      successHandle:^(id successInfoObj) {
                          
                      } failedHandle:^(NSError *error) {
                          
                      }];
    }
}

- (void)setPageLocalizableText
{
    [self autoLogin];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetNewsRequestType_GetAllNewsType == request.tag)
        {
            [strongSelf parseNetDataWithDic:successInfoObj];
            
            [strongSelf setupNewsTypeUserDefaultData];
        }
    }];
}

- (void)getNetworkData
{
    [self sendRequest:[[self class] getRequestURLStr:NetNewsRequestType_GetAllNewsType]
         parameterDic:nil
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetNewsRequestType_GetAllNewsType
             delegate:self
             userInfo:nil
       netCachePolicy:NetAskServerIfModifiedWhenStaleCachePolicy
         cacheSeconds:CacheNetDataTimeType_OneWeek];
    ;
}

- (void)parseNetDataWithDic:(NSDictionary *)dic
{
    NSArray *newsTypeItemList = [[dic objectForKey:@"response"] objectForKey:@"item"];
    
    if ([newsTypeItemList isAbsoluteValid])
    {
        _netNewsTypeEntityArray = [NSMutableArray arrayWithCapacity:newsTypeItemList.count];
        
        for (NSDictionary *newsTypeItemDic in newsTypeItemList)
        {
            NewsTypeEntity *entity = [NewsTypeEntity initWithDict:newsTypeItemDic];
            [_netNewsTypeEntityArray addObject:entity];
        }
    }
}

- (void)setupNewsTypeUserDefaultData
{
    [UserInfoModel setUserDefaultSelectedNewsTypesArray:_netNewsTypeEntityArray];
    [self initialization];
}

- (void)initialization
{
    [self configureSlideSwitchView];
    [self configureRightItemBtn];
}

- (void)configureSlideSwitchView
{
    if (_slideSwitchView.superview)
    {
        [_slideSwitchView removeFromSuperview];
    }
    self.slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:self.view.bounds];
    [_slideSwitchView keepAutoresizingInFull];
    _slideSwitchView.slideSwitchViewDelegate = self;
    _slideSwitchView.tabItemNormalColor = HEXCOLOR(0X636363);
    _slideSwitchView.tabItemSelectedColor = HEXCOLOR(0X005BA5);
    _slideSwitchView.shadowImage = [UIImage imageWithColor:HEXCOLOR(0XE0E0E0) size:CGSizeMake(1, 1)];
    [self.view addSubview:_slideSwitchView];
    
    // 控制器
    _newsViewControllersArray = [NSMutableArray array];
    for (NewsTypeEntity *entity in [UserInfoModel getUserDefaultSelectedNewsTypesArray])
    {
        NewsVC *newsVC = [[NewsVC alloc] init];
        newsVC.newsTypeEntity = entity;
        
        [self addChildViewController:newsVC];
        [_newsViewControllersArray addObject:newsVC];
    }
    
    [self.slideSwitchView buildUI];
    
    self.navigationItem.titleView = _slideSwitchView.topScrollView;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)configureRightItemBtn
{
    /*
     [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right
     normalImg:[UIImage imageNamed:@"jiahao"]
     highlightedImg:nil
     action:@selector(operationMoreAction:)];
     */
    UIView *view = InsertView(nil, CGRectMake(0, 0, 36, 30));
    view.backgroundColor = [UIColor clearColor];
    
    InsertImageButton(view,
                     CGRectMake(6, 0, 30, view.boundsHeight), 1000,
                     [UIImage imageNamed:@"jiahao"],
                     nil,
                     self,
                     @selector(operationMoreAction:));
    InsertImageView(view,
                    CGRectMake(0, 0, 6, view.boundsHeight),
                    [UIImage imageNamed:@"yinyingxian"],
                    nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (void)operationMoreAction:(UIButton *)sender
{
    LXActivity *action = [[LXActivity alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         ShareButtonTitles:@[@"频道定制",
                                                             @"个人中心",
                                                             @"我的消息",
                                                             @"设置"]
                                 withShareButtonImagesName:@[@"pingdaodingzhi_normal",
                                                             @"gerenzhongxing_normal",
                                                             @"wodexiaoxi_normal",
                                                             @"shezhi_normal"]];
    [action showInView:self.view];
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return _newsViewControllersArray.count;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return _newsViewControllersArray[number];
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    NewsVC *newsVC = number < _newsViewControllersArray.count ? _newsViewControllersArray[number] : nil;
    
    [newsVC viewDidCurrentView];
}

#pragma mark - LXActivityDelegate methods

- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    switch (imageIndex) {
        case 0:
        {
            ChannelEditVC *channelEdit = [ChannelEditVC new];
            UINavigationController *channelEditNav = [[UINavigationController alloc] initWithRootViewController:channelEdit];
            objc_setAssociatedObject(channelEdit, class_getName([self class]), self, OBJC_ASSOCIATION_ASSIGN);
            [self presentViewController:channelEditNav
                   modalTransitionStyle:UIModalTransitionStyleCoverVertical
                             completion:nil];
        }
            break;
        case 1:
        {
            if ([UserInfoModel getUserDefaultMobilePhoneNum])
            {
                UserCenterVC *userCenter = [[UserCenterVC alloc] init];
                UINavigationController *userCenterNav = [[UINavigationController alloc] initWithRootViewController:userCenter];
                [self presentViewController:userCenterNav
                       modalTransitionStyle:UIModalTransitionStyleCoverVertical
                                 completion:nil];
            }
            else
            {
                LoginVC *login = [LoginVC loadFromNib];
                UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
                [self presentViewController:loginNav
                       modalTransitionStyle:UIModalTransitionStyleCoverVertical
                                 completion:nil];
            }
        }
            break;
        case 2:
        {
            MyMessageVC *myMessage = [MyMessageVC new];
            UINavigationController *myMessageNav = [[UINavigationController alloc] initWithRootViewController:myMessage];
            [self presentViewController:myMessageNav
                   modalTransitionStyle:UIModalTransitionStyleCoverVertical
                             completion:nil];
        }
            break;
        case 3:
        {
            SettingVC *setting = [[SettingVC alloc] init];
            UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:setting];
            [self presentViewController:settingNav
                   modalTransitionStyle:UIModalTransitionStyleCoverVertical
                             completion:nil];
        }
            break;
            
        default:
            break;
    }
}

@end
