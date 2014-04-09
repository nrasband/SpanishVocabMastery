//
//  CategoryController.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/20/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "CategoryView.h"

@class CategoryController;

@protocol CategoryControllerDelegate

@required - (void) categoryController:(CategoryController*)categoryController updateCategory:(WordCategory*)category;
@required - (void) categoryController:(CategoryController *)categoryController addCategory:(NSString*)category;

@end

@interface CategoryController : UIViewController 
{
    NSObject<CategoryControllerDelegate>* _delegate;
    NSArray* _categories;
    int _initialCategoryId;
}

- (id) initWithcategories:(NSArray*)categories selectedCategory:(int)catId;

@property (assign) NSObject<CategoryControllerDelegate>* delegate;
@property (retain) NSArray* categories;
@property (assign) int initialCategoryId;

@end

