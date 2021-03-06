//
//  ImageNewsCell.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/5.
//
//

#import "ImageNewsCell.h"
#import "NIAttributedLabel.h"

@interface ImageNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *imageNewsNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageViewThree;

@property (weak, nonatomic) IBOutlet NIAttributedLabel *praiseCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation ImageNewsCell

CGFloat defaultImageNewsCellHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    _imageNewsNameLabel.font = SP15Font;
    _imageNewsNameLabel.textColor = Common_BlackColor;
    
    _praiseCountLabel.font = SP12Font;
    _praiseCountLabel.textColor = Common_BlueColor;
    _praiseCountLabel.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
    
    _commentCountBtn.titleLabel.font = SP14Font;
    [_commentCountBtn setTitleColor:Common_BlueColor forState:UIControlStateNormal];
    
    UIColor *borderColor = HEXCOLOR(0XCFD7E2);
    
    for (UIView *view in self.contentView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]] && ![view isEqual:_commentCountBtn])
        {
            [view addBorderToViewWitBorderColor:borderColor borderWidth:LineWidth];
            [view setRadius:5];
        }
    }
    
    [self addLineWithPosition:ViewDrawLinePostionType_Top lineColor:CellSeparatorColor lineWidth:LineWidth];
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom lineColor:CellSeparatorColor lineWidth:LineWidth];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}
- (IBAction)clickCheckCommentBtn:(UIButton *)sender
{
    if (_handle) _handle(self, CellOperationType_CheckComment, sender);
}

- (IBAction)clickGoCommentBtn:(UIButton *)sender
{
    if (_handle) _handle(self, CellOperationType_GoComment, sender);
}

- (IBAction)clickShareBtn:(UIButton *)sender
{
    if (_handle) _handle(self, CellOperationType_Share, sender);
}

////////////////////////////////////////////////////////////////////////////////

+ (CGFloat)getCellHeight
{
    if (0 == defaultImageNewsCellHeight)
    {
        ImageNewsCell *cell = [ImageNewsCell loadFromNib];
        defaultImageNewsCellHeight = cell.boundsHeight;
    }
    return defaultImageNewsCellHeight;
}

- (void)loadCellShowDataWithItemEntity:(ImageNewsEntity *)entity
{
    UIButton *imageCountBtn = InsertImageButtonWithTitle(nil, CGRectZero, 8888, [UIImage imageNamed:@"jizhangtu"], nil, [NSString stringWithFormat:@"%d",entity.imageUrlsStrArray.count], UIEdgeInsetsMake(0, 0, 0, 18), SP14Font, [UIColor whiteColor], nil, NULL);
    [imageCountBtn sizeToFit];
    
    _imageNewsNameLabel.text = entity.imageNewsNameStr;
    [_commentCountBtn setTitle:[NSString stringWithFormat:@"查看全部%d条评论", entity.imageCommentCount] forState:UIControlStateNormal];
    
    _previewImageViewOne.image = nil;
    RemoveAllSubviews(_previewImageViewOne);
    _previewImageViewTwo.image = nil;
    RemoveAllSubviews(_previewImageViewTwo);
    _previewImageViewThree.image = nil;
    RemoveAllSubviews(_previewImageViewThree);
    
    if (3 <= entity.imageUrlsStrArray.count)
    {
        [_previewImageViewThree addSubview:imageCountBtn];
    }
    else if (2 == entity.imageUrlsStrArray.count)
    {
        [_previewImageViewTwo addSubview:imageCountBtn];
    }
    else if (2 == entity.imageUrlsStrArray.count)
    {
        [_previewImageViewOne addSubview:imageCountBtn];
    }
    
    [imageCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(50, 24));
        make.right.equalTo(imageCountBtn.superview).offset(@(-15));
        make.bottom.equalTo(imageCountBtn.superview).offset(@(-3));
    }];
    
    for (int i = 0; i < entity.imageUrlsStrArray.count; ++i)
    {
        if (0 == i)
        {
            [_previewImageViewOne gjh_setImageWithURL:[NSURL URLWithString:entity.imageUrlsStrArray[i]] placeholderImage:nil imageShowStyle:ImageShowStyle_None success:nil failure:nil];
        }
        else if (1 == i)
        {
            [_previewImageViewTwo gjh_setImageWithURL:[NSURL URLWithString:entity.imageUrlsStrArray[i]] placeholderImage:nil imageShowStyle:ImageShowStyle_None success:nil failure:nil];
        }
        else if (2 == i)
        {
            [_previewImageViewThree gjh_setImageWithURL:[NSURL URLWithString:entity.imageUrlsStrArray[i]] placeholderImage:nil imageShowStyle:ImageShowStyle_None success:nil failure:nil];
            
            return;
        }
    }
}

@end
