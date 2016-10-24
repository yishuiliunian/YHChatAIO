//
//  YHEventMessageElement.m
//  YaoHe
//
//  Created by stonedong on 16/6/30.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHEventMessageElement.h"
#import "DZLogger.h"

@interface YHEventMessageElement ()
{
    Event* _event;
}
@end

@implementation YHEventMessageElement
- (void) buildMsgContent
{
    [super buildMsgContent];
    NSError* error;
    _contentData= (id<YHToastValueData>)[Event parseFromData:self.msg.data error:&error];
    if (error) {
        DDLogError(@"%@",error);
    }
}

@end
