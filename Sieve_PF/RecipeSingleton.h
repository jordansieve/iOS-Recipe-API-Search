//
//  RecipeSingleton.h
//  Sieve_PF
//
//  Created by Jordan Sieve on 12/17/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeSingleton : NSObject

@property (nonatomic, strong) NSString *searchTerms;

+ (id)sharedManager;

@end
