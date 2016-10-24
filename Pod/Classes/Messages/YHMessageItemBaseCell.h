//
//  YHMessageItemBaseCell.h
//  YaoHe
//
//  Created by stonedong on 16/5/4.
//  Copyright © 2016年 stonedong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <ElementKit/ElementKit.h>
#import "DZChatUI.h"
#import "DZProgrameDefines.h"
#import "DZChatMessageBaseCell.h"
@protocol YHMessageItemBaseCellInteractDelegate <NSObject>
- (NSArray*) messagePopUpMenus;
@end


@interface YHMessageItemBaseCell : DZChatMessageBaseCell
@property (nonatomic, weak) id<YHMessageItemBaseCellInteractDelegate> interactDelegate;
@end
