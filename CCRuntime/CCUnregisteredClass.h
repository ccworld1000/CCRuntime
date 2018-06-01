//
//  CCUnregisteredClass.h
//  CCRuntimeDemo
//
//  Created by dengyouhua on 31/05/2018.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface CCUnregisteredClass : NSObject
//
//@end

@class CCProtocol;
@class CCIvar;
@class CCMethod;
@class CCProperty;

@interface CCUnregisteredClass : NSObject
{
    Class _class;
}

+ (id)unregisteredClassWithName: (NSString *)name withSuperclass: (Class)superclass;
+ (id)unregisteredClassWithName: (NSString *)name;

- (id)initWithName: (NSString *)name withSuperclass: (Class)superclass;
- (id)initWithName: (NSString *)name;

- (void)addProtocol: (CCProtocol *)protocol;
- (void)addIvar: (CCIvar *)ivar;
- (void)addMethod: (CCMethod *)method;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
- (void)addProperty: (CCProperty *)property;
#endif

- (Class)registerClass;

@end



