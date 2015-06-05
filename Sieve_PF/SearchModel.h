//
//  SearchModel.h
//  Sieve_PF
//
//  Created by Jordan Sieve on 12/16/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchModelDelegate <NSObject>

-(void)receivedDataForRecipes;

@end

@interface SearchModel : NSObject

@property (nonatomic, weak) id <SearchModelDelegate> delegate;
@property (nonatomic, readonly) NSArray *recipesArray;
@property (nonatomic) NSString *searchTerms;

- (id)initWithDelegate:(id<SearchModelDelegate>)delegate;
- (void)getWebDataForRecipes;

@end
