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

@interface CCRuntime : NSObject

@end

@class CCProtocol;
@class CCIvar;
@class CCProperty;
@class CCMethod;
@class CCUnregisteredClass;

@interface NSObject (CCRuntime)

// includes the receiver
+ (NSArray *)cc_subclasses;

+ (CCUnregisteredClass *)cc_createUnregisteredSubclassNamed: (NSString *)name;
+ (Class)cc_createSubclassNamed: (NSString *)name;
+ (void)cc_destroyClass;

+ (BOOL)cc_isMetaClass;
+ (Class)cc_setSuperclass: (Class)newSuperclass;
+ (size_t)cc_instanceSize;

+ (NSArray *)cc_protocols;

+ (NSArray *)cc_methods;
+ (CCMethod *)cc_methodForSelector: (SEL)sel;

+ (void)cc_addMethod: (CCMethod *)method;

+ (NSArray *)cc_ivars;
+ (CCIvar *)cc_ivarForName: (NSString *)name;

+ (NSArray *)cc_properties;
+ (CCProperty *)cc_propertyForName: (NSString *)name;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
+ (BOOL)cc_addProperty: (CCProperty *)property;
#endif

// Apple likes to fiddle with -class to hide their dynamic subclasses
// e.g. KVO subclasses, so [obj class] can lie to you
// cc_class is a direct call to object_getClass (which in turn
// directly hits up the isa) so it will always tell the truth
- (Class)cc_class;
- (Class)cc_setClass: (Class)newClass;

@end
