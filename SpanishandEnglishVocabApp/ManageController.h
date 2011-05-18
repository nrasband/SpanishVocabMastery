//
//  ManageController.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/16/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "ManageView.h"
#import "WordCategory.h"
#import "DefinitionSetsController.h"

@class ManageController;

@protocol ManageControllerDelegate

@required - (void) manageController:(ManageController*)manageController addCategoryToDatabase:(NSString*)categoryName;
@required - (void) manageController:(ManageController*)manageController requestAllCategories:(BOOL)all;
@required - (NSArray*) manageController:(ManageController*)manageController requestDefinitionSetsForCategory:(int)category;
@required - (void) manageController:(ManageController*)manageController moveDefinitionSetsToUnassignedFromCategory:(int)category;
@required - (void) manageController:(ManageController*)manageController deleteDefinitionSet:(int)defSetId;

@end

@interface ManageController : UIViewController 
{
    ManageView* _manageView;
    NSObject<ManageControllerDelegate>* _delegate;
    NSArray* _categories;
}

// Properties
@property (assign) NSObject<ManageControllerDelegate>* delegate;

// Methods
- (void) setCategories:(NSArray*)categories;

@end

