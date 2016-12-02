//
//  YHToastMessageElement.m
//  YaoHe
//
//  Created by stonedong on 16/6/30.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHToastMessageElement.h"
#import "YHToastMessageCell.h"
#import "DZLogger.h"
#import <DZGeometryTools/DZGeometryTools.h>
#import "YHToastMessageCell.h"
#import "YHCommonCache.h"
#import <YHNetCore.h>
#import "YHClassMemberListElement.h"
#import "YHClassMemberListViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "DZURLRoute.h"
#import "YHUnsupportElement.h"
#import "YHExitActionGroupElement.h"
#import "YHTActionGroupKillElement.h"
#import "YHTCloseActionGroupElement.h"
#import "YHJoinActionGroupElement.h"
#import "YHExitActionGroupElement.h"
#import "YHTCloseClassElement.h"
#import "YHJoinClassElement.h"
#import "YHPasswordChangeElement.h"
#import "YHTGotLoveElement.h"
#import "YHSyncMsgRequest.h"


@interface YHToastMessageElement () <YHCacheFetcherObsever>

@end

@implementation YHToastMessageElement

+ (YHToastMessageElement*) toastElementWithMessage:(YHMessage *)message
{
    NSError* error;
    
    Toast* toast = nil;
    if (message.type == MsgType_Toast) {
        toast = [Toast parseFromData:message.data error:&error];
    } else if (message.type == MsgType_Event){
        toast  = [Event parseFromData:message.data error:&error];
    }
    if (!toast) {
        return [[YHUnsupportElement alloc] initWithMsg:message];
    }
    
    switch (toast.subType) {
        case EVENT_TROOP_MEMBER_KILL:
            return [[YHTActionGroupKillElement alloc] initWithMsg:message];
            break;
        case EVENT_TROOP_CLOSE:
            return [[YHTCloseActionGroupElement alloc] initWithMsg:message];
            break;
        case TOAST_TROOP_MEMBER_JOIN:
            return [[YHJoinActionGroupElement alloc] initWithMsg:message];
        case TOAST_TROOP_MEMBER_QUIT:
            return [[YHExitActionGroupElement alloc] initWithMsg:message];
        case EVENT_CLASS_CLOSE:
            return [[YHTCloseClassElement alloc] initWithMsg:message];
        case TOAST_CLASS_JOIN:
            return [[YHJoinClassElement alloc] initWithMsg:message];
        case TOAST_PWD_UPDATE:
            return [[YHPasswordChangeElement alloc] initWithMsg:message];
        default:
            return [[YHUnsupportElement alloc] initWithMsg:message];
    }
    
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHToastMessageCell class];
    return self;
}

- (void) prepareLayouts:(CGFloat *)cellHeight
{
    [super prepareLayouts:cellHeight];
}

- (void) buildMsgContent
{
    [super buildMsgContent];
    NSError* error;
    _toast = [Toast parseFromData:self.msg.data error:&error];
    if (error) {
        DDLogError(@"%@",error);
    }
}




@end
