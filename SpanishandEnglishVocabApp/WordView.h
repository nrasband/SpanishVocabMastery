//
//  WordView.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/18/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

@interface WordView : UIView 
{
    UILabel* _englishLabel;
    UILabel* _spanishLabel;
    UILabel* _exampleSentenceLabel;
    UILabel* _genderLabel;
    UILabel* _singularOrPluralLabel;
    UITextField* _englishText;
    UITextField* _spanishText;
    UIButton* _exampleSentenceButton;
    UISegmentedControl* _genderControl;
    UISegmentedControl* _singularOrPluralControl;
    UIButton* _categoryButton;
    UIButton* _imageButton;
    UIButton* _partOfSpeechButton;
}

// Constructors
- (id) initWithFrame:(CGRect)frame;

// Properties
- (UIButton*) categoryButton;
- (UIButton*) partOfSpeechButton;
- (UIButton*) imageButton;
- (UISegmentedControl*) singularOrPluralControl;
- (UISegmentedControl*) genderControl;
- (UITextField*) englishText;
- (UITextField*) spanishText;
- (UIButton*) exampleSentenceButton;

@end
