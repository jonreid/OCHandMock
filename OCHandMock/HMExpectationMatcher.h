//
//  OCHandMock - HMExpectationMatcher.h
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import "HMAbstractExpectation.h"

@protocol HCMatcher;


/**
    Verifies that argument satisfies OCHamcrest matcher.
 */
@interface HMExpectationMatcher : HMAbstractExpectation

@property(nonatomic, retain, readonly) id<NSObject> actualArgument;

- (id)initWithName:(NSString *)aName testCase:(id)test;

- (void)setExpected:(id<HCMatcher, NSObject>)aMatcher;

- (void)setActual:(id)actual;

@end
