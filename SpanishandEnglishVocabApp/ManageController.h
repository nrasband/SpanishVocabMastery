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
@required - (void) manageController:(ManageController*)manageController addDefinitionSet:(DefinitionSet*)defSet updateDefinitionSets:(BOOL)update;
@required - (void) manageController:(ManageController*)manageController updateDefinitionSet:(DefinitionSet*)defSet;
@required - (int) manageController:(ManageController*)manageController addCategory:(NSString*)category;
@required - (void) manageController:(ManageController*)manageController renameCategory:(WordCategory*)category toName:(NSString*)catName;
@required - (int) getNextDefinitionId;

@end

@interface ManageController : UIViewController 
{
    NSObject<ManageControllerDelegate>* _delegate;
    NSArray* _categories;
    DefinitionSet* _definitionSet; // Just used to pass this information down to the DefinitionSetsController
    float _fontSize;
}

// Properties
@property (assign) NSObject<ManageControllerDelegate>* delegate;
@property (retain) DefinitionSet* definitionSet;
@property (assign) float fontSize;

// Methods
- (void) setCategories:(NSArray*)categories;

@end

