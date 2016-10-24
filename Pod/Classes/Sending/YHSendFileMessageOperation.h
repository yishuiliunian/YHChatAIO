//
//  YHSendFileMessageOperation.h
//  YaoHe
//
//  Created by baidu on 5/19/16.
//  Copyright © 2016 stonedong. All rights reserved.
//

#import "YHSendMessageOperation.h"
#import "YHUploadManager.h"
@interface YHSendFileMessageOperation : YHSendMessageOperation
- (NSString*) localFilePath;
- (void) onUploadFile:(NSString*) url;
- (void) uploadFile:(NSString*)localFilePath withKey:(NSString *)key process:(OSSNetworkingUploadProgressBlock)process finish:(void (^)(NSError *, NSString *))finish;
@end
