//
//  DZAIOTableElement.h
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <ElementKit/ElementKit.h>
#import "DZInputToolbar.h"
#import "DZChatUI.h"
@class YHLocation;



@class DZInputViewController;
@interface DZAIOTableElement : EKAdjustTableElement <DZInputProtocol>


- (void) handleLoadOldMessage;
- (void) inputImage:(UIImage*)image;
- (void) inputVoice:(NSURL*)url;
- (void) inputText:(NSString*)text;
- (void) inputLocation:(YHLocation*)location;
@end
