//
//  YHSendMessageOperation.m
//  YaoHe
//
//  Created by baidu on 5/19/16.
//  Copyright © 2016 stonedong. All rights reserved.
//

#import "YHSendMessageOperation.h"
#import "YHMessage.h"
#import "YHSendMessageRequest.h"
#import "DZAuthSession.h"
#import "YHCoreDB.h"
#import "YHNotifications.h"
#import "YHAppConfig.h"

#ifdef MESSAGE_TEST
#import "YHMessageTest.h"
#endif

@interface YHSendMessageOperation ()

@end
@implementation YHSendMessageOperation

- (instancetype) initWithMessage:(YHMessage*)message
{
    self = [super init];
    if (!self) {
        return self;
    }
    _message = message;
    _observers = [NSPointerArray weakObjectsPointerArray];
    return self;
}

- (void) addObserver:(id<YHSendMessageDelegate>)observer
{
    for (id <YHSendMessageDelegate> delegate in _observers) {
        if (delegate == observer) {
            return;;
        }
    }
    [_observers addPointer:(void *)observer];
}

- (BOOL) uploadFileIfNeed:(NSError* __autoreleasing*)error
{
    return YES;
}

- (void) sendMessageSuccess
{
    
    _message.msgStatus = YHMessageStatueNormal;
#ifdef MESSAGE_TEST
    int msgID = 0;
    if (_message.type == MsgType_Text) {
        Text* text = [Text parseFromData:_message.data error:nil];
        NSString* content = [[NSString alloc] initWithData:text.context encoding:NSUTF8StringEncoding];
        if ([content hasPrefix:@"auto-"]) {
            content = [content substringFromIndex:5];
        }
        msgID = [content intValue];
    }
    [YHMessageTest reportSendMessage:msgID];
#endif
    _message.errorMessage = nil;
    [YHActiveDBConnection updateMessage:_message];
    DZPostMessageChangedWithMessage(_message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id <YHSendMessageDelegate> delegate in _observers) {
            if ([delegate respondsToSelector:@selector(sendOperationSuccess:message:)]) {
                [delegate sendOperationSuccess:self message:_message];
            }
        }
    });
}

- (void) sendMessageFaild:(NSError*)error
{

    _message.msgStatus = YHMessageStatueSendError;
    _message.errorMessage = error.localizedDescription;
    [YHActiveDBConnection updateMessage:_message];
    DZPostMessageChangedWithMessage(_message);
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id <YHSendMessageDelegate> delegate in _observers) {
            if ([delegate respondsToSelector:@selector(sendOperation:faild:)]) {
                [delegate sendOperation:self faild:error];
            }
        }
    });
}
- (void) notifyStart
{
    dispatch_async(dispatch_get_main_queue(), ^{
    for (id <YHSendMessageDelegate> delegate in _observers) {
        if ([delegate respondsToSelector:@selector(sendOperationDidStart:)]) {
            [delegate sendOperationDidStart:self];
        }
    }
    });
}
- (void) main
{
    @autoreleasepool {

        [self notifyStart];
        NSError* error;
        if (![self uploadFileIfNeed:&error]) {
            [self sendMessageFaild:error];
        } else {
            YHSendMessageRequest* request = [[YHSendMessageRequest alloc] initWithMessage:_message];
            request.skey = DZActiveAuthSession.token;
            
            __weak typeof(self)weakSelf = self;
            dispatch_semaphore_t semp = dispatch_semaphore_create(0);
            [request setErrorHandler:^(NSError * error) {
                [weakSelf sendMessageFaild:error];
                dispatch_semaphore_signal(semp);
            }];
            
            [request setSuccessHanlder:^(id object) {
                [weakSelf sendMessageSuccess];
                dispatch_semaphore_signal(semp);
            }];
            [request start];
            dispatch_semaphore_wait(semp, DISPATCH_TIME_FOREVER);
        }
    }
}
@end
