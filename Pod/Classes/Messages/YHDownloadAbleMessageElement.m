//
//  YHDownloadAbleMessageElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/26.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHDownloadAbleMessageElement.h"
#import "DZCDNActionManager.h"
#import "YHMessageItemBaseCell.h"
@interface YHDownloadAbleMessageElement () <DZCDNActionListener>
{
    BOOL _downdingFile;
}
@property (nonatomic, weak, readonly) YHMessageItemBaseCell* downloadMessageCell;
@end

@implementation YHDownloadAbleMessageElement
- (instancetype) initWithMsg:(YHMessage *)msg
{
    self = [super initWithMsg:msg];
    if (!self) {
        return self;
    }
    _downdingFile = NO;
    return self;
}

- (YHMessageItemBaseCell*) downloadMessageCell
{
    return (YHMessageItemBaseCell*)self.uiEventPool;
}
- (void) willBeginHandleResponser:(UIResponder *)responser
{
    [super willBeginHandleResponser:responser];
    [self functionalFilePath];
    if (self.downdingFile) {
        [self startDownloadAnimation];
    } else {
        [self stopDownloadAnimation];
    }
}
- (NSURL*) originFileURL
{
    return nil;
}
- (NSString*) functionalFilePath
{
    NSURL* originFileURL = [self originFileURL];
    if (originFileURL.isFileURL) {
        return originFileURL.path;
    } else {
        if ([DZCDNActionManager isDownloadedURL:originFileURL]) {
            return [DZCDNActionManager localFilePathForURL:originFileURL];
        } else {
            _downdingFile = YES;
            [[DZCDNActionManager shareManager] downloadWAVAudio:originFileURL.absoluteString downloadedWithLisenter:self];
        }
    }
    return nil;
}
- (void) onFileAvaliable
{
    
}
- (void) startDownloadAnimation
{
    [self.downloadMessageCell.bubleImageView.layer addAnimation:[self opacityForever_Animation:1] forKey:@"blingbling"];
}

- (void) stopDownloadAnimation
{
    [self.downloadMessageCell.bubleImageView.layer removeAnimationForKey:@"blingbling"];
}

- (CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.0];
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}
- (void) CDNActionWithURL:(NSURL *)url didFinishWith:(NSString *)fileURL error:(NSError *)error
{
    NSURL* originURL = [self originFileURL];
    if ([url.absoluteString isEqualToString:originURL.absoluteString]) {
        _downdingFile = NO;
        [self stopDownloadAnimation];
    }
}

- (void) handleSelectedInViewController:(UIViewController *)vc
{
    if (_downdingFile) {
        return;
    }
    [self onFileAvaliable];
}
@end
