//
//  YHSendMessageOperation.h
//  YaoHe
//
//  Created by baidu on 5/19/16.
//  Copyright © 2016 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcPushMessage.pbobjc.h"
@class YHSendMessageOperation;
@class YHMessage;
@protocol YHSendMessageDelegate <NSObject>

- (void) sendOperation:(YHSendMessageOperation*)op faild:(NSError*)error;
- (void) sendOperationSuccess:(YHSendMessageOperation *)op message:(YHMessage*)message;
- (void) sendOperation:(YHSendMessageOperation *)op onProgress:(float)progress;
- (void) sendOperationDidStart:(YHSendMessageOperation*)op;

@end


@class YHMessage;
@interface YHSendMessageOperation : NSOperation
@property (atomic, weak) id<YHSendMessageDelegate> delegate;
@property (nonatomic, strong, readonly) YHMessage* message;
- (instancetype) initWithMessage:(YHMessage*)message;
- (BOOL) uploadFileIfNeed:(NSError* __autoreleasing*)error;

//
- (void) sendMessageFaild:(NSError*)error;
@end
