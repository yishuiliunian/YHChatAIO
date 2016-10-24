//
//  YHMessageSendManager.h
//  YaoHe
//
//  Created by baidu on 5/19/16.
//  Copyright © 2016 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHSendMessageOperation.h"
@class YHMessage;
@interface YHMessageSendManager : NSObject
+ (YHMessageSendManager*) shareManager;
- (BOOL) isSendingMessage:(int64_t)msgID;
- (void) sendMessage:(YHMessage*)msg withDelegate:(id<YHSendMessageDelegate>)delegate;
- (void) moniterSendingMessage:(int64_t)msgID withDelegate:(id<YHSendMessageDelegate>)delegate;
@end
