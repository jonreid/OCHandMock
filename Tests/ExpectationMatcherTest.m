//
//  OCHandMock - ExpectationMatcherTest.m
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

	// Class under test
#import "HMExpectationMatcher.h"

	// Test support
#import <SenTestingKit/SenTestingKit.h>
#import "MockTestCase.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface ExpectationMatcherTest : SenTestCase
{
    MockTestCase *testCase;
    HMExpectationMatcher *matcher;
}
@end


@implementation ExpectationMatcherTest

- (void)setUp
{
    [super setUp];
    
    testCase = [[MockTestCase alloc] init];
    matcher = [[HMExpectationMatcher alloc] initWithName:@"matcher" testCase:testCase];
}


- (void)tearDown
{
    [testCase release];
    [matcher release];
    
    [super tearDown];
}


- (void)testNoSettingsShouldPassVerification
{
    // exercise
    [matcher verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testSetExpectedShouldHaveExpectation
{
    // exercise
    [matcher setExpected:is(@"irrelevant")];
    
    // verify
    STAssertTrue([matcher hasExpectations], nil);
}


- (void)testExpectNothingShouldHaveExpectation
{
    // exercise
    [matcher setExpectNothing];
    
    // verify
    STAssertTrue([matcher hasExpectations], nil);
}


- (void)testExpectNothingShouldPassIfNotInvoked
{
    // set up
    [matcher setExpectNothing];
    
    // exercise
    [matcher verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testExpectNothingShouldSignalTestFailureWhenInvoked
{
    // set up
    [matcher setExpectNothing];
    
    // exercise
    [matcher setActual:@"anything"];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
    assertThat([[testCase failureException] name], is(SenTestFailureException));
}


- (void)testMismatchShouldFailImmediately
{
    // set up
    [matcher setExpected:is(@"foo")];
    
    // exercise
    [matcher setActual:@"bar"];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
    assertThat([[testCase failureException] reason],
               is(@"matcher expected argument \"foo\", but was \"bar\""));
}


- (void)testFailOnVerifyShouldWaitUntilVerifyToFail
{
    // set up
    [matcher setExpected:is(@"foo")];
    [matcher setFailOnVerify];
    
    [matcher setActual:@"bar"];
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
    
    // exercise
    [matcher verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
    assertThat([[testCase failureException] reason],
               is(@"matcher expected argument \"foo\", but was \"bar\""));
}


- (void)testVerifyWithUnmetExpectationShouldFail
{
    // set up
    [matcher setExpected:is(@"foo")];
    
    // exercise
    [matcher verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
    assertThat([[testCase failureException] reason],
               is(@"matcher expected argument \"foo\", but was never invoked"));
}


- (void)testInvokingShouldNotSetExpectation
{
    // exercise
    [matcher setActual:@"abc"];
    
    // verify
    STAssertFalse([matcher hasExpectations], nil);
}


- (void)testSetExpectNothingShouldClearActual
{
    // set up
    [matcher setActual:@"abc"];
    
    // exercise
    [matcher setExpectNothing];
    [matcher verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testSuccess
{
    // exercise
    [matcher setExpected:is(@"foo")];
    [matcher setActual:@"foo"];
    [matcher verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}

@end
