//
//  YHChatElement.h
//  YaoHe
//
//  Created by stonedong on 16/4/29.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <ElementKit/ElementKit.h>
#import "DZChatUI.h"
#import "YHChatSessionInfo.h"
#import "YHMessageItemBaseElement.h"
#import "YHMessage.h"
#import "DZAIOTableElement.h"
@interface YHChatElement : DZAIOTableElement
@property (nonatomic, strong, readonly) YHChatSessionInfo* sessionInfo;

- (instancetype) initWithSessionInfo:(YHChatSessionInfo*)info;
/**
 *  Factory
 *
 *  @param info SessionInfo
 *
 *  @return 根据传入的SessionInfo传出合适的ChatElement
 */
+ (YHChatElement*) chatElementWithSessionInfo:(YHChatSessionInfo*)info;
- (void) handleServerMessages:(NSArray*)messages;

@end
