//
//  OCHandMock - TestCaseTest.m
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

	// Class under test
#import "HMTestCase.h"

#import "HMExpectationCounter.h"
#import "HMVerifier.h"

	// Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface TestingHMTestCase : HMTestCase
@property(nonatomic, assign) NSUInteger failureCount;
@end

@implementation TestingHMTestCase
@synthesize failureCount;

- (void)failWithException:(NSException *)exception
{
    ++failureCount;
}

@end


#pragma mark -

@interface TestCaseWithVerifiableInFixture : TestingHMTestCase
{
    HMExpectationCounter *counter;
}
@end

@implementation TestCaseWithVerifiableInFixture

- (void)artificialTest
{
    counter = [[[HMExpectationCounter alloc] initWithName:@"counter" testCase:self] autorelease];
    [counter setFailOnVerify];
    [counter setExpectNothing];
    [counter increment];
}

@end


#pragma mark -

@interface CustomMock : NSObject <HMVerifiable>
@property(nonatomic, retain) HMExpectationCounter *counter;
- (id)initWithTestCase:(id)test;
@end

@implementation CustomMock
@synthesize counter;

+ (id)mockWithTestCase:(id)test
{
    return [[[self alloc] initWithTestCase:test] autorelease];
}

- (id)initWithTestCase:(id)test
{
    self = [super init];
    if (self)
        counter = [[HMExpectationCounter alloc] initWithName:@"counter" testCase:test];
    return self;
}

- (void)dealloc
{
    [counter release];
    [super dealloc];
}

- (void)verify
{
    [HMVerifier verify:self];
}

@end


@interface TestCaseWithRegisteredVerifiable : TestingHMTestCase
@end

@implementation TestCaseWithRegisteredVerifiable

- (void)artificialTest
{
    CustomMock *mock = [CustomMock mockWithTestCase:self];
    [[mock counter] setFailOnVerify];
    [[mock counter] setExpectNothing];
    [[mock counter] increment];
}

@end


#pragma mark -

@interface TestCaseTest : SenTestCase
@end


@implementation TestCaseTest

- (void)testVerifiableInFixture
{
	// set up
    TestCaseWithVerifiableInFixture *testCase = [[[TestCaseWithVerifiableInFixture alloc] init]
                                                 autorelease];

	// exercise
    [testCase setUp];
    [testCase artificialTest];
    [testCase verify];
    [testCase tearDown];

	// verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
}


- (void)testRegisteredVerifiable
{
	// set up
    TestCaseWithRegisteredVerifiable *testCase = [[[TestCaseWithRegisteredVerifiable alloc] init]
                                                  autorelease];
    
    // exercise
    [testCase setUp];
    [testCase artificialTest];
    [testCase verify];
    [testCase tearDown];
    
	// verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
}

@end
