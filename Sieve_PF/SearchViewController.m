//
//  ViewController.m
//  Sieve_PF
//
//  Created by Jordan Sieve on 11/27/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchModel.h"
#import "RecipeListingViewController.h"
#import "RecipeSingleton.h"

@interface SearchViewController () <SearchModelDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *fetchRecipesButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingRecipesActivityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *recipeSearchBar;
@property (nonatomic, strong) SearchModel *model;
@property (nonatomic) RecipeSingleton *sharedManager;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[SearchModel alloc] initWithDelegate:self];
    _sharedManager = [RecipeSingleton sharedManager];
}

#pragma mark - Recieve Data methods

- (IBAction)fetchRecipesButtonPressed:(id)sender
{
    // Put search term into singleton string property for access everywhere
    _sharedManager.searchTerms = _recipeSearchBar.text;
    
    // Lower the keyboard
    [_recipeSearchBar resignFirstResponder];
    
    // If search term is empty, warn user and try again
    if (_sharedManager.searchTerms.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Please enter search terms." message: nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil, nil];
        [alert show];
        
        return;
    }
    
    // Disable button, dim screen, go to function, display animation icon
    [self.model getWebDataForRecipes];
    [self.loadingRecipesActivityIndicator startAnimating];
    [self.loadingRecipesActivityIndicator setHidden:NO];
    [self.fetchRecipesButton setEnabled:NO];
    [self.view setAlpha:0.6f];
}

-(void)receivedDataForRecipes
{
    // If search result is empty, warn user and try again
    if ([_model.recipesArray count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No search results found." message: nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil, nil];
        [alert show];
        
        // Reenable button, hide animation icon, fix screen coloring
        [self.fetchRecipesButton setEnabled:YES];
        [self.loadingRecipesActivityIndicator stopAnimating];
        [self.loadingRecipesActivityIndicator setHidden:YES];
        [self.view setAlpha:1.0f];
        
        return;
    }
    
    // Reenable button, hide animation icon, fix screen coloring
    [self.fetchRecipesButton setEnabled:YES];
    [self.loadingRecipesActivityIndicator stopAnimating];
    [self.loadingRecipesActivityIndicator setHidden:YES];
    [self.view setAlpha:1.0f];
    [self performSegueWithIdentifier:@"showRecipeListing" sender:self];
}

#pragma mark - Segue into Recipe Listing ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Prepare data for custom segue
    if ([segue.destinationViewController isKindOfClass:[RecipeListingViewController class]]) {
        RecipeListingViewController *destinationController = segue.destinationViewController;
        [destinationController.model setSearchedRecipeArray:self.model.recipesArray];
    }
}

@end
