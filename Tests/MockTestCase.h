//
//  OCHandMock - MockTestCase.h
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import <Foundation/Foundation.h>


@interface MockTestCase : NSObject

@property(nonatomic, assign) NSUInteger failureCount;
@property(nonatomic, retain) NSException *failureException;

- (void)failWithException:(NSException *)exception;

@end
