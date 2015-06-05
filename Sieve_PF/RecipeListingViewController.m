//
//  RecipeListingViewController.m
//  Sieve_PF
//
//  Created by Jordan Sieve on 12/16/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import "RecipeListingViewController.h"
#import "RecipeData.h"
#import "RecipeDetailsViewController.h"
#import "RecipeListingTableViewCell.h"

@interface RecipeListingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *recipesTableView;
@property (nonatomic, weak) NSNumber *selectedRecipeIndex;
@property (nonatomic) UIImage *resizedRecipeImage;                  // Used for custom cell recipe preview

@end

@implementation RecipeListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (RecipeListingModel *)model {
    if (!_model) {
        _model = [[RecipeListingModel alloc] init];
    }
    return _model;
}

#pragma mark - Recipe Listing TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model.resultRecipesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipeListingTableViewCell *cell = (RecipeListingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RecipeCell"];
    
    // Put recipe title into the custom cells and resize text to fit
    cell.recipeNameLabel.numberOfLines = 1;
    cell.recipeNameLabel.text = [self.model.resultRecipesArray objectAtIndex:[indexPath row]];
    cell.recipeNameLabel.adjustsFontSizeToFitWidth = YES;
    cell.recipeNameLabel.minimumScaleFactor = 8./cell.recipeNameLabel.font.pointSize;

    // Get recipe image from URL and resize for recipe preview
    NSURL *recipeImageURL = [NSURL URLWithString:[[self.model.searchedRecipeArray objectAtIndex:[indexPath row]] valueForKey:@"image_url"]];
    _resizedRecipeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:recipeImageURL]];
    
    // Resize to constraints of UIImageView
    cell.recipePreviewImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.recipePreviewImage.clipsToBounds = YES;
    [cell.recipePreviewImage setImage:_resizedRecipeImage];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedRecipeIndex = [NSNumber numberWithInteger:[indexPath row]];
    
    // Grab selected icon in array
    _model.recipeItem = [self.model.searchedRecipeArray objectAtIndex:indexPath.row];
    
    // Advance to details recipe screen
    [self performSegueWithIdentifier:@"showRecipeDetails" sender:self];
}

#pragma mark - Recipe Listing Prepare For Seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Prepare data for custom segue
    if ([segue.destinationViewController isKindOfClass:[RecipeDetailsViewController class]]) {
        RecipeDetailsViewController *destinationController = segue.destinationViewController;
        
        // Store dictionary element into model data of incoming ViewController
        destinationController.model.selectedRecipe = [self.model.searchedRecipeArray objectAtIndex:[_selectedRecipeIndex integerValue]];
    }
}

@end
