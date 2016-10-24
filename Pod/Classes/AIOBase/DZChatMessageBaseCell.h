//
//  DZChatMessageBaseCell.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//
#import <UIKit/UIKit.h>
#import <ElementKit/ElementKit.h>
#import "FLAnimatedImageView.h"
#import "DZProgrameDefines.h"
@class YYLabel;
@class DZChatMessageBaseCell;
@protocol DZChatMessageBaseCellStatusDelegate
- (void) chatCellDidTapStatusView:(DZChatMessageBaseCell*)cell;
@end
@interface DZChatMessageBaseCell : EKAdjustTableViewCell
@property (nonatomic, weak) NSObject<DZChatMessageBaseCellStatusDelegate>* chatStatusDelegate;
@property (nonatomic,strong) UILabel* nickLabel;
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UIImageView* bubleImageView;
@property (nonatomic, strong) FLAnimatedImageView* sendStatusImageView;
@property (nonatomic, strong) YYLabel* timeLineLabel;
@property (nonatomic, strong) YYLabel* bottomIndictorLabel;
@end
