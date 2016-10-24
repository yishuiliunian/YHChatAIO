//
//  YHLocationMessageCell.h
//  YaoHe
//
//  Created by stonedong on 16/6/20.
//  Copyright © 2016年 stonedong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <ElementKit/ElementKit.h>
#import "DZProgrameDefines.h"
#import "YHMessageItemBaseCell.h"
#import "YYText.h"
@interface YHLocationMessageCell : YHMessageItemBaseCell
DEFINE_PROPERTY_STRONG_UIImageView(locationImageView);
DEFINE_PROPERTY_STRONG(YYLabel*, textView);
@end
