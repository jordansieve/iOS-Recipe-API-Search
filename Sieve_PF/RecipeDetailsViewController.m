//
//  RecipeDetailsViewController.m
//  Sieve_PF
//
//  Created by Jordan Sieve on 12/16/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import "RecipeDetailsViewController.h"
#import "RecipeData.h"

@interface RecipeDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *recipeDetailsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (nonatomic) UIImage *resizedRecipeImage;
@property (nonatomic) NSURL *recipeURL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recipeImageSize;

@end

@implementation RecipeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Display recipe image in UIImageView
    [self changeImageSize];
    
    // Create array from input recipe
    [self setArrayForTableView];
    
    // Update UIImageView size based on screen size
    [self updateViewConstraints];
}

- (RecipeDetailsModel *)model {
    if (!_model) {
        _model = [[RecipeDetailsModel alloc] init];
    }
    return _model;
}

#pragma mark - Image Resize Method

- (void)changeImageSize
{
    // Get Image URL from parsed data
    NSURL *recipeImageURL = [NSURL URLWithString:[_model.selectedRecipe valueForKey:@"image_url"]];
    _resizedRecipeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:recipeImageURL]];
    
    // Resize to constraints of UIImageView
    _recipeImage.contentMode = UIViewContentModeScaleAspectFit;
    _recipeImage.clipsToBounds = YES;
    [_recipeImage setImage:_resizedRecipeImage];
}

#pragma mark - Set Up Array For TableView

- (void) setArrayForTableView
{
    // Add dictionary elements of recipe to array for tableview
    _model.selectedRecipeElements = [[NSArray alloc] initWithObjects:
                                     [_model.selectedRecipe valueForKey:@"title"],
                                     [NSString stringWithFormat:@"User Rated: %i%%", (int)[[_model.selectedRecipe valueForKey:@"social_rank"] integerValue]],
                                     [NSString stringWithFormat:@"Ingredients / Nutritional Facts"],
                                     [NSString stringWithFormat:@"Source"],
                                     [NSString stringWithFormat:@"Published by %@", [_model.selectedRecipe valueForKey:@"publisher"]],
                                     [NSString stringWithFormat:@"Publisher's Website"],
                                     nil];
}

#pragma mark - Resize UIImageView Based On Screen Size

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if ([UIScreen mainScreen].bounds.size.height > 480.0f) {
        _recipeImageSize.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 225 : 225;
    }
    else {
        _recipeImageSize.constant = [UIScreen mainScreen].bounds.size.height < 480.0f ? 175 : 175;
    }
}

#pragma mark - Recipe Details Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_model.selectedRecipeElements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeDetailCell"];
    
    // Resize the text elements to fit in the cells
    cell.textLabel.numberOfLines = 1;
    [[cell textLabel] setText:[_model.selectedRecipeElements objectAtIndex:[indexPath row]]];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 8./cell.textLabel.font.pointSize;
        
    return cell;
}

#pragma mark - TableView Selection Page openings

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    // If user clicks "Ingredients" - open web page in browser
    if (indexPath.row == 2) {
        
        // Save URL for accessing if user selects OK
        _recipeURL = [NSURL URLWithString: [_model.selectedRecipe valueForKey:@"f2f_url"]];
        
        // Warn user before opening webpage
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Go to URL?" message: @"This will leave application and open webpage in browser." delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK", @"Cancel", nil];
        [alert show];
    }
    
    // If user clicks "Source" - open web page in browser
    if (indexPath.row == 3) {
        
        // Save URL for accessing if user selects OK
        _recipeURL = [NSURL URLWithString: [_model.selectedRecipe valueForKey:@"source_url"]];
        
        // Warn user before opening webpage
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Go to URL?" message: @"This will leave application and open webpage in browser." delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK", @"Cancel", nil];
        [alert show];
    }
    
    // If user clicks "Publisher's Website" - open web page in browser
    if (indexPath.row == 5) {
        
        // Save URL for accessing if user selects OK
        _recipeURL = [NSURL URLWithString: [_model.selectedRecipe valueForKey:@"publisher_url"]];
        
        // Warn user before opening webpage
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Go to URL?" message: @"This will leave application and open webpage in browser." delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK", @"Cancel", nil];
        [alert show];
    }
    
}

#pragma mark - UIAlertView Button Controls

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // OK button clicked
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL: _recipeURL];
    }
    
    // Cancel button clicked
    else if (buttonIndex == 1) {
        return;
    }
}

@end
