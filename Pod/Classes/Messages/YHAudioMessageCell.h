//
//  YHAudioMessageCell.h
//  YaoHe
//
//  Created by stonedong on 16/5/8.
//  Copyright © 2016年 stonedong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <ElementKit/ElementKit.h>
#import "DZProgrameDefines.h"
#import "YHMessageItemBaseCell.h"

@interface YHAudioMessageCell : YHMessageItemBaseCell
@property (nonatomic, strong, readonly) UILabel* timeLabel;
@property (nonatomic, strong, readonly) UIImageView* audioImageView;
@property (nonatomic, strong, readonly) UIImageView* playedIndicatorImageView;
@end
