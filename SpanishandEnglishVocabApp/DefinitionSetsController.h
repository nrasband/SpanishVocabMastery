//
//  DefinitionSetsController.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/17/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "DefinitionSet.h"
#import "DefinitionSetsView.h"
#import "WordController.h"
#import "WordCategory.h"

@class DefinitionSetsController;

@protocol DefinitionSetsControllerDelegate
@required - (void) definitionSetsController:(DefinitionSetsController*)definitionSetsController deleteDefinitionSet:(int)defSetId;
@required - (void) definitionSetsController:(DefinitionSetsController *)definitionSetsController addDefinitionSet:(DefinitionSet*)defSet updateDefinitionSets:(BOOL)update;
@required - (void) definitionSetsController:(DefinitionSetsController *)definitionSetsController updateDefinitionSet:(DefinitionSet*)defSet;
@required - (NSArray*) definitionSetsController:(DefinitionSetsController *)definitionSetsController retrieveCategories:(BOOL)retrieve;
@required - (int) definitionSetsController:(DefinitionSetsController*)definitionSetsController addCategory:(NSString*)category;
@required - (void) definitionSetsController:(DefinitionSetsController*)definitionSetsController renameCategory:(WordCategory*)category toName:(NSString*)catName;
@required - (int) getNextDefinitionId;

@end

@interface DefinitionSetsController : UIViewController 
{
    NSObject<DefinitionSetsControllerDelegate>* _delegate;
    NSMutableArray* _definitionSets;
    WordCategory* _category;
    int _indexOfDefinitionSetBeingModified;
    float _fontSize;
}

// Constructors
- (id) initWithDefinitionSets:(NSArray*)sets category:(WordCategory*)category;

// Properties
@property (assign) NSObject<DefinitionSetsControllerDelegate>* delegate;

@property (retain) WordCategory* category;

// This is an index to the definition set currently being modified which allows me to quickly update it when it returns.
@property (assign) int indexOfDefinitionSetBeingModified;

@property (assign) float fontSize;

// Sets the definition sets.
- (void) setDefinitionSets:(NSArray*)defSets;

// Update the definition sets.
- (void) addDefinitionSetToDefinitionSets:(DefinitionSet*)defSet;

@end

