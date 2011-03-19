//
//  OCHandMock - HMExpectationCounter.m
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import "HMExpectationCounter.h"

#import <OCHamcrestIOS/HCStringDescription.h>


@interface HMExpectationCounter ()
@property(nonatomic, assign) NSUInteger expectedCalls;
@property(nonatomic, assign) NSUInteger actualCalls;
@end


@implementation HMExpectationCounter

@synthesize expectedCalls;
@synthesize actualCalls;


- (id)initWithName:(NSString *)aName testCase:(id)test;
{
    self = [super initWithName:aName testCase:test];
    return self;
}


- (void)setExpected:(NSUInteger)expected
{
    expectedCalls = expected;
    [self setHasExpectations];
}


- (void)increment
{
    ++actualCalls;
    if ([self shouldCheckImmediately] && actualCalls > expectedCalls)
    {
        NSNumber *expectedNumber = [NSNumber numberWithUnsignedInteger:expectedCalls];
        HCStringDescription *description = [HCStringDescription stringDescription];
        [[[[description appendText:[self name]]
                        appendText:@" should not be called more than "]
                        appendDescriptionOf:expectedNumber]
                        appendText:@" times"];
        [self failWithReason:[description description]];
    }
}


#pragma mark -
#pragma mark HMAbstractExpectation implementation

- (void)clearActual
{
    actualCalls = 0;
}


- (void)setExpectNothing
{
    [self setExpected:0];
}


- (void)verify
{
    [self assertExpectedUnsignedInteger:expectedCalls
            equalsActualUnsignedInteger:actualCalls
                                message:@"did not receive the expected Count."];
}

@end
