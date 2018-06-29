//
//  ASingletonClass.m
//  TestPhoto
//
//  Created by ZJ on 14/07/2017.
//  Copyright © 2017 HY. All rights reserved.
//

#import "ASingletonClass.h"

static ASingletonClass *_manager = nil;

@implementation ASingletonClass

+ (id)shareInstance {
    static __weak ASingletonClass *instance;
    ASingletonClass *strongInstance = instance;
    @synchronized(self) {
        if (strongInstance == nil) {
            strongInstance = [[[self class] alloc] init];
            instance = strongInstance;
        }
    }
    
    return strongInstance;
}

+ (instancetype)shareManager {
    if (!_manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _manager = [[ASingletonClass alloc] init];
        });
    }
    
    return _manager;
}
@end
