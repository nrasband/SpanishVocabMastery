//
//  FlashCardController.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/21/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "FlashCardStartView.h"
#import "WordCategory.h"
#import "FlashCardCardController.h"

@class FlashCardController;

@protocol FlashCardControllerDelegate

@required - (void) flashCardController:(FlashCardController*)flashCardController getDefinitionSetsForCategory:(WordCategory*)wordCategory;
@required - (void) flashCardController:(FlashCardController *)flashCardController requestAllCategories:(BOOL)request;

@end

@interface FlashCardController : UIViewController 
{
    NSObject<FlashCardControllerDelegate>* _delegate;
    int _direction;
    int _pictureLocation;
    NSArray* _categories;
    NSArray* _definitionSets;
    float _fontSize;
}

// Properties
@property (assign) NSObject<FlashCardControllerDelegate>* delegate;
@property (assign) int direction;
@property (assign) int pictureLocation;
@property (retain) NSArray* categories;
@property (retain) NSArray* definitionSets;
@property (assign) float fontSize;

@end

