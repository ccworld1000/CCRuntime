//
//  CCProperty.h
//  CCRuntimeDemo
//
//  Created by dengyouhua on 31/05/2018.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

FOUNDATION_EXPORT NSString * const CCPropertyTypeEncodingAttribute;
FOUNDATION_EXPORT NSString * const CCPropertyBackingIVarNameAttribute;

FOUNDATION_EXPORT NSString * const CCPropertyCopyAttribute;
FOUNDATION_EXPORT NSString * const CCPropertyRetainAttribute;
FOUNDATION_EXPORT NSString * const CCPropertyCustomGetterAttribute;
FOUNDATION_EXPORT NSString * const CCPropertyCustomSetterAttribute;
FOUNDATION_EXPORT NSString * const CCPropertyDynamicAttribute;
FOUNDATION_EXPORT NSString * const CCPropertyEligibleForGarbageCollectionAttribute;
FOUNDATION_EXPORT NSString * const CCPropertyNonAtomicAttribute;
FOUNDATION_EXPORT NSString * const CCPropertyOldTypeEncodingAttribute;
FOUNDATION_EXPORT NSString * const CCPropertyReadOnlyAttribute;
FOUNDATION_EXPORT NSString * const CCPropertyWeakReferenceAttribute;

typedef NS_ENUM(NSInteger, CCPropertySetterSemantics) {
    CCPropertySetterSemanticsAssign,
    CCPropertySetterSemanticsRetain,
    CCPropertySetterSemanticsCopy
};

@interface CCProperty : NSObject

+ (instancetype)propertyWithObjCProperty: (objc_property_t)property;
+ (instancetype)propertyWithName: (NSString *)name attributes:(NSDictionary *)attributes;

- (instancetype)initWithObjCProperty: (objc_property_t)property;
- (instancetype)initWithName: (NSString *)name attributes:(NSDictionary *)attributes;

- (NSDictionary *)attributes;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
- (BOOL)addToClass:(Class)classToAddTo;
#endif

- (NSString *)attributeEncodings;
- (BOOL)isReadOnly;
- (CCPropertySetterSemantics)setterSemantics;
- (BOOL)isNonAtomic;
- (BOOL)isDynamic;
- (BOOL)isWeakReference;
- (BOOL)isEligibleForGarbageCollection;
- (SEL)customGetter;
- (SEL)customSetter;
- (NSString *)name;
- (NSString *)typeEncoding;
- (NSString *)oldTypeEncoding;
- (NSString *)ivarName;

@end
