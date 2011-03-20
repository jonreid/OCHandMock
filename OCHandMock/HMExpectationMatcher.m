//
//  OCHandMock - HMExpectationMatcher.m
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import "HMExpectationMatcher.h"

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCHamcrestIOS/HCStringDescription.h>


@interface HMExpectationMatcher ()
@property(nonatomic, retain, readwrite) id<NSObject> actualArgument;
@property(nonatomic, retain) id<HCMatcher, NSObject> expectedMatch;
@property(nonatomic, assign) BOOL wasInvoked;
- (void)verifyNoExpectations;
- (void)verifyExpectation;
- (void)describeActualArgumentTo:(HCStringDescription *)description;
@end


@implementation HMExpectationMatcher

@synthesize actualArgument;
@synthesize expectedMatch;
@synthesize wasInvoked;


- (id)initWithName:(NSString *)aName testCase:(id)test;
{
    self = [super initWithName:aName testCase:test];
    return self;
}


- (void)dealloc
{
    [actualArgument release];
    [expectedMatch release];
    [super dealloc];
}


- (void)setExpected:(id<HCMatcher, NSObject>)aMatcher
{
    [self setExpectedMatch:aMatcher];
    [self setHasExpectations];
}


- (void)setActual:(id)actual
{
    wasInvoked = YES;
    [self setActualArgument:actual];
    if ([self shouldCheckImmediately])
        [self verify];
}


#pragma mark -
#pragma mark HMAbstractExpectation implementation

- (void)clearActual
{
    wasInvoked = NO;
    [self setActualArgument:nil];
}


- (void)setExpectNothing
{
    [self setExpected:nil];
}


- (void)verify
{
    if (![self hasExpectations])
        return;
    
    if (expectedMatch == nil)
        [self verifyNoExpectations];
    else
        [self verifyExpectation];
}


- (void)verifyNoExpectations
{
    if (wasInvoked)
    {
        HCStringDescription *description = [HCStringDescription stringDescription];
        [[[description appendText:[self name]]
                       appendText:@" expected nothing, but received "]
                       appendDescriptionOf:actualArgument];
        [self failWithReason:[description description]];
    }
}


- (void)verifyExpectation
{
    if (![expectedMatch matches:actualArgument])
    {
        HCStringDescription *description = [HCStringDescription stringDescription];
        [[[[description appendText:[self name]]
                        appendText:@" expected argument "]
                        appendDescriptionOf:expectedMatch]
                        appendText:@", but "];
        [self describeActualArgumentTo:description];
        [self failWithReason:[description description]];
    }
}


- (void)describeActualArgumentTo:(HCStringDescription *)description
{
    if (wasInvoked)
        [expectedMatch describeMismatchOf:actualArgument to:description];
    else
        [description appendText:@"was never invoked"];
}

@end
