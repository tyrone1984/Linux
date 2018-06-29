//
//  NSObject+JWArchiver.h
//  ControlTemp
//
//  Created by zjw7sky on 16/1/6.
//  Copyright © 2016年 zjw7sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JWArchiver)

+ (id)jw_unArchiver;

- (void)jw_archiver;

@end
