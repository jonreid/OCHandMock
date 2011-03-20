//
//  OCHandMock - HMVerifier.h
//  Copyright 2011 Jonathan M. Reid. See LICENSE.txt
//

#import <Foundation/Foundation.h>


@interface HMVerifier : NSObject

/// Verifies all HMVerifiable instance variables in the given object.
+ (void)verify:(id)object;

@end
