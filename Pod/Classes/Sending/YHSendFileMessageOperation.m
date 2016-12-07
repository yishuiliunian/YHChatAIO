//
//  YHSendFileMessageOperation.m
//  YaoHe
//
//  Created by baidu on 5/19/16.
//  Copyright © 2016 stonedong. All rights reserved.
//

#import "YHSendFileMessageOperation.h"

#import "YHMessage.h"
#import "DZCDNActionManager.h"

@interface YHSendFileMessageOperation()
@property (nonatomic, strong, readonly) NSString* uploadKey;
@end
@implementation YHSendFileMessageOperation

- (NSString*) uploadKey
{
    return [@(self.message.msgID) stringValue];
}
- (NSString*) localFilePath
{
    return @"";
}
- (void) notifyProcess:(CGFloat)process
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id <YHSendMessageDelegate> delegate in _observers) {
            if ([delegate respondsToSelector:@selector(sendOperation:onProgress:)]) {
                [delegate sendOperation:self onProgress:process];
            }
        }
    });
}

- (void) onUploadFile:(NSString*) url
{

}
- (BOOL) uploadFileIfNeed:(NSError* __autoreleasing*)error
{
    __weak typeof(self)weakSelf = self;
    __block NSError* localError;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self uploadFile:[self localFilePath] withKey:self.uploadKey process:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        [weakSelf notifyProcess:(CGFloat)totalBytesSent/totalBytesExpectedToSend];
    } finish:^(NSError * error, NSString * url) {
        localError = error;
        if (!localError) {
            [self onUploadFile:url];
        }else {
            [self sendMessageFaild:error];
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (localError) {
        if (error!= NULL) {
            *error = localError;
        }
        return NO;
    } else {
        return YES;
    }
}

- (void) uploadFile:(NSString*)localFilePath withKey:(NSString *)key process:(OSSNetworkingUploadProgressBlock)process finish:(void (^)(NSError *, NSString *))finish
{
    [[YHUploadManager shareManager] uploadFile:localFilePath withKey:self.uploadKey process:process finish:finish];
    
}
@end
