//
//  ViewController.m
//  CCRuntimeOSX
//
//  Created by dengyouhua on 2018/6/8.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "CCRuntimeTest.h"

static NSString *NewDescription (id self, SEL _cmd) {
    return @"CC Test for OSX";
}

@implementation ViewController

- (void) methodModifying {
    NSLog(@"////////////////////////////////////////////\n\n");
    
    CCMethod *description = [NSObject cc_methodForSelector:@selector(description)];
    [description setImplementation:(IMP)NewDescription];
    
    NSLog(@"%@", [self description]);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [CCRuntimeTest classQuerying];
    [self methodModifying];
}


@end
