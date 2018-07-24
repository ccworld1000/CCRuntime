CCRuntime
-------------
(CCRuntime 转换 MAObjCRuntime 为 ARC 模式)

CCRuntime 是基于Objective-C 运行时封装的APIs集. 如果令人困惑, 它提供友好的面向对象接口基于/usr/include/objc中的C函数.

CCRuntime在BSD许可证下发布的。对于官方许可证，请参阅许可证文件。 

多国语言翻译
-------------

[英文README](README.md)

快速开始
-----------

The action begins in `CCRuntime.h`. Various methods are added to `NSObject` to allow querying and manipulation. Most of these are class methods, because they operate on classes. There are a couple of instance methods as well. All of these methods start with `cc_` to avoid name conflicts. The `CCMethod` and `CCIvar` classes are used to represent a single method and a single instance variable, respectively. Their use should be fairly obvious.

查询
--------

You can query any class's methods, instance variables, or other attributes using the methods provided. For example:

    // get all subclasses of a class
    NSArray *subclasses = [MyClass cc_subclasses];
    
    // check out the methods on NSString
    NSArray *methods = [NSString cc_methods];
    for(CCMethod *method in methods)
        NSLog(@"%@", method);
    
    // does it have any ivars?
    NSLog(@"%@", [NSString cc_ivars]);
    
    // how big is a constant string instance?
    NSLog(@"%ld", (long)[[@"foo" cc_class] cc_instanceSize]);

修改
---------

You can add new methods using `+cc_addMethod:`. You can modify the implementation of an existing method using the `-setImplementation:` method on `CCMethod`. Example:

    // swizzle out -[NSObject description] (don't do this)
    static NSString *NewDescription(id self, SEL _cmd)
    {
        return @"HELLO WORLD!";
    }
    
    CCMethod *description = [NSObject cc_methodForSelector: @selector(description)];
    [description setImplementation: (IMP)NewDescription];

You can create new classes using `+cc_createSubclassNamed:` or `+cc_createUnregisteredSubclassNamed:`. Note that if you want to add instance variables to a class then you have to use the Unregistered version, and add them before registering the class.

Objects
-------

Two instance methods are provided as well. `-cc_class` exists because Apple likes to fiddle with the return value of `-class`, and `-cc_class` always gives you the right value. `-cc_setClass:` does pretty much what it says: sets the class of the object. It won't reallocate the object or anything, so the new class had better have a memory layout that's compatible with the old one, or else hilarity will ensue.

发送消息
----------------

After getting a list of methods from a class, it's common to want to actually use those on instances of the class. `CCMethod` provides an easy method for doing this, as well as several convenience wrappers around it.

The basic method for sending messages is `-[CCMethod returnValue:sendToTarget:]`. You use it like this:

    CCMethod *method = ...;
    SomeType ret;
    [method returnValue: &ret sendToTarget: obj, CCARG(@"hello"), CCARG(42), CCARG(xyz)];

It may seem odd to have the return value at the beginning of the argument list, but this comes closest to the order of the normal `ret = [obj method]` syntax.

All arguments must be wrapped in the `CCARG` macro. This macro takes care of packaging up each argument so that it can survive passage through the variable argument list and also includes some extra metadata about the argument types so that the code can do some basic sanity checking. No automatic type conversions are performed. If you pass a `double` to a method that expects an `int`, this method will `abort`. That checking is only based on size, however, so if you pass a `float` where an `int` is expected, you'll just get a bad value.

Note that while it's not 100% guaranteed, this code does a generally good job of detecting if you forgot to use the `CCARG` macro and warning you loudly and calling `abort` instead of simply crashing in a mysterious manner. Also note that there is no sanity checking on the return value, so it's your responsibility to ensure that you use the right type and have enough space to hold it.

For methods which return an object, the `-[CCMethod sendToTarget:]` method is provided which directly returns `id` instead of making you use return-by-reference. This simplifies the calling of such methods:

    CCMethod *method = ...;
    id ret = [method sendToTarget: obj, CCARG(@"hello"), CCARG(42), CCARG(xyz)];

There is also an `NSObject` category which provides methods that allows you to switch the order around to be more natural. For example:

    CCMethod *method = ...;
    id ret = [obj cc_sendMethod: method, CCARG(@"hello"), CCARG(42), CCARG(xyz)];

And the same idea for `cc_returnValue:sendMethod:`.

Finally, there are a pair of convenience methods that take a selector, and combine the method lookup with the actual message sending:

    id ret = [obj cc_sendSelector: @selector(...), CCARG(@"hello"), CCARG(42), CCARG(xyz)];
    SomeType ret2;
    [obj cc_returnValue: &ret2 sendSelector: @selector(...), CCARG(12345)];

### BSD
***

BSD 3-Clause License

Copyright (c) 2018-now ccworld1000 | bug : <a href="mailto:2291108617@qq.com">2291108617@qq.com</a> and <a href="mailto:ccworld1000@gmail.com">ccworld1000@gmail.com</a>

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


***
### 其他许可证
***

[MAObjCRuntime LICENSE](LICENSE.MAObjCRuntime.txt) 
