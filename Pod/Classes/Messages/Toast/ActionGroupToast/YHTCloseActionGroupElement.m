//
//  YHTCloseActionGroupElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHTCloseActionGroupElement.h"

@implementation YHTCloseActionGroupElement
- (NSMutableAttributedString*) buildContentText
{
    NSString* output = [NSString stringWithFormat:@"活动[%@]已关闭", _groupName];
    NSMutableAttributedString* mAStr = [[NSMutableAttributedString alloc] initWithString:output];
    return mAStr;
}

@end
