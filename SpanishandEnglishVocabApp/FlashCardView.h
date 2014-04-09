//
//  FlashCardView.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/21/11.
//  Copyright 2011 Nick Rasband. All rights reserved.

#import "DefinitionSet.h"

@interface FlashCardView : UIView 
{
    DefinitionSet* _definitionSet;
    int _direction;
    BOOL _showPicture;
    BOOL _showExample;
    NSString* _example;
    
    UIImageView* _imageView;
    UITextView* _wordLabel;
    UITextView* _exampleSentence;
    UIButton* _flipButton;
    UIButton* _nextButton;
    UIButton* _previousButton;
}

// Constructor
- (id) initWithFrame:(CGRect)frame definitionSet:(DefinitionSet*)definitionSet direction:(int)direction showEngExample:(BOOL)showEng showSpanExample:(BOOL)showSpan showPicture:(BOOL)showPicture;

// Properties
@property (retain) DefinitionSet* definitionSet;
@property (assign) BOOL showPicture;
@property (assign) BOOL showExample;
@property (retain) NSString* example;
@property (assign) int direction;

- (UIImageView*) imageView;
- (UITextView*) wordLabel;
- (UITextView*) exampleSentence;
- (UIButton*) flipButton;
- (UIButton*) nextButton;
- (UIButton*) previousButton;


@end
