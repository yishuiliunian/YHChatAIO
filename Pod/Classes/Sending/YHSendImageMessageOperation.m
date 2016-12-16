//
//  YHSendImageMessageOperation.m
//  YaoHe
//
//  Created by baidu on 5/19/16.
//  Copyright © 2016 stonedong. All rights reserved.
//

#import "YHSendImageMessageOperation.h"
#import "YHMessage.h"
#import "DZFileUtils.h"
#import "HNKCache.h"
#import "SDWebImageManager.h"
#import "YHAppearance.h"
#import "DZFixImage.h"

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
    return DZGenerateLocalPath(_imageData.URL);
}

- (void) onUploadFile:(NSString *)url
{
    [super onUploadFile:url];
    UIImage * image =  [UIImage imageWithContentsOfFile:[self localFilePath]];
    _imageData.URL = url;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:url]];
         UIImage * otherImage = [image fixAppearance];
        [[HNKCache sharedCache] setImage:otherImage forKey:YHImageURLFOrThumbWithString(url).absoluteString formatName:LTHanekeCacheFormatThumb().name];
    });
    self.message.data = [_imageData data];
}
- (void) uploadFile:(NSString *)localFilePath withKey:(NSString *)key process:(OSSNetworkingUploadProgressBlock)process finish:(void (^)(NSError *, NSString *))finish
{
    [[YHUploadManager shareManager] uploadImageFile:localFilePath withKey:key process:process finish:finish];
}
@end
