//
//  OCHandMock - HMAbstractExpectation.m
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import "HMAbstractExpectation.h"

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCHamcrestIOS/HCStringDescription.h>


// As of 2010-09-09, the iPhone simulator has a bug where you can't catch exceptions when they are
// thrown across NSInvocation boundaries. (See http://openradar.appspot.com/8081169 ) So instead of
// using an NSInvocation to call -failWithException: without linking in SenTestingKit, we simply
// pretend it exists on NSObject.
@interface NSObject (HMExceptionBugHack)
- (void)failWithException:(NSException *)exception;
@end

@interface HMAbstractExpectation ()
@property(nonatomic, copy, readwrite) NSString *name;
@property(nonatomic, assign) id testCase;
@property(nonatomic, assign) BOOL failureModeIsImmediate;
@property(nonatomic, assign) BOOL hasExpectations;
- (void)subclassResponsibility:(SEL)command;
@end

#define ABSTRACT_METHOD [self subclassResponsibility:_cmd]


@implementation HMAbstractExpectation

@synthesize name;
@synthesize testCase;
@synthesize failureModeIsImmediate;
@synthesize hasExpectations;


- (id)initWithName:(NSString *)aName testCase:(id)test
{
    self = [super init];
    if (self)
    {
        name = [aName copy];
        testCase = test;
        failureModeIsImmediate = YES;
    }
    return self;
}


- (void)dealloc
{
    [name release];    
    [super dealloc];
}


- (BOOL)shouldCheckImmediately
{
    return failureModeIsImmediate && hasExpectations;
}


- (void)setHasExpectations
{
    [self clearActual];
    hasExpectations = YES;
}


- (void)assertExpectedUnsignedInteger:(NSUInteger)expectedValue
          equalsActualUnsignedInteger:(NSUInteger)actualValue
                              message:(NSString *)message
{
    [self assertExpectedValue:[NSNumber numberWithUnsignedInteger:expectedValue]
            equalsActualValue:[NSNumber numberWithUnsignedInteger:actualValue]
                      message:message];
}


- (void)assertExpectedValue:(id)expectedValue
          equalsActualValue:(id)actualValue
                    message:(NSString *)message
{
    HCIsEqual *isEqual = [HCIsEqual isEqualTo:expectedValue];
    if (![isEqual matches:actualValue])
    {
        HCStringDescription *description = [HCStringDescription stringDescription];
        [[description appendText:name] appendText:@" "];
        if (message != nil)
            [[description appendText:message] appendText:@" "];
        [[[description appendText:@"Expected "]
                       appendDescriptionOf:expectedValue]
                       appendText:@", but "];
        [isEqual describeMismatchOf:actualValue to:description];
        [self failWithReason:[description description]];
    }
}


- (void)failWithReason:(NSString *)reason
{
    NSException *exception = [NSException exceptionWithName:@"SenTestFailureException"
                                                     reason:reason
                                                   userInfo:nil];
    [testCase failWithException:exception];
}


- (void)subclassResponsibility:(SEL)command
{
	NSString *className = NSStringFromClass([self class]);
    [NSException raise:NSGenericException
                format:@"-[%@ %s] not implemented", className, command];
}


#pragma mark -
#pragma mark HMExpectations

- (BOOL)hasExpectations
{
    return hasExpectations;
}


- (void)setFailOnVerify
{
    failureModeIsImmediate = NO;
}


#pragma mark -
#pragma mark Subclasses must implement

- (void)clearActual
{
    ABSTRACT_METHOD;
}


- (void)setExpectNothing
{
    ABSTRACT_METHOD;
}


- (void)verify
{
    ABSTRACT_METHOD;
}

@end
