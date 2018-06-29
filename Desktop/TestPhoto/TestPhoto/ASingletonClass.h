//
//  ASingletonClass.h
//  TestPhoto
//
//  Created by ZJ on 14/07/2017.
//  Copyright © 2017 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASingletonClass : NSObject

@property (nonatomic, assign) NSString *value;

+ (id)shareInstance;
+ (instancetype)shareManager;

@end
