//
//  OCHandMock - HMExpectationCounter.h
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import "HMAbstractExpectation.h"


@interface HMExpectationCounter : HMAbstractExpectation

- (id)initWithName:(NSString *)aName testCase:(id)test;

- (void)setExpected:(NSUInteger)expected;

- (void)increment;

@end
