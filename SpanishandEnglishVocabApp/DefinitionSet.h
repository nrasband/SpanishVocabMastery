//
//  DefinitionSet.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/15/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#define SINGULAR 0
#define PLURAL 1
#define NA 2 // Not applicable
#define DEFAULT 0 // The default category identifier
#define ENG_SPA 0
#define SPA_ENG 1

@interface DefinitionSet : NSObject 
{
    int _definitionID;
	NSString* _english;
    NSString* _spanish;
    NSString* _englishExampleSentence;
    NSString* _spanishExampleSentence;
	NSString* _gender;
    int _singularOrPlural;
	NSString* _partOfSpeech;
	NSString* _imagePath;
    NSString* _audioPath;
    int _categoryID;
    BOOL _newFromGoogle;
}

// Properties
@property (assign) int definitionID;
@property (retain) NSString* english;
@property (retain) NSString* spanish;
@property (retain) NSString* englishExampleSentence;
@property (retain) NSString* spanishExampleSentence;
@property (retain) NSString* gender;
@property (assign) int singularOrPlural;
@property (retain) NSString* partOfSpeech;
@property (retain) NSString* imagePath;
@property (retain) NSString* audioPath;
@property (assign) int categoryID;
@property (assign) BOOL newFromGoogle;

// Constructors
-(id) initWithEnglish:(NSString*)english spanish:(NSString*)spanish gender:(NSString*)gender singularOrPlural:(int)singularOrPlural 
         partOfSpeech:(NSString*)partOfSpeech imagePath:(NSString*)imagePath audioPath:(NSString*)audioPath categoryID:(int)category;

// Methods

// Converts the #define version of singularOrPlural into the corresponding string.
- (NSString*) singularOrPluralToString;

// Returns the appropriate article for nouns or empty string for everything else
- (NSString*) article;

// Returns the index that corresponds to the string for use with segmented controls.
- (int) genderIndex;

// Returns the index for the segmented control
- (int) singularPluralIndex;

@end
