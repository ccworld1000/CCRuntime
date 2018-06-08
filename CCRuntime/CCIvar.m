//
//  CCIvar.m
//  CCRuntime
//
//  Created by dengyouhua on 31/05/2018.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import "CCIvar.h"


@interface CCObjCIvar : CCIvar
{
    Ivar _ivar;
}
@end

@implementation CCObjCIvar

- (instancetype)initWithObjCIvar: (Ivar)ivar
{
    if((self = [self init]))
    {
        _ivar = ivar;
    }
    return self;
}

- (NSString *)name
{
    return [NSString stringWithUTF8String: ivar_getName(_ivar)];
}

- (NSString *)typeEncoding
{
    return [NSString stringWithUTF8String: ivar_getTypeEncoding(_ivar)];
}

- (ptrdiff_t)offset
{
    return ivar_getOffset(_ivar);
}

@end

@interface CCComponentsIvar : CCIvar

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * typeEncoding;

@end

@implementation CCComponentsIvar

- (instancetype)initWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding
{
    if((self = [self init]))
    {
        _name = [name copy];
        _typeEncoding = [typeEncoding copy];
    }
    return self;
}

- (NSString *)name
{
    return _name;
}

- (NSString *)typeEncoding
{
    return _typeEncoding;
}

- (ptrdiff_t)offset
{
    return -1;
}

@end

@implementation CCIvar

+ (instancetype)ivarWithObjCIvar: (Ivar)ivar
{
    return [[self alloc] initWithObjCIvar: ivar];
}

+ (instancetype)ivarWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding
{
    return [[self alloc] initWithName: name typeEncoding: typeEncoding];
}

+ (instancetype)ivarWithName: (NSString *)name encode: (const char *)encodeStr
{
    return [self ivarWithName: name typeEncoding: [NSString stringWithUTF8String: encodeStr]];
}

- (instancetype)initWithObjCIvar: (Ivar)ivar
{
    return [[CCObjCIvar alloc] initWithObjCIvar: ivar];
}

- (instancetype)initWithName: (NSString *)name typeEncoding: (NSString *)typeEncoding
{
    return [[CCComponentsIvar alloc] initWithName: name typeEncoding: typeEncoding];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@ %p: %@ %@ %ld>", [self class], self, [self name], [self typeEncoding], (long)[self offset]];
}

- (BOOL)isEqual: (id)other
{
    return [other isKindOfClass: [CCIvar class]] &&
    [[self name] isEqual: [other name]] &&
    [[self typeEncoding] isEqual: [other typeEncoding]];
}

- (NSUInteger)hash
{
    return [[self name] hash] ^ [[self typeEncoding] hash];
}

- (NSString *)name
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSString *)typeEncoding
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (ptrdiff_t)offset
{
    [self doesNotRecognizeSelector: _cmd];
    return 0;
}

@end
