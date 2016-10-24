//
//  YHTextMessageCell.h
//  YaoHe
//
//  Created by stonedong on 16/5/4.
//  Copyright © 2016年 stonedong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <ElementKit/ElementKit.h>
#import "DZProgrameDefines.h"
#import "YHMessageItemBaseCell.h"
#import "YYText.h"
@interface YHTextMessageCell : YHMessageItemBaseCell
@property (nonatomic, strong, readonly) YYLabel* textContentLabel;
@end
