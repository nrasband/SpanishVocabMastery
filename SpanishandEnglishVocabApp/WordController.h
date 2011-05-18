//
//  WordController.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/18/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "DefinitionSet.h"

@class WordController;

@protocol WordControllerDelegate
@end

@interface WordController : UIViewController 
{
    DefinitionSet* _definitionSet;
    BOOL _allowChangeCategory;
    BOOL _isNewDefinition;
    NSObject<WordControllerDelegate>* _delegate;
}

// Constructors
- (id) initWithDefinitionSet:(DefinitionSet*)defSet isNew:(BOOL)isNew allowChangeCategory:(BOOL)allowChangeCategory;

// Properties
@property (assign) NSObject<WordControllerDelegate>* delegate;
@property (retain) DefinitionSet* definitionSet;

// Indicates whether this is a brand new definition, or whether we are simply updating an existing definition
@property (assign) BOOL isNewDefinition; 

// Indicates whether or not the searchController created this controller. If it did, we allow the category to be modified. 
// Otherwise, the category cannot be changed.
@property (assign) BOOL allowChangeCategory;

// Methods

@end

