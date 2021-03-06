//
//  OCHandMock - HMAbstractExpectation.h
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import "HMExpectation.h"


@interface HMAbstractExpectation : NSObject <HMExpectation>

@property(nonatomic, copy, readonly) NSString *name;

- (id)initWithName:(NSString *)aName testCase:(id)test;

- (BOOL)shouldCheckImmediately;

- (void)setHasExpectations;

- (void)clearExpectations;

- (void)assertExpectedUnsignedInteger:(NSUInteger)expectedValue
          equalsActualUnsignedInteger:(NSUInteger)actualValue
                              message:(NSString *)message;

- (void)assertExpectedValue:(id)expectedValue
          equalsActualValue:(id)actualValue
                    message:(NSString *)message;

- (void)failWithReason:(NSString *)reason;

/// Subclasses must implement
- (void)clearActual;

/// Subclasses must implement
- (void)setExpectNothing;

/// Subclasses must implement
- (void)verify;

@end
