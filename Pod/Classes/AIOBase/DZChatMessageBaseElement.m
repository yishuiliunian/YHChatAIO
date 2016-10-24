//
//  DZChatMessageBaseElement.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <Foundation/Foundation.h>
#import "DZChatMessageBaseElement.h"
#import "DZChatMessageBaseCell.h"
@implementation DZChatMessageBaseElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [DZChatMessageBaseCell class];
    return self;
}

- (void) willBeginHandleResponser:(DZChatMessageBaseCell*)cell
{
    [super willBeginHandleResponser:cell];
}

- (void) didBeginHandleResponser:(DZChatMessageBaseCell *)cell
{
    [super didBeginHandleResponser:cell];
}

- (void) willRegsinHandleResponser:(DZChatMessageBaseCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(DZChatMessageBaseCell *)cell
{
    [super didRegsinHandleResponser:cell];
}
@end