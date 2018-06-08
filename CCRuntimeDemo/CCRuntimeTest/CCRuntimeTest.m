//
//  CCRuntimeTest.m
//  CCRuntimeDemo
//
//  Created by dengyouhua on 2018/6/8.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import "CCRuntimeTest.h"

@implementation CCRuntimeTest

+ (void) classQuerying {
    NSLog(@"////////////////////////////////////////////\n\n");
    
    NSArray *subclasses = [[NSString class] cc_subclasses];
    NSLog(@"subclasses : %@", subclasses);
    
    NSLog(@"////////////////////////////////////////////\n\n");
    
    NSArray *methods = [NSString cc_methods];
    for (CCMethod *method in methods) {
        NSLog(@"%@", method);
    }
    
    NSLog(@"////////////////////////////////////////////\n\n");
    
    NSLog(@"%@", [NSString cc_ivars]);
    
    NSLog(@"////////////////////////////////////////////\n\n");
    
    NSLog(@"%ld", (long)[[@"foo" cc_class] cc_instanceSize]);
}


@end
