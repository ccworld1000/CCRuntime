//
//  ViewController.m
//  CCRuntimeDemo
//
//  Created by dengyouhua on 30/05/2018.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "CCRuntimeTest.h"

static NSString *NewDescription (id self, SEL _cmd) {
    return @"CC Test";
}

@interface ViewController ()

@end

@implementation ViewController


- (void) methodModifying {
    NSLog(@"////////////////////////////////////////////\n\n");
    
    CCMethod *description = [NSObject cc_methodForSelector:@selector(description)];
    [description setImplementation:(IMP)NewDescription];
    
    NSLog(@"%@", [self description]);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [CCRuntimeTest classQuerying];
    [self methodModifying];
}

@end
