//
//  YHExitActionGroupElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHExitActionGroupElement.h"

@implementation YHExitActionGroupElement
- (NSMutableAttributedString*) buildContentText
{
    NSString* output = [NSString stringWithFormat:@"[%@]退出了活动[%@]",_userNick, _groupName];
    NSMutableAttributedString* mAStr = [[NSMutableAttributedString alloc] initWithString:output];
    return mAStr;
}

@end
