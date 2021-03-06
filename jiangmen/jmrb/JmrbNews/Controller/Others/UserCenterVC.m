//
//  UserCenterVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/24.
//
//

#import "UserCenterVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "UserInfoModel.h"
#import "CommonEntity.h"
#import "UserInfoModel.h"
#import "ModifyUserInfoVC.h"
#import "ModifyPasswordVC.h"
#import "NetRequestManager.h"

static NSString * const userNameDescStr = @"用户名: ";
static NSString * const genderDescStr = @"性   别: ";
static NSString * const mobilePhoneDescStr = @"手机号: ";

@interface UserCenterVC ()
{
    NSMutableArray *_tabTitleArray;
    NSMutableArray *_tabImageArray;
    
    UserEntity  *_userEntity;
    UIButton    *_userHeaderImageBtn;
}

@end

@implementation UserCenterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                            barButtonTitle:Cancel
                                    action:@selector(backViewController)];
    
    [self getLocalTabShowData];
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getNetworkData];
    [_userHeaderImageBtn setRadius:50];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - custom methods

- (void)getLocalTabShowData
{
    NSArray *oneSectionTitleArray = @[userNameDescStr, genderDescStr, mobilePhoneDescStr];
    NSArray *oneSectionImageArray = @[@"yonghuming", @"xingbie",@"shoujihaoma"];
    
    NSArray *twoSectionTitleArray = @[@"修改资料", @"修改密码"];
    NSArray *twoSectionImageArray = @[@"xiugaiziliao", @"xiugaimima"];
    
    NSArray *threeSectionTitleArray = @[@"退出"];
    NSArray *threeSectionImageArray = @[@"tuichu"];
    
    _tabTitleArray = [NSMutableArray arrayWithObjects:oneSectionTitleArray, twoSectionTitleArray, threeSectionTitleArray, nil];
    _tabImageArray = [NSMutableArray arrayWithObjects:oneSectionImageArray, twoSectionImageArray, threeSectionImageArray, nil];
}

- (void)updateTabShowData
{
    NSString *userNameStr = [NSString stringWithFormat:@"%@%@",userNameDescStr, _userEntity.userNameStr];
    NSString *genderStr = [NSString stringWithFormat:@"%@%@",genderDescStr, _userEntity.genderStr];
    NSString *mobilePhoneStr = [NSString stringWithFormat:@"%@%@",mobilePhoneDescStr, _userEntity.userMobilePhoneStr];
    
    [_tabTitleArray replaceObjectAtIndex:0 withObject:@[userNameStr, genderStr, mobilePhoneStr]];
    
    [_userHeaderImageBtn gjh_setBackgroundImageWithURL:[NSURL URLWithString:_userEntity.userHeaderImageUrlStr]
                                      placeholderImage:[UIImage imageNamed:@"weidenglutouxiang"]
                                               success:nil
                                               failure:nil];
    
    [_tableView reloadData];
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"个人中心"];
}

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetUserCenterRequestType_GetUserInfo == request.tag)
        {
            [strongSelf parseNetDataWithDic:successInfoObj];
            [strongSelf updateTabShowData];
        }
    }];
}

- (void)getNetworkData
{
    [self sendRequest:[[self class] getRequestURLStr:NetUserCenterRequestType_GetUserInfo]
         parameterDic:@{@"userPhone": [UserInfoModel getUserDefaultMobilePhoneNum]}
           requestTag:NetUserCenterRequestType_GetUserInfo];
}

- (void)initialization
{
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStyleGrouped
                  registerNibName:nil
                  reuseIdentifier:nil];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // tab header view
    UIView *bgView = InsertView(nil, CGRectMake(0, 0, _tableView.boundsWidth, 180));
    bgView.backgroundColor = [UIColor clearColor];
    
    _userHeaderImageBtn = InsertImageButton(bgView, CGRectZero, 1000, [UIImage imageNamed:@"weidenglutouxiang"], nil, self, @selector(clickUserHeaderImagBtn:));
    [_userHeaderImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView).offset(@20);
    }];

    UILabel *label = InsertLabel(bgView,
                                 CGRectZero,
                                 NSTextAlignmentCenter,
                                 @"我的头像",
                                 SP15Font,
                                 Common_BlackColor,
                                 NO);
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_userHeaderImageBtn);
        make.top.equalTo(_userHeaderImageBtn.mas_bottom).offset(@10);
    }];
    
    _tableView.tableHeaderView = bgView;
}

