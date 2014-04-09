//
//  ExampleSentencesView.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 6/16/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

@interface ExampleSentencesView : UIScrollView 
{
    UILabel* _englishExampleLabel;
    UILabel* _spanishExampleLabel;
    
    UITextView* _englishExampleText;
    UITextView* _spanishExampleText;
}

// Constructor
- (id) initWithFrame:(CGRect)frame english:(NSString*)englishExample spanish:(NSString*)spanishExample;

- (UILabel*) englishExampleLabel;
- (UILabel*) spanishExampleLabel;

- (UITextView*) englishExampleText;
- (UITextView*) spanishExampleText;


@end
