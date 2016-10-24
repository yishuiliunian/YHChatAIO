//
//  YHSendMessageRequest.m
//  YaoHe
//
//  Created by stonedong on 16/5/5.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHSendMessageRequest.h"
#import "YHchatSessionInfo.h"
#import "DZAuthSession.h"
@interface YHSendMessageRequest()
{
    YHMessage* _message;
}
@end
@implementation YHSendMessageRequest
- (instancetype) initWithMessage:(YHMessage *)message
{
    self = [super init];
    if (!self) {
        return self;
    }
    _message = message;
    self.msg.toUserName = _message.toAccount;
    self.msg.toUserType = _message.toType;
    self.msg.fromUserName = _message.fromAccount;
    self.msg.fromUserType = _message.fromType;
    self.msg.msgBody = _message.data;
    self.msg.msgExt = _message.extention;
    self.msg.msgId = 0;
    self.msg.createTime = [[NSDate date] timeIntervalSince1970];
    self.msg.msgType = _message.type;

    return self;
}
- (Msg*)msg
{
    if (!_requestData) {
        _requestData = (Msg*)[Msg new];
    }
    return (Msg*)_requestData;
}
- (NSString*) servant
{
    return @"Comm.MsgServer.MsgObj";
}

- (NSString*) method
{
    return @"rpc.MsgService.SendMsg";
}

- (void) onError:(NSError *)error
{
    [super onError:error];
}

- (void) onNetSuccess:(id)object
{
    [super onNetSuccess:object];
}
@end
