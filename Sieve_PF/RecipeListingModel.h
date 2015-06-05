//
//  RecipeListingModel.h
//  Sieve_PF
//
//  Created by Jordan Sieve on 12/16/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeListingModel : NSObject

@property (nonatomic, strong) NSArray *searchedRecipeArray;
@property (nonatomic, readonly) NSArray *resultRecipesArray;
@property (nonatomic) NSDictionary *recipeItem;

@end
