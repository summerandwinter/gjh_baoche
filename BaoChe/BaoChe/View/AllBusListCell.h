//
//  AllBusListCell.h
//  BaoChe
//
//  Created by swift on 14/12/14.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonEntity.h"

@interface AllBusListCell : UITableViewCell

+ (CGFloat)getCellHeight;
- (void)loadCellShowDataWithItemEntity:(AllBusListItemEntity *)entity;

@end
