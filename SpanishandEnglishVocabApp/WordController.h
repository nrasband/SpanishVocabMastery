//
//  WordController.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/18/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "DefinitionSet.h"
#import "WordView.h"
#import "PartOfSpeechController.h"
#import "CategoryController.h"
#import "ExampleSentencesController.h"

@class WordController;

@protocol WordControllerDelegate
@required - (void) wordController:(WordController*)wordController updateDefinitionSet:(DefinitionSet*)defSet;
@required - (void) wordController:(WordController*)wordController addDefinitionSet:(DefinitionSet*)defSet;
@required - (int) getNextDefinitionId;
@required - (NSArray*) wordController:(WordController *)wordController retrieveCategories:(BOOL)retrieve;
@required - (int) wordController:(WordController*)wordController addCategory:(NSString*)category;
@required - (void) cancelUpdate;
@end

@interface WordController : UIViewController<UITabBarControllerDelegate>
{
    DefinitionSet* _definitionSet;
    BOOL _isNewDefinition;
    NSObject<WordControllerDelegate>* _delegate;
    BOOL _definitionSetSaved;
    UIImagePickerController* _imagePicker;
}

// Constructors
- (id) initWithDefinitionSet:(DefinitionSet*)defSet isNew:(BOOL)isNew;

// Properties
@property (assign) NSObject<WordControllerDelegate>* delegate;
@property (retain) DefinitionSet* definitionSet;

// Indicates whether this is a brand new definition, or whether we are simply updating an existing definition
@property (assign) BOOL isNewDefinition;
@property (assign) BOOL definitionSetSaved;

// Methods

@end

