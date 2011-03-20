//
//  OCHandMock - HMVerifiable.h
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import <Foundation/Foundation.h>


/**
    An HMVerifiable is an object that can confirm at the end of a unit test that the correct
    behavior has occurred.
 
    @see HMVerifier to check all the HMVerifiables in an object.
 */
@protocol HMVerifiable <NSObject>

/// Triggers unit test failure if any expectations have not been met.
- (void)verify;

@end
