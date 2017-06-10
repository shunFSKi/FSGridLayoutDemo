//
//  FSBaseModel.h
//  GridLayoutDemo
//
//  Created by huim on 2017/6/9.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSBaseModel : NSObject
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong)NSArray *children;
@property (nonatomic, assign) double height;
@property (nonatomic, copy) NSString *orientation;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) double weight;
@end
