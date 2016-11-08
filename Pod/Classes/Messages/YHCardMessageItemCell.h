//
//  YHCardMessageItemCell.h
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHMessageItemBaseCell.h"
@class YYLabel;
@interface YHCardMessageItemCell : YHMessageItemBaseCell
@property (nonatomic, strong, readonly) UILabel* gotoLabel;
@property (nonatomic, strong, readonly) YYLabel* actionDetailLabel;
@property (nonatomic, strong, readonly) UIImageView* actionBackgroundView;
@end
