//
//  RecipeListingModel.m
//  Sieve_PF
//
//  Created by Jordan Sieve on 12/16/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import "RecipeListingModel.h"

@implementation RecipeListingModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _recipeItem = [[NSDictionary alloc] init];
    }
    return self;
}

- (NSArray *)resultRecipesArray
{
    // Put JSON titles into array
    NSArray *distinctTitles = [self.searchedRecipeArray valueForKey:@"title"];
    
    return distinctTitles;
}

@end
