//
//  CCProtocol.h
//  CCRuntime
//
//  Created by dengyouhua on 31/05/2018.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface CCProtocol : NSObject

+ (NSArray *)allProtocols;

+ (id)protocolWithObjCProtocol: (Protocol *)protocol;
+ (id)protocolWithName: (NSString *)name;

- (id)initWithObjCProtocol: (Protocol *)protocol;
- (id)initWithName: (NSString *)name;

- (Protocol *)objCProtocol;
- (NSString *)name;
- (NSArray *)incorporatedProtocols;
- (NSArray *)methodsRequired: (BOOL)isRequiredMethod instance: (BOOL)isInstanceMethod;

@end
