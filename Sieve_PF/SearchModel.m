//
//  SearchModel.m
//  Sieve_PF
//
//  Created by Jordan Sieve on 12/16/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import "SearchModel.h"
#import "HTTPRequestHandler.h"
#import "RecipeData.h"

@interface SearchModel()

@property (nonatomic, strong) NSArray *recipesArray;

@end

@implementation SearchModel

- (instancetype)initWithDelegate:(id<SearchModelDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Get Recipe Web Data

- (void)getWebDataForRecipes
{
    // Perform JSON query
    __weak SearchModel *weakSelf = self;
    HTTPRequestHandler *requestHandler = [[HTTPRequestHandler alloc] init];
    [requestHandler startWebRequestWithCompletionBlock:^(NSArray *dataArray) {
        [weakSelf createRecipesFromDataArray:dataArray];
        [weakSelf.delegate receivedDataForRecipes];
    }];
}

#pragma mark - Parse JSON data method

- (void)createRecipesFromDataArray:(NSArray *)dataArray
{
    // Store JSON data in dictionary elements
    NSMutableArray *newRecipesArray = [[NSMutableArray alloc] initWithCapacity:[dataArray count]];
    for (NSDictionary *singleRecipe in dataArray) {
        RecipeData *recipe = [[RecipeData alloc] init];
        [recipe setTitle:[singleRecipe valueForKey:@"title"]];
        [recipe setPublisher:[singleRecipe valueForKey:@"publisher"]];
        [recipe setF2f_url:[singleRecipe valueForKey:@"f2f_url"]];
        [recipe setSource_url:[singleRecipe valueForKey:@"source_url"]];
        [recipe setRecipe_id:[singleRecipe valueForKey:@"recipe_id"]];
        [recipe setImage_url:[singleRecipe valueForKey:@"image_url"]];
        [recipe setSocial_rank:[singleRecipe valueForKey:@"social_rank"]];
        [recipe setPublisher_url:[singleRecipe valueForKey:@"publisher_url"]];
        [newRecipesArray addObject:recipe];
    }
    
    // Create array of dictionary elements
    self.recipesArray = newRecipesArray;
}

@end
