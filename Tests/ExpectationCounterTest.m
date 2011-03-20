//
//  OCHandMock - ExpectationCounterTest.m
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

	// Class under test
#import "HMExpectationCounter.h"

	// Test support
#import <SenTestingKit/SenTestingKit.h>
#import "MockTestCase.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface ExpectationCounterTest : SenTestCase
{
    MockTestCase *testCase;
    HMExpectationCounter *counter;
}
@end


@implementation ExpectationCounterTest

- (void)setUp
{
    [super setUp];
    
    testCase = [[MockTestCase alloc] init];
    counter = [[HMExpectationCounter alloc] initWithName:@"counter" testCase:testCase];
}


- (void)tearDown
{
    [testCase release];
    [counter release];
    
    [super tearDown];
}


- (void)testNoSettingsShouldPassVerification
{
    // exercise
    [counter verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testNoSettingsShouldHaveNoExpectations
{
    // verify
    STAssertFalse([counter hasExpectations], nil);
}


- (void)testSetExpectedShouldHaveExpectation
{
    // exercise
    [counter setExpected:1];
    
    // verify
    STAssertTrue([counter hasExpectations], nil);
}


- (void)testExpectNothingShouldHaveExpectation
{
    // exercise
    [counter setExpectNothing];
    
    // verify
    STAssertTrue([counter hasExpectations], nil);
}


- (void)testExpectNothingShouldPassIfNotIncremented
{
    // set up
    [counter setExpectNothing];
    
    // exercise
    [counter verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testExpectNothingShouldSignalTestFailureWhenIncremented
{
    // set up
    [counter setExpectNothing];
    
    // exercise
    [counter increment];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
    assertThat([[testCase failureException] name], is(SenTestFailureException));
}


- (void)testIncrementPastExpectedShouldFailImmediately
{
    // set up
    [counter setExpected:1];
    
    // exercise
    [counter increment];
    [counter increment];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
    assertThat([[testCase failureException] reason],
               is(@"counter should not be called more than <1> times"));
}


- (void)testFailOnVerifyShouldWaitUntilVerifyToFail
{
    // set up
    [counter setExpected:1];
    [counter setFailOnVerify];
    
    [counter increment];
    [counter increment];
    [counter increment];
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
    
    // exercise
    [counter verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
    assertThat([[testCase failureException] reason],
               is(@"counter did not receive the expected Count. Expected <1>, but was <3>"));
}


- (void)testVerifyWithUnmetExpectationShouldFail
{
    // set up
    [counter setExpected:1];
    
    // exercise
    [counter verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
    assertThat([[testCase failureException] reason],
               is(@"counter did not receive the expected Count. Expected <1>, but was <0>"));
}


- (void)testIncrementingWithoutExpectationsShouldPass
{
    // exercise
    [counter increment];
    [counter verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testSetExpectedShouldClearActual
{
    // set up
    [counter increment];
    
    // exercise
    [counter setExpected:1];
    [counter increment];

    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testSuccess
{
    // exercise
    [counter setExpected:1];
    [counter increment];
    [counter verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}

@end
