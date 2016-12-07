//
//  YHMessageSendManager.m
//  YaoHe
//
//  Created by baidu on 5/19/16.
//  Copyright © 2016 stonedong. All rights reserved.
//

#import "YHMessageSendManager.h"
#import "YHMessage.h"
#import "YHSendMessageOperation.h"
#import "YHSendVoiceMessageOperation.h"
#import "YHSendFileMessageOperation.h"
#import "YHSendImageMessageOperation.h"
#import "YHSendVoiceMessageOperation.h"


@interface YHMessageSendManager()
{
    NSOperationQueue* _operationQueue;
}
@end

@implementation YHMessageSendManager
+ (YHMessageSendManager*) shareManager
{
    static YHMessageSendManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [YHMessageSendManager new];
    });
    return manager;
}

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _operationQueue = [NSOperationQueue new];
    return self;
}
- (YHSendMessageOperation*) sendOperationWithMSG:(YHMessage*)msg
{
    Class sendClass = nil;
    switch (msg.type) {
        case MsgType_Text:
            sendClass = [YHSendMessageOperation class];
            break;
        case MsgType_Voice:
            sendClass = [YHSendVoiceMessageOperation class];
            break;
        case MsgType_Image:
            sendClass = [YHSendImageMessageOperation class];
            break;
        default:
            sendClass = [YHSendMessageOperation class];
            break;
    }
    return [[sendClass alloc] initWithMessage:msg];
}
- (void) sendMessage:(YHMessage*)msg withDelegate:(id<YHSendMessageDelegate>)delegate
{
    if ([self isSendingMessage:msg.msgID] ) {
        [self moniterSendingMessage:msg.msgID withDelegate:delegate];
    } else {
        YHSendMessageOperation* op = [self sendOperationWithMSG:msg];
        if (op) {
            [op addObserver:delegate];
            [_operationQueue addOperation:op];
        }
    }

}

- (BOOL) isSendingMessage:(int64_t)msgID
{
    for (YHSendMessageOperation* op in [_operationQueue operations]) {
        if (op.message.msgID == msgID) {
            return YES;
        }
    }
    return NO;
}

- (void) moniterSendingMessage:(int64_t)msgID withDelegate:(id<YHSendMessageDelegate>)delegate
{
    for (YHSendMessageOperation* op in [_operationQueue operations]) {
        if (op.message.msgID == msgID) {
            [op addObserver:delegate];
        }
    }
}
@end
