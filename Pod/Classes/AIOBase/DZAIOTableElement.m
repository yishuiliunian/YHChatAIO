//
//  DZAIOTableElement.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZAIOTableElement.h"

@implementation DZAIOTableElement
@synthesize AIOToolbarType = _AIOToolbarType;
@synthesize inputViewController = _inputViewController;
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _AIOToolbarType = DZAIOToolbarTypeNormal;
    return self;
}
@end
