//
//  FSGridLayoutView.m
//  GridLayoutDemo
//
//  Created by huim on 2017/6/9.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSGridLayoutView.h"
#import <MJExtension.h>
#import <Masonry.h>
#import <UIImageView+AFNetworking.h>
#import "FSTapGestureRecognizer.h"
#import "FSBaseModel.h"
#import "FSItem.h"
#import "UIView+FSEqualMargin.h"

#define DebugLog(...) NSLog(__VA_ARGS__)

@implementation FSGridLayoutView

#pragma mark Setter
- (void)setJsonStr:(NSString *)jsonStr
{
    FSBaseModel *baseModel = [FSBaseModel mj_objectWithKeyValues:jsonStr];
    DebugLog(@"共有--%lu行",(unsigned long)baseModel.images.count);
    [FSGridLayoutView getRowsTotalHeight:baseModel];
    NSMutableArray *rows = [NSMutableArray array];
    for (NSDictionary *dic in baseModel.images) {
        FSBaseModel *base = [FSBaseModel mj_objectWithKeyValues:dic];
        if (base.height) {
            [rows addObject:base];
        }
    }
    [self setupRowsViewWithArr:rows];
}

+ (CGFloat)GridViewHeightWithJsonStr:(NSString *)jsonStr
{
    FSBaseModel *baseModel = [FSBaseModel mj_objectWithKeyValues:jsonStr];
    return [FSGridLayoutView getRowsTotalHeight:baseModel];
}

#pragma mark ----
//创建row
- (void)setupRowsViewWithArr:(NSMutableArray *)rows
{
    CGFloat row_H = 0;
    for (FSBaseModel *base in rows) {
        UIImageView *rowView = [[UIImageView alloc]init];
        rowView.backgroundColor = [FSGridLayoutView randomColor];
        [self addSubview:rowView];
        [rowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(row_H);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(base.height);
        }];
        row_H += base.height;
        [self setupItemViewWithItemModel:[FSItem getItemWithModel:base] parentView:rowView];
    }
}

//创建item
- (void)setupItemViewWithItemModel:(FSItem *)item parentView:(UIImageView *)parentView
{
    parentView.userInteractionEnabled = YES;
    
    CGFloat totalWeight = 0;
    for (FSBaseModel *subBase in item.itemModels) {
        totalWeight += subBase.weight;
    }
    
    NSMutableArray *subViews = [NSMutableArray array];
    for (FSBaseModel *subBase in item.itemModels) {
        UIImageView *itemView = [[UIImageView alloc]init];
        itemView.backgroundColor = [FSGridLayoutView randomColor];
        [parentView addSubview:itemView];
        if ([item.orientation isEqualToString:@"h"]) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(parentView).multipliedBy(subBase.weight/totalWeight);
                make.top.bottom.mas_equalTo(parentView);
            }];
        }else{
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(parentView).multipliedBy(subBase.weight/totalWeight);
                make.left.right.mas_equalTo(parentView);
            }];
        }
        
        [subViews addObject:itemView];
        
        if (subBase.children) {//数据有children，就一直分割下去
            [self setupItemViewWithItemModel:[FSItem getItemWithModel:subBase] parentView:itemView];
        }
        
        if (subBase.image) {//有image就显示，代表分割到底了
            itemView.userInteractionEnabled = YES;
            [itemView setImageWithURL:[NSURL URLWithString:subBase.image]];
            FSTapGestureRecognizer *itemTap = [[FSTapGestureRecognizer alloc]initWithTarget:self action:@selector(itemTap:)];
            itemTap.param = subBase.image;
            [itemView addGestureRecognizer:itemTap];
        }
        
        itemView.layer.borderColor = [UIColor redColor].CGColor;
        itemView.layer.borderWidth = 0.5f;
    }
    [item.orientation isEqualToString:@"h"]?[parentView distributeSpacingHorizontallyWith:subViews]:[parentView distributeSpacingVerticallyWith:subViews];
}

//获得整个FSGridLayoutView的高度
+ (CGFloat)getRowsTotalHeight:(FSBaseModel *)baseModel
{
    CGFloat height = 0;
    for (NSDictionary *dic in baseModel.images) {
        FSBaseModel *subBase = [FSBaseModel mj_objectWithKeyValues:dic];
        if (subBase.height) {
            height += subBase.height;
        }
    }
    return height;
}

#pragma mark Tap
- (void)itemTap:(id)sender
{
    FSTapGestureRecognizer *tap = (FSTapGestureRecognizer *)sender;
    DebugLog(@"点击了--%@",tap.param);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"item" message:tap.param delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

+ (UIColor*) randomColor{
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
