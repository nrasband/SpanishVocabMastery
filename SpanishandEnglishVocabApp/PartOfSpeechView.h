//
//  PartOfSpeechView.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/19/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

@interface PartOfSpeechView : UIView 
{
    UIPickerView* _partOfSpeechPicker;
    NSArray* _partsOfSpeech;
}

// Constructors
- (id) initWithFrame:(CGRect)frame partOfSpeech:(NSString*)partOfSpeech;

// Properties
- (UIPickerView*) partOfSpeechPicker;
- (NSArray*) partsOfSpeech;

// Methods

// Returns the index in picker view associated with the part of speech.
- (int) partOfSpeechToIndex:(NSString*)partOfSpeech;


@end
