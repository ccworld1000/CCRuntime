//
//  ViewController.m
//  CCRuntimeDemo
//
//  Created by dengyouhua on 30/05/2018.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import <CCRuntime/CCRuntime.h>

static NSString *NewDescription (id self, SEL _cmd) {
    return @"CC Test";
}

@interface ViewController ()

@end

@implementation ViewController

- (void) classQuerying {
    NSLog(@"////////////////////////////////////////////\n\n");
    
    NSArray *subclasses = [[self class] cc_subclasses];
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

- (void) methodModifying {
    NSLog(@"////////////////////////////////////////////\n\n");
    
    CCMethod *description = [NSObject cc_methodForSelector:@selector(description)];
    [description setImplementation:(IMP)NewDescription];
    
    NSLog(@"%@", [self description]);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self methodModifying];
}

@end
