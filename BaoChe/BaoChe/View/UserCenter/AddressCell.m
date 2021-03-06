//
//  AddressCell.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/20.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "AddressCell.h"

@interface AddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation AddressCell

static CGFloat defaultCellHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureViewsProperties
{
    _contactLabel.textColor = Common_BlackColor;
    _mobilePhoneNumLabel.textColor = Common_GrayColor;
    _addressLabel.textColor = Common_GrayColor;
    
    // 分割线
    [self.contentView addLineWithPosition:ViewDrawLinePostionType_Bottom
                                lineColor:CellSeparatorColor
                                lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

////////////////////////////////////////////////////////////////////////////////

+ (CGFloat)getCellHeight
{
    if (0 == defaultCellHeight)
    {
        AddressCell *cell = [self loadFromNib];
        defaultCellHeight= cell.boundsHeight    ;
    }
    return defaultCellHeight;
}

@end
