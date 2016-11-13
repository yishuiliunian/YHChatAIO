//
//  YHAudioMessageElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/8.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHAudioMessageElement.h"
#import "YHAudioMessageCell.h"
#import <DZAudio/DZAudio.h>
#import "DZGeometryTools.h"
#import "DZFileUtils.h"
#import "YHUploadManager.h"
#import "DZCDNActionManager.h"
#import "DZVoiceInputView.h"
#import "DZImageCache.h"
#import <YHCoreDB.h>
#import <DZAuthSession/DZAuthSession.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static NSString* kYHVoicePlayNotification = @"kYHVoicePlayNotification";

@interface YHAudioMessageElement() <K12AudioPlayerDelegate>
{
    Voice* _voice;
    CGRect _timeRect;
    CGRect _audioImageViewRect;
    BOOL _firstShow;
    K12AudioPlayer* _player;
    CGRect _playIndicatorR;
}
@property (nonatomic, strong, readonly) YHAudioMessageCell* audioCell;
@end

@implementation YHAudioMessageElement

- (void) dealloc
{
    [_player stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHAudioMessageCell class];
    _firstShow = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVoicePlayNotification:) name:kYHVoicePlayNotification object:nil];
    return self;
}

- (void)handleVoicePlayNotification:(NSNotification*)nc
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nc.object != self) {
            [_player stop];
            _player = nil;
            [self showIndictorWithoutPlay];
        }
    });
}

- (void) buildMsgContent
{
    [super buildMsgContent];
    _voice = [Voice parseFromData:self.msg.data error:nil];
}





- (void) prepareLayouts:(CGFloat *)cellHeight
{
    [super prepareLayouts:cellHeight];
    CGFloat timeWidth = 50;
    CGFloat voiceHeight = 44;
    CGFloat imageHeight = 20;
    
    CGFloat addtionWidth = 20 + 100 * _voice.duration / (CGFloat)kDZVoiceMaxLength;
    CGFloat width = timeWidth + imageHeight + addtionWidth;
    
    CGRect bRect = _estimateContentRect;
    CGRect tRect;
    CGRect aRect;
    
    CGRect restRect;
    CGRectDivide(_estimateContentRect, &bRect, &restRect, voiceHeight, CGRectMinYEdge);
    
//    bRect = CGRectShrink(bRect, _bubbleArrowWidth, _horizontalStartEdge);
    CGRectDivide(bRect, &bRect, &restRect, width, _horizontalStartEdge);
    
    CGRect contentRect = CGRectShrink(bRect, _xItemSpace, _horizontalStartEdge);
    
    CGRectDivide(contentRect, &aRect, &restRect, imageHeight, _horizontalStartEdge);
    
    CGRectDivide(restRect, &tRect, &restRect, timeWidth, _horizontalEndEdge);
    _bubbleRect = bRect;
    _audioImageViewRect = aRect;
    _timeRect = tRect;
    *cellHeight += voiceHeight;
    
    
    CGSize indicatorSize = {10,10};
    _playIndicatorR = CGRectZero;
    _playIndicatorR.origin.y = CGRectGetMaxY(_bubbleRect) - indicatorSize.height - 5;
    if (_horizontalEndEdge == CGRectMaxXEdge) {
        _playIndicatorR.origin.x = CGRectGetMaxX(_bubbleRect) + indicatorSize.width;
    } else {
        _playIndicatorR.origin.x = CGRectGetMinX(_bubbleRect)- indicatorSize.width;
    }
    _playIndicatorR.size = indicatorSize;
    
    

}

- (void) layoutCell:(YHAudioMessageCell *)cell
{
    [super layoutCell:cell];
    cell.timeLabel.frame = _timeRect;
    cell.timeLabel.textColor = _normalTextColor;
    cell.audioImageView.frame = _audioImageViewRect;
    cell.playedIndicatorImageView.frame = _playIndicatorR;
}

- (void) willBeginHandleResponser:(YHAudioMessageCell*)cell
{
    [super willBeginHandleResponser:cell];
    if (self.msg.isCheckedDetail) {
        self.audioCell.playedIndicatorImageView.hidden = YES;
    } else {
        self.audioCell.playedIndicatorImageView.hidden = NO;
    }
    if (_player.isPlaying) {
        [self showIndictorWithPlay];
    } else {
        [self showIndictorWithoutPlay];
    }
}

- (void) didBeginHandleResponser:(YHAudioMessageCell *)cell
{
    [super didBeginHandleResponser:cell];
    cell.timeLabel.text = [NSString stringWithFormat:@"%d'", _voice.duration];
}

- (void) willRegsinHandleResponser:(YHAudioMessageCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(YHAudioMessageCell *)cell
{
    [super didRegsinHandleResponser:cell];
}



- (YHAudioMessageCell*) audioCell
{
    return (YHAudioMessageCell*)self.uiEventPool;
}

- (void) showIndictorWithPlay
{
    NSMutableArray* images = [NSMutableArray new];
    NSString* prefix = self.sendByMe ? @"r" : @"l";
    for (int i = 0 ; i < 4; i++) {
        NSString* name = [NSString stringWithFormat:@"voice_play_%@_%d",prefix,i];
        UIImage* image = DZCachedImageByName(name);
        if (image) {
            [images addObject:image];
        }
    }
    self.audioCell.audioImageView.animationImages = images;
    self.audioCell.audioImageView.animationDuration = 0.25;
    [self.audioCell.audioImageView startAnimating];
}

- (void) showIndictorWithoutPlay
{
    [self.audioCell.audioImageView stopAnimating];
    NSString* prefix = self.sendByMe ? @"r" : @"l";
    NSString* name = [NSString stringWithFormat:@"voice_play_%@_%d",prefix,3];
    self.audioCell.audioImageView.image = DZCachedImageByName(name);
}

- (void) k12AudioPlayerDidStartPlay:(K12AudioPlayer *)player
{
    [self showIndictorWithPlay];
}

- (void) k12AudioPlayerDidFinishPlay:(K12AudioPlayer *)player
{
    [self showIndictorWithoutPlay];
    _player  = nil;
}

- (void) k12AudioPlayer:(K12AudioPlayer *)player occurError:(NSError *)error
{
    [self showIndictorWithoutPlay];
    _player =nil;
}

- (void) onFileAvaliable
{
    if (_player.isPlaying) {
        return;
    }
    self.msg.isCheckedDetail = YES;
    self.audioCell.playedIndicatorImageView.hidden  = YES;
    [YHActiveDBConnection updateMessage:self.msg];
    _player = [[K12AudioPlayer alloc] initWithURL:[NSURL fileURLWithPath:[self functionalFilePath]]];
    _player.delegate = self;
    [_player play];
    [[NSNotificationCenter defaultCenter] postNotificationName:kYHVoicePlayNotification object:self];
}
- (NSURL*) originFileURL
{
    if (![_voice.mediaId.lowercaseString hasPrefix:@"http"]) {
        return [NSURL fileURLWithPath:_voice.mediaId];
    } else {
        return [NSURL URLWithString:_voice.mediaId];
    }
}

- (void) handleSelectedInViewController:(UIViewController *)vc
{
    if (_player.isPlaying) {
        [_player stop];
        [self showIndictorWithoutPlay];
        _player = nil;
    } else {
        [super handleSelectedInViewController:vc];
    }
}
@end
