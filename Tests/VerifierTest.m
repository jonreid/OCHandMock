//
//  OCHandMock - VerifierTest.m
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

	// Class under test
#import "HMVerifier.h"

#import "HMExpectationMatcher.h"

	// Test support
#import <SenTestingKit/SenTestingKit.h>
#import "MockTestCase.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface OneVerifiableIvar : NSObject
{
    HMExpectationMatcher *matcher;
    int unused;
}
@end

@implementation OneVerifiableIvar

- (id)initWithTestCase:(id)test
{
    self = [super init];
    if (self)
    {
        matcher = [[HMExpectationMatcher alloc] initWithName:@"matcher" testCase:test];
        [matcher setFailOnVerify];
        [matcher setExpected:is(@"good")];
    }
    return self;
}

- (void)dealloc
{
    [matcher release];
    [super dealloc];
}

- (void)setValue:(id)value
{
    [matcher setActual:value];
}

@end


@interface InheritVerifiableIvar : OneVerifiableIvar
@end

@implementation InheritVerifiableIvar
@end


#pragma mark -

@interface OneVerifiableSyntheticIvar : NSObject
@property(nonatomic, retain) HMExpectationMatcher *matcher;
@end

@implementation OneVerifiableSyntheticIvar

@synthesize matcher;

- (id)initWithTestCase:(id)test
{
    self = [super init];
    if (self)
    {
        matcher = [[HMExpectationMatcher alloc] initWithName:@"matcher" testCase:test];
        [matcher setFailOnVerify];
        [matcher setExpected:is(@"good")];
    }
    return self;
}

- (void)dealloc
{
    [matcher release];
    [super dealloc];
}

- (void)setValue:(id)value
{
    [matcher setActual:value];
}

@end


@interface InheritVerifiableSyntheticIvar : OneVerifiableSyntheticIvar
@end

@implementation InheritVerifiableSyntheticIvar
@end


#pragma mark -

@interface NoVerifiables : NSObject
@end

@implementation NoVerifiables
@end


#pragma mark -

@interface LoopingVerifiable : NSObject <HMVerifiable>
{
    id testCase;
    BOOL inVerify;
}
@property(nonatomic, assign) LoopingVerifiable *reference;
@end

@implementation LoopingVerifiable

@synthesize reference;

- (id)initWithTestCase:(id)test
{
    self = [super init];
    if (self)
        testCase = test;
    return self;
}

- (void)verify
{
    if (inVerify)
    {
        NSException *exception = [NSException exceptionWithName:@"SenTestFailureException"
                                                         reason:@"Looping verification detected"
                                                       userInfo:nil];
        [testCase failWithException:exception];
    }
    else
    {
        inVerify = YES;
        [HMVerifier verify:self];        
        inVerify = NO;
    }
}

@end

#pragma mark -

@interface VerifierTest : SenTestCase
{
    MockTestCase *testCase;
}
@end


@implementation VerifierTest

- (void)setUp
{
    [super setUp];    
    testCase = [[MockTestCase alloc] init];
}


- (void)tearDown
{
    [testCase release];    
    [super tearDown];
}


- (void)testOneVerifiableIvarFails
{
    // set up
    OneVerifiableIvar *object = [[[OneVerifiableIvar alloc] initWithTestCase:testCase] autorelease];
    [object setValue:@"bad"];
    
    // exercise
    [HMVerifier verify:object];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
}


- (void)testOneVerifiableIvarPasses
{
    // set up
    OneVerifiableIvar *object = [[[OneVerifiableIvar alloc] initWithTestCase:testCase] autorelease];
    [object setValue:@"good"];
    
    // exercise
    [HMVerifier verify:object];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testInheritVerifiableIvarFails
{
    // set up
    InheritVerifiableIvar *object = [[[InheritVerifiableIvar alloc] initWithTestCase:testCase]
                                     autorelease];
    [object setValue:@"bad"];
    
    // exercise
    [HMVerifier verify:object];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
}


- (void)testInheritVerifiableIvarPasses
{
    // set up
    InheritVerifiableIvar *object = [[[InheritVerifiableIvar alloc] initWithTestCase:testCase]
                                     autorelease];
    [object setValue:@"good"];
    
    // exercise
    [HMVerifier verify:object];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testOneVerifiableSyntheticIvarFails
{
    // set up
    OneVerifiableSyntheticIvar *object = [[[OneVerifiableSyntheticIvar alloc] initWithTestCase:testCase]
                                          autorelease];
    [object setValue:@"bad"];
    
    // exercise
    [HMVerifier verify:object];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
}


- (void)testOneVerifiableSyntheticIvarPasses
{
    // set up
    OneVerifiableSyntheticIvar *object = [[[OneVerifiableSyntheticIvar alloc] initWithTestCase:testCase]
                                          autorelease];
    [object setValue:@"good"];
    
    // exercise
    [HMVerifier verify:object];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testInheritVerifiableSyntheticIvarFails
{
    // set up
    InheritVerifiableSyntheticIvar *object = [[[InheritVerifiableSyntheticIvar alloc] initWithTestCase:testCase]
                                              autorelease];
    [object setValue:@"bad"];
    
    // exercise
    [HMVerifier verify:object];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(1)));
}


- (void)testInheritVerifiableSyntheticIvarPasses
{
    // set up
    InheritVerifiableSyntheticIvar *object = [[[InheritVerifiableSyntheticIvar alloc] initWithTestCase:testCase]
                                              autorelease];
    [object setValue:@"good"];
    
    // exercise
    [HMVerifier verify:object];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testNoVerifiables
{
    // set up
    NoVerifiables *object = [[[NoVerifiables alloc] init] autorelease];
    
    // exercise
    [HMVerifier verify:object];
}


- (void)testNoLoopVerifySingleLevel
{
    // set up
    LoopingVerifiable* loopingVerifiable = [[[LoopingVerifiable alloc] initWithTestCase:testCase] autorelease];
    
    // exercise
    [loopingVerifiable verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}


- (void)testNoLoopVerifyMultiLevel
{
    // set up
    LoopingVerifiable* a = [[[LoopingVerifiable alloc] initWithTestCase:testCase] autorelease];
    LoopingVerifiable* b = [[[LoopingVerifiable alloc] initWithTestCase:testCase] autorelease];
    [a setReference:b];
    [b setReference:a];
    
    // exercise
    [a verify];
    
    // verify
    assertThatUnsignedInteger([testCase failureCount], is(equalToUnsignedInteger(0)));
}

@end
