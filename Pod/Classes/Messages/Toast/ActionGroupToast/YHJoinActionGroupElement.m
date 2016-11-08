//
//  YHJoinActionGroupElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHJoinActionGroupElement.h"
#import "YHAppearance.h"
#import <Chameleon.h>

@interface YHJoinActionGroupElement()
{

}
@end
@implementation YHJoinActionGroupElement
- (NSMutableAttributedString*) buildContentText
{
    NSString* output = [NSString stringWithFormat:@"[%@]加入了群[%@]", _userNick,_groupName];
    NSMutableAttributedString* mAStr = [[NSMutableAttributedString alloc] initWithString:output];
    return mAStr;
}

@end
