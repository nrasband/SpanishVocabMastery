//
//  ExampleSentencesController.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 6/16/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "ExampleSentencesView.h"

@class ExampleSentencesController;

@protocol ExampleSentencesControllerDelegate
@required - (void) updateEnglishExample:(NSString*)english andSpanishExample:(NSString*)spanish;
@end

@interface ExampleSentencesController : UIViewController 
{
    NSObject<ExampleSentencesControllerDelegate>* _delegate;
    NSString* _englishExample;
    NSString* _spanishExample;
    UITextView* _activeTextView;
}

// Constructor
- (id) initWithEnglish:(NSString*)english spanish:(NSString*)spanish;

// Properties
@property (assign) NSObject<ExampleSentencesControllerDelegate>* delegate;

@property (retain) NSString* englishExample;
@property (retain) NSString* spanishExample;

@end

