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

 int32_t const EVENT_TROOP_MEMBER_KILL = 0x4001;//事件（全员） + 被踢者收系统消息
 static  int32_t  const  EVENT_TROOP_CLOSE = 0x4002;//群关闭 = 事件 （非全员，群主不用收该事件） + 所有人收到关群的系统消息(包括群主)
 static  int32_t  const EVENT_TROOP_MEMBER_JOIN = 0x4003;//事件（非全员，入群者不用收该事件）
 static  int32_t  const EVENT_TROOP_MEMBER_QUIT = 0x4004;//事件（非全员，退群者不用收该事件）
 static  int32_t const  EVENT_CLASS_CLOSE = 0x4010;//群关闭 = 事件 （非全员，班长不用收该事件） + 所有人收到班级关闭的系统消息（包括班长）
static int32_t const EVENT_CLASS_JOIN = 0x4011; //有人申请加入班级
 static  int32_t const  EVENT_LOVEWALL_NEW = 0x4020;//有人表白
static int32_t const EVENT_PASSWORD_CHANGED = 0x4040; // 提示修改密码(0x4040)

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
        case EVENT_TROOP_MEMBER_JOIN:
            return [[YHJoinActionGroupElement alloc] initWithMsg:message];
        case EVENT_TROOP_MEMBER_QUIT:
            return [[YHExitActionGroupElement alloc] initWithMsg:message];
        case EVENT_CLASS_CLOSE:
            return [[YHTCloseClassElement alloc] initWithMsg:message];
        case EVENT_CLASS_JOIN:
            return [[YHJoinClassElement alloc] initWithMsg:message];
        case EVENT_LOVEWALL_NEW:
            return [[YHTGotLoveElement alloc] initWithMsg:message];
        case EVENT_PASSWORD_CHANGED:
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
