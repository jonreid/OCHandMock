//
//  OCHandMock - HMExpectation.h
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import "HMVerifiable.h"


/**
    An HMExpectation is an object that we set up at the beginning of a unit test to expect certain
    things to happen to it. If it is possible to tell, the HMExpectation will fail as soon as an
    incorrect value has been set.
 
    Call -verify at the end of a unit test to check for missing or incomplete values.

    If no expectations have been set on the object, then no checking will be done and -verify will
    do nothing.
 */
@protocol HMExpectation <HMVerifiable>

/// Returns YES if any expectations have been set on this object.
- (BOOL)hasExpectations;

/**
    Tells the object to expect nothing to happen to it, perhaps because the test is exercising the
    handling of an error. The HMExpectation will fail if any actual values are set.
 
    Note that this is not the same as not setting any expectations, in which case -verify will do
    nothing.
 */
- (void)setExpectNothing;

/**
    If an incorrect actual value is set, defer reporting this as a failure until -verify is called
    on this object.
 */
- (void)setFailOnVerify;

@end
