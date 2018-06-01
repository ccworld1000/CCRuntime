//
//  CCRuntime.h
//  CCRuntimeDemo
//
//  Created by dengyouhua on 30/05/2018.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCIvar.h"
#import "CCProperty.h"
#import "CCMethod.h"
#import "CCProtocol.h"
#import "CCUnregisteredClass.h"

//@interface CCRuntime : NSObject
//
//@end

@class CCProtocol;
@class CCIvar;
@class CCProperty;
@class CCMethod;
@class CCUnregisteredClass;

@interface NSObject (CCRuntime)

// includes the receiver
+ (NSArray *)rt_subclasses;

+ (CCUnregisteredClass *)rt_createUnregisteredSubclassNamed: (NSString *)name;
+ (Class)rt_createSubclassNamed: (NSString *)name;
+ (void)rt_destroyClass;

+ (BOOL)rt_isMetaClass;
+ (Class)rt_setSuperclass: (Class)newSuperclass;
+ (size_t)rt_instanceSize;

+ (NSArray *)rt_protocols;

+ (NSArray *)rt_methods;
+ (CCMethod *)rt_methodForSelector: (SEL)sel;

+ (void)rt_addMethod: (CCMethod *)method;

+ (NSArray *)rt_ivars;
+ (CCIvar *)rt_ivarForName: (NSString *)name;

+ (NSArray *)rt_properties;
+ (CCProperty *)rt_propertyForName: (NSString *)name;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
+ (BOOL)rt_addProperty: (CCProperty *)property;
#endif

// Apple likes to fiddle with -class to hide their dynamic subclasses
// e.g. KVO subclasses, so [obj class] can lie to you
// rt_class is a direct call to object_getClass (which in turn
// directly hits up the isa) so it will always tell the truth
- (Class)rt_class;
- (Class)rt_setClass: (Class)newClass;

@end
