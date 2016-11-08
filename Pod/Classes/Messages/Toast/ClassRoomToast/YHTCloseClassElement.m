//
//  YHTCloseClassElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHTCloseClassElement.h"

@implementation YHTCloseClassElement
- (NSMutableAttributedString*) buildContentText
{
    NSString* output = [NSString stringWithFormat:@"班级[%@]已经解散", _className];
    NSMutableAttributedString* mAStr = [[NSMutableAttributedString alloc] initWithString:output];
    return mAStr;
}
@end
