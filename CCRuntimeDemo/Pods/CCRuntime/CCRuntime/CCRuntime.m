//
//  CCRuntime.m
//  CCRuntimeDemo
//
//  Created by dengyouhua on 30/05/2018.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import "CCRuntime.h"
#import <objc/runtime.h>

@implementation CCRuntime

@end

@implementation NSObject (CCRuntime)

+ (NSArray *)cc_subclasses
{
    int count = objc_getClassList(NULL, 0);
    Class buffer[count];
    count = objc_getClassList(buffer, count);

    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0; i < count; i++)
    {
        Class candidate = buffer[i];
        Class superclass = candidate;
        while(superclass)
        {
            if(superclass == self)
            {
                [array addObject: candidate];
                break;
            }
            superclass = class_getSuperclass(superclass);
        }
    }

    return array;
}

+ (CCUnregisteredClass *)cc_createUnregisteredSubclassNamed: (NSString *)name
{
    return [CCUnregisteredClass unregisteredClassWithName: name withSuperclass: self];
}

+ (Class)cc_createSubclassNamed: (NSString *)name
{
    return [[self cc_createUnregisteredSubclassNamed: name] registerClass];
}

+ (void)cc_destroyClass
{
    objc_disposeClassPair(self);
}

+ (BOOL)cc_isMetaClass
{
    return class_isMetaClass(self);
}

#ifdef __clang__
#pragma clang diagnostic push
#endif
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+ (Class)cc_setSuperclass: (Class)newSuperclass
{
    return class_setSuperclass(self, newSuperclass);
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif

+ (size_t)cc_instanceSize
{
    return class_getInstanceSize(self);
}

+ (NSArray *)cc_protocols
{
    unsigned int count;
    __unsafe_unretained Protocol **protocols = class_copyProtocolList(self, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [CCProtocol protocolWithObjCProtocol: protocols[i]]];
    
    free(protocols);
    return array;
}

+ (NSArray *)cc_methods
{
    unsigned int count;
    Method *methods = class_copyMethodList(self, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [CCMethod methodWithObjCMethod: methods[i]]];
    
    free(methods);
    return array;
}

+ (CCMethod *)cc_methodForSelector: (SEL)sel
{
    Method m = class_getInstanceMethod(self, sel);
    if(!m) return nil;
    
    return [CCMethod methodWithObjCMethod: m];
}

+ (void)cc_addMethod: (CCMethod *)method
{
    class_addMethod(self, [method selector], [method implementation], [[method signature] UTF8String]);
}

+ (NSArray *)cc_ivars
{
    unsigned int count;
    Ivar *list = class_copyIvarList(self, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [CCIvar ivarWithObjCIvar: list[i]]];
    
    free(list);
    return array;
}

+ (CCIvar *)cc_ivarForName: (NSString *)name
{
    Ivar ivar = class_getInstanceVariable(self, [name UTF8String]);
    if(!ivar) return nil;
    return [CCIvar ivarWithObjCIvar: ivar];
}

+ (NSArray *)cc_properties
{
    unsigned int count;
    objc_property_t *list = class_copyPropertyList(self, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [CCProperty propertyWithObjCProperty: list[i]]];
    
    free(list);
    return array;
}

+ (CCProperty *)cc_propertyForName: (NSString *)name
{
    objc_property_t property = class_getProperty(self, [name UTF8String]);
    if(!property) return nil;
    return [CCProperty propertyWithObjCProperty: property];
}

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
+ (BOOL)cc_addProperty: (CCProperty *)property
{
    return [property addToClass:self];
}
#endif

- (Class)cc_class
{
    return object_getClass(self);
}

- (Class)cc_setClass: (Class)newClass
{
    return object_setClass(self, newClass);
}

@end
