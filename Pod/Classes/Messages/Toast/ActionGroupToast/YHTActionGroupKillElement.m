//
//  YHTActionGroupKillElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHTActionGroupKillElement.h"

@implementation YHTActionGroupKillElement
- (NSMutableAttributedString*) buildContentText
{
    NSString* output = [NSString stringWithFormat:@"成员[%@]被移出了群[%@]", _userNick, _groupName];
    NSMutableAttributedString* mAStr = [[NSMutableAttributedString alloc] initWithString:output];
    return mAStr;
}
@end
