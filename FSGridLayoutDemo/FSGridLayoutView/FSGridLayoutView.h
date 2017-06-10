//
//  FSGridLayoutView.h
//  GridLayoutDemo
//
//  Created by huim on 2017/6/9.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSGridLayoutView : UIView

@property (nonatomic, strong) NSString *jsonStr;
+ (CGFloat)GridViewHeightWithJsonStr:(NSString *)jsonStr;
@end
