//
//  RecipeSingleton.m
//  Sieve_PF
//
//  Created by Jordan Sieve on 12/17/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import "RecipeSingleton.h"

@implementation RecipeSingleton

+ (id)sharedManager {
    static RecipeSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        _searchTerms = [[NSString alloc] init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
