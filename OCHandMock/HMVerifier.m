//
//  OCHandMock - HMVerifier.m
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import "HMVerifier.h"

#import "HMVerifiable.h"
#import <objc/runtime.h>


static NSMutableArray *processingObjects = nil;


@interface HMVerifier ()
+ (void)verifyIvarsAtClassLevel:(Class)class inObject:(id)object;
+ (BOOL)isAlreadyProcessing:(id)object;
+ (void)startProcessing:(id)object;
+ (void)finishedProcessing:(id)object;
+ (void)verifyIvar:(Ivar)ivar inObject:(id)object;
+ (BOOL)isNotAnObject:(Ivar)ivar;
+ (BOOL)isVerifiable:(id)object;
@end


@implementation HMVerifier

+ (void)initialize
{
    if (self == [HMVerifier class])
        processingObjects = [[NSMutableArray alloc] init];
}


+ (void)verify:(id)object
{
    @synchronized(self)
    {
        [self verifyIvarsAtClassLevel:[object class] inObject:object];
    }
}


+ (void)verifyIvarsAtClassLevel:(Class)class inObject:(id)object
{
    if (class == Nil)
        return;
    
    if ([self isAlreadyProcessing:object])
        return;
    
    [self verifyIvarsAtClassLevel:[class superclass] inObject:(id)object];

    [self startProcessing:object];
    unsigned int ivarCount;
    Ivar *ivars = class_copyIvarList(class, &ivarCount);
    
    for (unsigned int ivarIndex = 0; ivarIndex < ivarCount; ++ivarIndex)
        [self verifyIvar:ivars[ivarIndex] inObject:object];
    
    free(ivars);
    [self finishedProcessing:object];
}


+ (BOOL)isAlreadyProcessing:(id)object
{
    return [processingObjects containsObject:object];
}


+ (void)startProcessing:(id)object
{
    [processingObjects addObject:object];
}


+ (void)finishedProcessing:(id)object
{
    [processingObjects removeObject:object];
}


+ (void)verifyIvar:(Ivar)ivar inObject:(id)object
{
    if ([self isNotAnObject:ivar])
        return;
    
    id ivarObject = object_getIvar(object, ivar);
    
    if ([self isVerifiable:ivarObject] && ![self isAlreadyProcessing:ivarObject])
        [ivarObject verify];
}


+ (BOOL)isNotAnObject:(Ivar)ivar
{
    return ivar_getTypeEncoding(ivar)[0] != '@';
}


+ (BOOL)isVerifiable:(id)object
{
    return [object conformsToProtocol:@protocol(HMVerifiable)];
}

@end
