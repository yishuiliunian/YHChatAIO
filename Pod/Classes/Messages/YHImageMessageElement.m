//
//  YHImageMessageElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/8.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHImageMessageElement.h"
#import "YHImageMessageCell.h"
#import "YHAppearance.h"
#import "DZGeometryTools.h"
#import "YHUploadManager.h"
#import "YHCoreDB.h"
#import "DZAuthSession.h"
#import "DZImageCache.h"
#import "DZFileUtils.h"
#import "YHImageURLAdapter.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "YHURLRouteDefines.h"

@interface YHImageMessageElement ()
{
    Image* _imageData;
    CGRect _imageRect;
    
    CGRect _progreeRect;
}
@property (nonatomic, strong, readonly) YHImageMessageCell* imageCell;
@end

@implementation YHImageMessageElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHImageMessageCell class];
    return self;
}

- (YHImageMessageCell*) imageCell
{
    return (YHImageMessageCell*)self.uiEventPool;
}

- (void) buildMsgContent
{
    [super buildMsgContent];
    _imageData = [Image parseFromData:self.msg.data error:nil];
 
}

- (void) prepareLayouts:(CGFloat *)cellHeight
{
    [super prepareLayouts:cellHeight];
    int32_t height= _imageData.height;
    CGFloat width = _imageData.width;
    
    CGFloat maxWidth = 100;
    CGFloat minWidth = 50;
    
    width = MAX(minWidth, width);
    width = MIN(maxWidth, width);
    
    if (height == 0 ) {
        height = width;
    }
    int32_t originWidth = _imageData.width;
    if (originWidth == 0) {
        originWidth = width;
    }
    
    height = width / originWidth * height;
    
    CGRect imageRect;
    
    CGRect restRect;
    CGRectDivide(_estimateContentRect, &imageRect, &restRect, height, CGRectMinYEdge);
    CGRectDivide(imageRect, &imageRect, &restRect, width, _horizontalStartEdge);
    
    _bubbleRect = imageRect;
    _imageRect = imageRect;
    
    CGRectDivide(_imageRect , &restRect, &_imageRect, _bubbleArrowWidth, _horizontalStartEdge);
    _imageRect =  CGRectCenterSubSize(_imageRect, CGSizeMake(5, 5));
    
    
    CGSize progressSize = {50, 50};
    _progreeRect = CGRectCenter(_imageRect, progressSize);
    *cellHeight += height;
}

- (void) layoutCell:(YHImageMessageCell *)cell
{
    [super layoutCell:cell];
    cell.uploadProgressView.frame = _progreeRect;
}
- (void) willBeginHandleResponser:(YHImageMessageCell*)cell
{
    [super willBeginHandleResponser:cell];
    cell.contentImageView.frame = _imageRect;
   
    if ([_imageData.URL hasPrefix:@"http"]) {
        [cell.contentImageView loadLittleImageURL:YHImageURLFOrThumbWithString(_imageData.URL)];
    } else {
        [cell.contentImageView hnk_setImageFromFile:DZGenerateLocalPath(_imageData.URL)];
    }
}

- (void) didBeginHandleResponser:(YHImageMessageCell *)cell
{
    [super didBeginHandleResponser:cell];
}

- (void) willRegsinHandleResponser:(YHImageMessageCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(YHImageMessageCell *)cell
{
    [super didRegsinHandleResponser:cell];
}


- (void) handleSelectedInViewController:(UIViewController *)vc
{
    NSMutableArray* photos = [NSMutableArray new];
    NSURL* url = nil;
    if ([_imageData.URL.lowercaseString hasPrefix:@"http"]) {
        url = [NSURL URLWithString:_imageData.URL];
    } else {
        url = DZMediaURL(_imageData.URL);
    }

    YHShowSinglePhoto(url.absoluteString, self.imageCell.contentImageView);
}
- (void) sendOperationDidStart:(YHSendMessageOperation *)op
{
    [super sendOperationDidStart:op];
    self.imageCell.uploadProgressView.hidden = NO;
    
}


- (void) sendOperation:(YHSendMessageOperation *)op onProgress:(float)progress
{
    [super sendOperation:op onProgress:progress];
    self.imageCell.uploadProgressView.progress = progress;
    self.imageCell.uploadProgressView.progressLabel.text = [NSString stringWithFormat:@"%d", (int)floor(progress*100)];
}


- (void) sendOperation:(YHSendMessageOperation *)op faild:(NSError *)error
{
    [super sendOperation:op faild:error];
    self.imageCell.uploadProgressView.hidden = YES;
}

- (void) sendOperationSuccess:(YHSendMessageOperation *)op message:(YHMessage *)message
{
    [super sendOperationSuccess:op message:message];
    self.imageCell.uploadProgressView.hidden = YES;
}
@end
