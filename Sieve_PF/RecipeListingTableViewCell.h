//
//  RecipeListingTableViewCell.h
//  Sieve_PF
//
//  Created by Jordan Sieve on 12/17/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeListingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipePreviewImage;   // Disply recipe preview
@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;          // Display recipe title

@end
