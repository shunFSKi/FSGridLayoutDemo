//
//  FSItem.m
//  FSGridLayoutDemo
//
//  Created by 冯顺 on 2017/6/10.
//  Copyright © 2017年 冯顺. All rights reserved.
//

#import "FSItem.h"

@implementation FSItem

- (NSMutableArray *)itemModels
{
    if (!_itemModels) {
        _itemModels = [NSMutableArray array];
    }
    return _itemModels;
}

+ (FSItem *)getItemWithModel:(FSBaseModel *)base
{
    FSItem *item = [FSItem new];
    item.orientation = base.orientation;
    for (NSDictionary *dic in base.children) {
        FSBaseModel *subBase = [FSBaseModel mj_objectWithKeyValues:dic];
        [item.itemModels addObject:subBase];
    }
    return item;
}
@end
