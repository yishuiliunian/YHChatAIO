//
//  YHDownloadAbleMessageElement.h
//  YaoHe
//
//  Created by stonedong on 16/5/26.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHMessageItemBaseElement.h"

@interface YHDownloadAbleMessageElement : YHMessageItemBaseElement
{
    @protected
    NSString* _availableFilePath;
}
@property (nonatomic, assign, readonly) BOOL downdingFile;
@property (nonatomic, strong, readonly) NSString* functionalFilePath;
- (NSURL*) originFileURL;
- (void) onFileAvaliable;
@end
