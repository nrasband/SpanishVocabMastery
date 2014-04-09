//
//  FlashCardCardController.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/22/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "FlashCardView.h"
#include <stdlib.h>

#define FRONT 0
#define BACK 1

@class FlashCardCardController;

@protocol FlashCardCardControllerDelegate
@end

@interface FlashCardCardController : UIViewController 
{
    NSObject<FlashCardCardControllerDelegate>* _delegate;
    NSArray* _definitionSets;
    float _fontSize;
    int _direction;
    BOOL _showEngExample;
    BOOL _showSpanExample;
    int _pictureLocation;
    int _currentSide;
    
    DefinitionSet* _currentDefinitionSet;
    int _currentIndex;
    NSMutableArray* _remainingCards;
}

// Constructor
- (id) initWithDefinitionSets:(NSArray*)definitionSets andDirection:(int)direction andPictureLocation:(int)picLocation showEngExample:(BOOL)showEng showSpanExample:(BOOL)showSpan andCategoryName:(NSString*)name;

// Properties
@property (assign) NSObject<FlashCardCardControllerDelegate>* delegate;
@property (retain) NSArray* definitionSets;
@property (assign) float fontSize;
@property (assign) int direction;
@property (assign) int pictureLocation;
@property (assign) BOOL showEngExample;
@property (assign) BOOL showSpanExample;
@property (retain) DefinitionSet* currentDefinitionSet;
@property (assign) int currentIndex;
@property (assign) int currentSide;

@end

