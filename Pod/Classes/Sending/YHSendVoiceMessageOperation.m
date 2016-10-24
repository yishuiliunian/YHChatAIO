//
//  YHSendVoiceMessageOperation.m
//  YaoHe
//
//  Created by baidu on 5/19/16.
//  Copyright © 2016 stonedong. All rights reserved.
//

#import "YHSendVoiceMessageOperation.h"
#import "YHMessage.h"
#import "DZCDNActionManager.h"
@interface YHSendVoiceMessageOperation ()
{
    Voice* _voiceData;
}
@end

@implementation YHSendVoiceMessageOperation
- (instancetype) initWithMessage:(YHMessage *)message
{
    self = [super initWithMessage:message];
    if (!self) {
        return self;
    }
    _voiceData = [Voice parseFromData:message.data error:nil];
    return self;
}

- (NSString*) localFilePath
{
    return _voiceData.mediaId;
}

- (void) onUploadFile:(NSString *)url
{
    [super onUploadFile:url];
    [[DZCDNActionManager shareManager] cacheFilePath:[self localFilePath] forURL:url];
    _voiceData.mediaId = url;
    self.message.data = _voiceData.data;
}
@end
