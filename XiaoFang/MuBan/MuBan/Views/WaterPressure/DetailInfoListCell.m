//
//  DetailInfoListCell.m
//  MuBan
//
//  Created by 龚 俊慧 on 15/7/24.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "DetailInfoListCell.h"

@interface DetailInfoListCell ()

@property (weak, nonatomic) IBOutlet UIButton *valueBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;

@end

@implementation DetailInfoListCell

- (void)awakeFromNib {
    // Initialization code
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    [_valueBtn setTitleColor:Common_LiteBlueColor forState:UIControlStateNormal];
    
    CGFloat width = (IPHONE_WIDTH - 80) / 2;
    
    [_collectTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
    [_noteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
    }];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

+ (CGFloat)getCellHeight
{
    return 30;
}

- (void)loadDataWithShowEntity:(WaterPressureDetail_CollectListEntity *)entity
{
    [_valueBtn setTitle:[NSString stringWithFormat:@"%.2f", entity.value.floatValue] forState:UIControlStateNormal];
    [_collectTimeBtn setTitle:entity.collectTime forState:UIControlStateNormal];
    [_noteBtn setTitle:entity.note forState:UIControlStateNormal];
}

@end
