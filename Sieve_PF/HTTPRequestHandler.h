//
//  HTTPRequestHandler.h
//  Sieve_PF
//
//  Created by Jordan Sieve on 11/27/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HTTPRequestHandler : NSObject

- (void)startWebRequestWithCompletionBlock:(void(^)(NSArray *dataArray))completionBlock;

@end
