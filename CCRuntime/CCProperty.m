//
//  CCProperty.m
//  CCRuntime
//
//  Created by dengyouhua on 31/05/2018.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import "CCProperty.h"

NSString * const CCPropertyTypeEncodingAttribute                  = @"T";
NSString * const CCPropertyBackingIVarNameAttribute               = @"V";
NSString * const CCPropertyCopyAttribute                          = @"C";
NSString * const CCPropertyCustomGetterAttribute                  = @"G";
NSString * const CCPropertyCustomSetterAttribute                  = @"S";
NSString * const CCPropertyDynamicAttribute                       = @"D";
NSString * const CCPropertyEligibleForGarbageCollectionAttribute  = @"P";
NSString * const CCPropertyNonAtomicAttribute                     = @"N";
NSString * const CCPropertyOldTypeEncodingAttribute               = @"t";
NSString * const CCPropertyReadOnlyAttribute                      = @"R";
NSString * const CCPropertyRetainAttribute                        = @"&";
NSString * const CCPropertyWeakReferenceAttribute                 = @"W";

@interface CCObjCProperty : CCProperty
{
    objc_property_t _property;
    NSMutableDictionary *_attrs;
    NSString *_name;
}
@end

@implementation CCObjCProperty

- (instancetype)initWithObjCProperty: (objc_property_t)property
{
    if((self = [self init]))
    {
        _property = property;
        NSArray *attrPairs = [[NSString stringWithUTF8String: property_getAttributes(property)] componentsSeparatedByString: @","];
        _attrs = [[NSMutableDictionary alloc] initWithCapacity:[attrPairs count]];
        for(NSString *attrPair in attrPairs)
            [_attrs setObject:[attrPair substringFromIndex:1] forKey:[attrPair substringToIndex:1]];
    }
    return self;
}

- (instancetype)initWithName: (NSString *)name attributes:(NSDictionary *)attributes
{
    if((self = [self init]))
    {
        _name = [name copy];
        _attrs = [attributes copy];
    }
    return self;
}

- (NSString *)name
{
    if (_property)
        return [NSString stringWithUTF8String: property_getName(_property)];
    else
        return _name;
}

- (NSDictionary *)attributes
{
    return [_attrs copy];
}

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
- (BOOL)addToClass:(Class)classToAddTo
{
    NSDictionary *attrs = [self attributes];
    objc_property_attribute_t *cattrs = (objc_property_attribute_t*)calloc([attrs count], sizeof(objc_property_attribute_t));
    unsigned attrIdx = 0;
    for (NSString *attrCode in attrs) {
        cattrs[attrIdx].name = [attrCode UTF8String];
        cattrs[attrIdx].value = [[attrs objectForKey:attrCode] UTF8String];
        attrIdx++;
    }
    BOOL result = class_addProperty(classToAddTo,
                                    [[self name] UTF8String],
                                    cattrs,
                                    [attrs count]);
    free(cattrs);
    return result;
}
#endif

- (NSString *)attributeEncodings
{
    NSMutableArray *filteredAttributes = [NSMutableArray arrayWithCapacity:[_attrs count] - 2];
    for (NSString *attrKey in _attrs)
    {
        if (![attrKey isEqualToString:CCPropertyTypeEncodingAttribute] && ![attrKey isEqualToString:CCPropertyBackingIVarNameAttribute])
            [filteredAttributes addObject:[_attrs objectForKey:attrKey]];
    }
    return [filteredAttributes componentsJoinedByString: @","];
}

- (BOOL)hasAttribute: (NSString *)code
{
    return [_attrs objectForKey:code] != nil;
}

- (BOOL)isReadOnly
{
    return [self hasAttribute: CCPropertyReadOnlyAttribute];
}

- (CCPropertySetterSemantics)setterSemantics
{
    if([self hasAttribute: CCPropertyCopyAttribute]) return CCPropertySetterSemanticsCopy;
    if([self hasAttribute: CCPropertyRetainAttribute]) return CCPropertySetterSemanticsRetain;
    return CCPropertySetterSemanticsAssign;
}

- (BOOL)isNonAtomic
{
    return [self hasAttribute: CCPropertyNonAtomicAttribute];
}

- (BOOL)isDynamic
{
    return [self hasAttribute: CCPropertyDynamicAttribute];
}

- (BOOL)isWeakReference
{
    return [self hasAttribute: CCPropertyWeakReferenceAttribute];
}

- (BOOL)isEligibleForGarbageCollection
{
    return [self hasAttribute: CCPropertyEligibleForGarbageCollectionAttribute];
}

- (NSString *)contentOfAttribute: (NSString *)code
{
    return [_attrs objectForKey:code];
}

- (SEL)customGetter
{
    return NSSelectorFromString([self contentOfAttribute: CCPropertyCustomGetterAttribute]);
}

- (SEL)customSetter
{
    return NSSelectorFromString([self contentOfAttribute: CCPropertyCustomSetterAttribute]);
}

- (NSString *)typeEncoding
{
    return [self contentOfAttribute: CCPropertyTypeEncodingAttribute];
}

- (NSString *)oldTypeEncoding
{
    return [self contentOfAttribute: CCPropertyOldTypeEncodingAttribute];
}

- (NSString *)ivarName
{
    return [self contentOfAttribute: CCPropertyBackingIVarNameAttribute];
}

@end

@implementation CCProperty

+ (instancetype)propertyWithObjCProperty: (objc_property_t)property
{
    return [[self alloc] initWithObjCProperty: property];
}

+ (instancetype)propertyWithName: (NSString *)name attributes:(NSDictionary *)attributes
{
    return [[self alloc] initWithName: name attributes: attributes];
}

- (instancetype)initWithObjCProperty: (objc_property_t)property
{
    return [[CCObjCProperty alloc] initWithObjCProperty: property];
}

- (instancetype)initWithName: (NSString *)name attributes:(NSDictionary *)attributes
{
    return [[CCObjCProperty alloc] initWithName: name attributes: attributes];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@ %p: %@ %@ %@ %@>", [self class], self, [self name], [self attributeEncodings], [self typeEncoding], [self ivarName]];
}

- (BOOL)isEqual: (id)other
{
    return [other isKindOfClass: [CCProperty class]] &&
    [[self name] isEqual: [other name]] &&
    ([self attributeEncodings] ? [[self attributeEncodings] isEqual: [other attributeEncodings]] : ![other attributeEncodings]) &&
    [[self typeEncoding] isEqual: [other typeEncoding]] &&
    ([self ivarName] ? [[self ivarName] isEqual: [other ivarName]] : ![other ivarName]);
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

- (NSDictionary *)attributes
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (BOOL)addToClass:(Class)classToAddTo
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (NSString *)attributeEncodings
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (BOOL)isReadOnly
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}
- (CCPropertySetterSemantics)setterSemantics
{
    [self doesNotRecognizeSelector: _cmd];
    return CCPropertySetterSemanticsAssign;
}

- (BOOL)isNonAtomic
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (BOOL)isDynamic
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (BOOL)isWeakReference
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (BOOL)isEligibleForGarbageCollection
{
    [self doesNotRecognizeSelector: _cmd];
    return NO;
}

- (SEL)customGetter
{
    [self doesNotRecognizeSelector: _cmd];
    return (SEL)0;
}

- (SEL)customSetter
{
    [self doesNotRecognizeSelector: _cmd];
    return (SEL)0;
}

- (NSString *)typeEncoding
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSString *)oldTypeEncoding
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSString *)ivarName
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

@end
