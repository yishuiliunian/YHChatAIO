//
//  YHSendImageMessageOperation.m
//  YaoHe
//
//  Created by baidu on 5/19/16.
//  Copyright © 2016 stonedong. All rights reserved.
//

#import "YHSendImageMessageOperation.h"
#import "YHMessage.h"
@interface YHSendImageMessageOperation()
{
    Image* _imageData;
    NSString* _localImagePath;
}
@end
@implementation YHSendImageMessageOperation

- (instancetype) initWithMessage:(YHMessage *)message
{
    self = [super initWithMessage:message];
    if (!self) {
        return self;
    }
    _imageData = [Image parseFromData:message.data error:nil];
    return self;
}
- (NSString*)localFilePath
{
    return _imageData.URL;
}

- (void) onUploadFile:(NSString *)url
{
    [super onUploadFile:url];
    _imageData.URL = url;
    self.message.data = [_imageData data];
}
- (void) uploadFile:(NSString *)localFilePath withKey:(NSString *)key process:(OSSNetworkingUploadProgressBlock)process finish:(void (^)(NSError *, NSString *))finish
{
    [[YHUploadManager shareManager] uploadImageFile:localFilePath withKey:key process:process finish:finish];
}
@end
