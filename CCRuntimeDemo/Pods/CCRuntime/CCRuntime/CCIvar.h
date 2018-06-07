//
//  CCIvar.h
//  CCRuntimeDemo
//
//  Created by dengyouhua on 31/05/2018.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface CCIvar : NSObject

+ (instancetype)ivarWithObjCIvar: (Ivar)ivar;
+ (instancetype)ivarWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding;
+ (instancetype)ivarWithName: (NSString *)name encode: (const char *)encodeStr;

- (instancetype)initWithObjCIvar: (Ivar)ivar;
- (instancetype)initWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding;

- (NSString *)name;
- (NSString *)typeEncoding;
- (ptrdiff_t)offset;

@end
