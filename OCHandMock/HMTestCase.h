//
//  OCHandMock - HMTestCase.h
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import <SenTestingKit/SenTestingKit.h>     // Customize to the testing framework of your choice
#import "HMVerifiable.h"


/**
    Test case that helps check verifiables.
 
    Any subclasses that define -setUp and -tearDown must invoke [super setUp] and [super tearDown].
 */
@interface HMTestCase : SenTestCase

/// Registers a verifiable created within a test method.
- (void)registerVerifiable:(id<HMVerifiable>)object;

/// Verifies all registered veriables, plus any verifiable instance variables.
- (void)verify;

@end
