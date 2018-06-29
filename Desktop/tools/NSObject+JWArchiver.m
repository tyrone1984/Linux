//
//  NSObject+JWArchiver.m
//  ControlTemp
//
//  Created by zjw7sky on 16/1/6.
//  Copyright © 2016年 zjw7sky. All rights reserved.
//

#import "NSObject+JWArchiver.h"

@implementation NSObject (JWArchiver)

+ (id)jw_unArchiver{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",NSStringFromClass([self class])]];
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        id model = [unarchiver decodeObjectForKey:NSStringFromClass([self class])];
        [unarchiver finishDecoding];
        return model;
    }
    return nil;
}

- (void)jw_archiver{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:NSStringFromClass([self class])];
    [archiver finishEncoding];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",NSStringFromClass([self class])]];
    
    //写入文件
    [data writeToFile:path atomically:YES];
}

@end
