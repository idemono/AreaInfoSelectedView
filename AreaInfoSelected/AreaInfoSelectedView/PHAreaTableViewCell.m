//
//  PHAreaTableViewCell.m
//  AreaInfoSelected
//
//  Created by 泓杉mini on 2018/11/28.
//  Copyright © 2018 PH. All rights reserved.
//

#import "PHAreaTableViewCell.h"

#import <Masonry.h>

@interface PHAreaTableViewCell ()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *selectedImageView;
@end

@implementation PHAreaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action
- (void)setName:(NSString *)name isSelected:(BOOL)isSelected{
    if (isSelected) {
        self.nameLabel.textColor = [UIColor colorWithRed:181.0 / 255.0
                                                   green:218.0 / 255.0
                                                    blue:79.0 / 255.0
                                                   alpha:1.0];
        self.selectedImageView.hidden = NO;
    }else{
        self.nameLabel.textColor = [UIColor colorWithRed:0.0 / 255.0
                                                   green:0.0 / 255.0
                                                    blue:0.0 / 255.0
                                                   alpha:1.0];
        self.selectedImageView.hidden = YES;
    }
    self.nameLabel.text = name;
}


#pragma mark - UI


- (void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.nameLabel];
    [self addSubview:self.selectedImageView];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(14);
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(15);
    }];
}

#pragma mark - Lazy load
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UIImageView *)selectedImageView{
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips_success.png"]];
    }
    return _selectedImageView;
}


@end
