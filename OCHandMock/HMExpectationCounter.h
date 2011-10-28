//
//  OCHandMock - HMExpectationCounter.h
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import "HMAbstractExpectation.h"


/**
    Verifies that incremented count matches expectation.
 */
@interface HMExpectationCounter : HMAbstractExpectation

- (id)initWithName:(NSString *)aName testCase:(id)test;

- (void)setExpected:(NSUInteger)expected;

- (void)increment;

- (void)ignoreFurtherIncrements;

@end
