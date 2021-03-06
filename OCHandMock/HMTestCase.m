//
//  OCHandMock - HMTestCase.m
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import "HMTestCase.h"

#import "HMVerifier.h"


@interface HMTestCase ()
@property(nonatomic, retain) NSMutableArray *verifiables;
@end


@implementation HMTestCase

@synthesize verifiables;

- (void)setUp
{
    [super setUp];
    verifiables = [[NSMutableArray alloc] init];
}


- (void)tearDown
{
    [verifiables release];
    [super tearDown];
}


- (void)registerVerifiable:(id<HMVerifiable>)object
{
    [verifiables addObject:object];
}


- (void)verify
{
    for (id<HMVerifiable> object in verifiables)
        [object verify];
}

@end