- (void)clickUserHeaderImagBtn:(UIButton *)sender
{
    WEAKSELF
    [self pickSinglePhotoFromCameraOrAlbumByIsCropped:YES cancelHandle:^{
        
    } finishPickingHandle:^(NSArray *pickedImageArray) {
        STRONGSELF
        if ([pickedImageArray isAbsoluteValid])
        {
            UIImage *image = pickedImageArray[0];
            [strongSelf->_userHeaderImageBtn setBackgroundImage:image forState:UIControlStateNormal];
            
            /*
             userName ：用户名
             userPassword  ：密码
             file:用户的头像<file 形式>
             */
            // 发送请求
            
            NSData *imgData = UIImageJPEGRepresentation(image, 0.2);
            NSString *imageName = [NSString stringWithFormat:@"%@.png",[NSDate stringFromDate:[NSDate date] withFormatter:DataFormatter_DateAndTime]];
            NSString *savePaht = GetTmpPathFileName(imageName);
            
            [imgData writeToFile:savePaht atomically:NO];
            
            NSURL *url = [UrlManager getRequestUrlByMethodName:[[self class] getRequestURLStr:NetUserCenterRequestType_UpdateUserHeaderImage]];
            
            [[NetRequestManager sharedInstance] sendUploadRequest:url parameterDic:@{@"userName": [UserInfoModel getUserDefaultLoginName], @"userPassword": [UserInfoModel getUserDefaultPassword]} requestMethodType:RequestMethodType_POST requestTag:NetUserCenterRequestType_UpdateUserHeaderImage delegate:self fileDic:@{@"file": savePaht}];
        }
    }];
}

- (void)parseNetDataWithDic:(NSDictionary *)dic
{
    _networkDataDic = [dic objectForKey:@"response"];
    NSArray *itemList = [_networkDataDic objectForKey:@"item"];
    
    if ([itemList isAbsoluteValid])
    {
        NSDictionary *itemDic = itemList[0];
        
        _userEntity = [UserEntity initWithDict:itemDic];
    }
}

- (NSString *)curTitleWithIndex:(NSIndexPath *)indexPath
{
    NSArray *sectionTitleArray = _tabTitleArray[indexPath.section];
    return sectionTitleArray[indexPath.row];
}

- (NSString *)curImageNameWithIndex:(NSIndexPath *)indexPath
{
    NSArray *sectionImageNameArray = _tabImageArray[indexPath.section];
    return sectionImageNameArray[indexPath.row];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tabTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionTitleArray = _tabTitleArray[section];
    
    return sectionTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.backgroundColor = CellBackgroundColor;
        cell.textLabel.font = SP14Font;
        cell.textLabel.textColor = Common_BlackColor;
        
        if (1 == indexPath.section)
        {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiantou_cell"]];
        }
    }
    
    cell.imageView.image = [UIImage imageNamed:[self curImageNameWithIndex:indexPath]];
    cell.textLabel.text = [self curTitleWithIndex:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            ModifyUserInfoVC *modifyUserInfo = [ModifyUserInfoVC loadFromNib];
            modifyUserInfo.userEntity = _userEntity;
            [self pushViewController:modifyUserInfo];
        }
        else if (1 == indexPath.section)
        {
            ModifyPasswordVC *modifyPassword = [ModifyPasswordVC loadFromNib];
            [self pushViewController:modifyPassword];
        }
            
    }
    else if (2 == indexPath.section)
    {
        [UserInfoModel setUserDefaultLoginName:nil];
        [UserInfoModel setUserDefaultPassword:nil];
        
        [UserInfoModel setUserDefaultUserId:nil];
        [UserInfoModel setUserDefaultMobilePhoneNum:nil];
        
        [self backViewController];
    }
}

#pragma mark - custom methods

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [super netRequest:request successWithInfoObj:infoObj];
    
    if (NetUserCenterRequestType_UpdateUserHeaderImage == request.tag)
    {
        [self getNetworkData];
    }
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [super netRequest:request failedWithError:error];
}

@end
