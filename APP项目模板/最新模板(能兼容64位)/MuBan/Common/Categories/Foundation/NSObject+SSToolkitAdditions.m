//
//  NSObject+SSToolkitAdditions.m
//  o2o
//
//  Created by swift on 14-8-18.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "NSObject+SSToolkitAdditions.h"

@implementation NSObject (SSToolkitAdditions)

- (BOOL)isSafeObject
{
    return ![self isKindOfClass:[NSNull class]];
}

- (BOOL)isValidString {
    return NO;
}

- (BOOL)isValidNumber {
    return NO;
}

- (BOOL)isValidArray {
    return NO;
}

- (BOOL)isValidDictionary {
    return NO;
}

- (BOOL)isValidData {
    return NO;
}


@end
