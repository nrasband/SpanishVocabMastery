//
//  PartOfSpeechController.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/19/11.
//  Copyright 2011 Nick Rasband. All rights reserved.

#import "PartOfSpeechView.h"

@class PartOfSpeechController;

@protocol PartOfSpeechControllerDelegate

@required - (void) partOfSpeechController:(PartOfSpeechController*)partOfSpeechController updatePartOfSpeech:(NSString*)partOfSpeech;

@end

@interface PartOfSpeechController : UIViewController 
{
    NSObject<PartOfSpeechControllerDelegate>* _delegate;
    NSString* _partOfSpeech;
}

// Constructors
- (id) initWithPartOfSpeech:(NSString*)partOfSpeech;

// Properties
@property (assign) NSObject<PartOfSpeechControllerDelegate>* delegate;
@property (retain) NSString* partOfSpeech;


@end

