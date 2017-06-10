//
//  FSTableViewCell.m
//  FSGridLayoutDemo
//
//  Created by 冯顺 on 2017/6/10.
//  Copyright © 2017年 冯顺. All rights reserved.
//

#import "FSTableViewCell.h"
#import <Masonry.h>

@implementation FSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setJsonStr:(NSString *)jsonStr
{
    [self.layoutView removeFromSuperview];
    self.layoutView = [[FSGridLayoutView alloc]init];
    self.layoutView.jsonStr = jsonStr;
    [self addSubview:self.layoutView];
    [self.layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo([FSGridLayoutView GridViewHeightWithJsonStr:jsonStr]);
    }];
}

@end
