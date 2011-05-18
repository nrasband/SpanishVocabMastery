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

@class DefinitionSetsController;

@protocol DefinitionSetsControllerDelegate
@required - (void) definitionSetsController:(DefinitionSetsController*)definitionSetsController deleteDefinitionSet:(int)defSetId;
@end

@interface DefinitionSetsController : UIViewController 
{
    DefinitionSetsView* _defSetView;
    NSObject<DefinitionSetsControllerDelegate>* _delegate;
    NSMutableArray* _definitionSets;
    int _categoryId;
}

// Constructors
- (id) initWithDefinitionSets:(NSArray*)sets category:(int)catId;

// Properties
@property (assign) NSObject<DefinitionSetsControllerDelegate>* delegate;

// The category to which all of the current definitions belong
@property (assign) int categoryId;
- (void) setDefinitionSets:(NSArray*)defSets;

@end

