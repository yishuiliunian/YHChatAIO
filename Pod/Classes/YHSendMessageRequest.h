//
//  YHSendMessageRequest.h
//  YaoHe
//
//  Created by stonedong on 16/5/5.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <YHNetCore/YHNetCore.h>
#import "RpcMsgMessage.pbobjc.h"
#import "RpcPushMessage.pbobjc.h"
#import "YHMessage.h"
@class YHChatSessionInfo;
@interface YHSendMessageRequest : YHAuthedRequest
- (instancetype) initWithMessage:(YHMessage *)message;
@end
