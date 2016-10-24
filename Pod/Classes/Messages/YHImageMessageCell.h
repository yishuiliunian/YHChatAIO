//
//  YHImageMessageCell.h
//  YaoHe
//
//  Created by stonedong on 16/5/8.
//  Copyright © 2016年 stonedong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <ElementKit/ElementKit.h>
#import "DZProgrameDefines.h"
#import "YHMessageItemBaseCell.h"
#import "DALabeledCircularProgressView.h"


@interface YHImageMessageCell : YHMessageItemBaseCell
@property (nonatomic, strong, readonly) UIImageView* contentImageView;
@property (nonatomic, strong, readonly) DALabeledCircularProgressView* uploadProgressView;
@end
