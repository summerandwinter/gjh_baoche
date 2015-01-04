//
//  SettlementView.m
//  BaoChe
//
//  Created by 龚 俊慧 on 15/1/4.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "SettlementView.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"

@interface SettlementView ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *settlementBtn;

@end

@implementation SettlementView

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    [self addLineWithPosition:ViewDrawLinePostionType_Top
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
    
    _settlementBtn.backgroundColor = Common_ThemeColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickSettlementBtn:(UIButton *)sender
{
    if (_operationHandle) _operationHandle(self, SettlementViewOperationType_Settlement, sender);
}

- (void)setSettlementPrice:(double)price count:(NSInteger)count
{
    NSString *priceStr = [NSString stringWithFormat:@"总价: ￥%.2f", price];
    NSString *countStr = [NSString stringWithFormat:@"(%d张)", count];
    NSString *settlementStr = [NSString stringWithFormat:@"%@ %@", priceStr, countStr];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:settlementStr];
    [attributedStr setTextColor:Common_RedColor range:[settlementStr rangeOfString:priceStr]];
    [attributedStr setFont:SP18Font range:[settlementStr rangeOfString:priceStr]];
    [attributedStr setTextColor:Common_GrayColor range:[settlementStr rangeOfString:countStr]];
    [attributedStr setFont:SP15Font range:[settlementStr rangeOfString:countStr]];
    
    _priceLabel.attributedText = attributedStr;
}

@end
