//
//  DefinitionSet.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/15/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "DefinitionSet.h"

#pragma mark -
#pragma mark Private Interface
@interface DefinitionSet ()<NSCopying>
@end

#pragma mark -
@implementation DefinitionSet

#pragma mark Constructors
// Default constructor
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    [self setEnglish:@""];
    [self setSpanish:@""];
    [self setEnglishExampleSentence:@""];
    [self setSpanishExampleSentence:@""];
    [self setGender:@"N/A"];
    [self setSingularOrPlural:NA];
    [self setPartOfSpeech:@""];
    [self setImagePath:@""];
    [self setAudioPath:@""];
    [self setCategoryID:DEFAULT];
    
    return self;
}

// Constructor with arguments
- (id) initWithEnglish:(NSString*)english spanish:(NSString*)spanish gender:(NSString*)gender singularOrPlural:(int)singularOrPlural 
         partOfSpeech:(NSString*)partOfSpeech imagePath:(NSString*)imagePath audioPath:(NSString*)audioPath categoryID:(int)category
{
    self = [super init];
    if (self == nil)
        return nil;
    
    // Setup the definition set with the values passed in:
    [self setEnglish:english];
    [self setSpanish:spanish];
    [self setEnglishExampleSentence:@""];
    [self setSpanishExampleSentence:@""];
    [self setGender:gender];
    [self setSingularOrPlural:singularOrPlural];
    [self setPartOfSpeech:partOfSpeech];
    [self setImagePath:imagePath];
    [self setAudioPath:audioPath];
    [self setCategoryID:category];
    
    return self;
}

- (void) dealloc
{
    [_english release];
    [_spanish release];
    [_englishExampleSentence release];
    [_spanishExampleSentence release];
    [_gender release];
    [_partOfSpeech release];
    [_imagePath release];
    [_audioPath release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize definitionID = _definitionID;
@synthesize english = _english;
@synthesize spanish = _spanish;
@synthesize englishExampleSentence = _englishExampleSentence;
@synthesize spanishExampleSentence = _spanishExampleSentence;
@synthesize imagePath = _imagePath; // May need to write custom setter for imagePath and audioPath to make sure they are valid file paths.
@synthesize audioPath = _audioPath;
@synthesize categoryID = _categoryID;
@synthesize newFromGoogle = _newFromGoogle;

// Gender property getter
- (NSString*) gender
{
    return _gender;
}

// Gender property setter (only allows the gender to be set to masculine, feminine, or N/A)
- (void) setGender:(NSString*)gender
{
    if ([gender isEqualToString:@"M"] || [gender isEqualToString:@"F"] || [gender isEqualToString:@"N/A"])
    {
        [_gender autorelease];
        _gender = [gender retain];
    }
    else
    {
        NSLog(@"User tried to specify an invalid gender. Gender specified was %@", gender);
        [_gender autorelease];
        _gender = [@"N/A" retain];
    }
}

// Singular or plural getter
- (int) singularOrPlural
{
    return _singularOrPlural;
}

// Singular or plural setter. Only allows SINGULAR or PLURAL or N/A
- (void) setSingularOrPlural:(int)singularOrPlural
{
    if (singularOrPlural == SINGULAR || singularOrPlural == PLURAL || singularOrPlural == NA)
    {
        _singularOrPlural = singularOrPlural;
    }
    else
    {
        NSLog(@"User tried to set invalid singular or plural. Argument was %i", singularOrPlural);
        _singularOrPlural = NA;
    }
}

// Part of speech getter and setter (only allows valid parts of speech)
- (NSString*) partOfSpeech
{
    return _partOfSpeech;
}

- (void) setPartOfSpeech:(NSString*)partOfSpeech
{
    if ([partOfSpeech isEqualToString:@"adjective"] ||
        [partOfSpeech isEqualToString:@"adverb"] ||
        [partOfSpeech isEqualToString:@"conjunction"] ||
        [partOfSpeech isEqualToString:@"interjection"] ||
        [partOfSpeech isEqualToString:@"N/A"] ||
        [partOfSpeech isEqualToString:@"noun"] ||
        [partOfSpeech isEqualToString:@"preposition"] ||
        [partOfSpeech isEqualToString:@"pronoun"] ||
        [partOfSpeech isEqualToString:@"verb"] ||
        [partOfSpeech isEqualToString:@""])// Empty string if unknown
    {
        [_partOfSpeech autorelease];
        _partOfSpeech = [partOfSpeech retain];
    }
    else
    {
        NSLog(@"User tried to specify an invalid part of speech. It was %@", partOfSpeech);
        [_partOfSpeech autorelease];
        _partOfSpeech = [@"" retain];
    }
}

#pragma mark -
#pragma mark Methods
- (NSString*) singularOrPluralToString
{
    NSString* strVersion;
    int sOrP = [self singularOrPlural];
    switch (sOrP) {
        case SINGULAR:
            strVersion = NSLocalizedString(@"Singular", @"");
            break;
        case PLURAL:
            strVersion = NSLocalizedString(@"Plural", @"");
        case NA:
            strVersion = NSLocalizedString(@"N/A", @"");
        default:
            break;
    }
    return strVersion;
}

- (NSString*) article
{

    NSString* articleToReturn = @"";
    if ([[self partOfSpeech] isEqualToString:@"noun"])
    {
        // Masculine
        if ([[self gender] isEqualToString:@"M"])
        {
            // Singular or plural
            if ([self singularOrPlural] == SINGULAR)
            {
                articleToReturn = @"el";
            }
            else if ([self singularOrPlural] == PLURAL)
            {
                articleToReturn = @"los";
            }
        }
        // Feminine
        else if ([[self gender] isEqualToString:@"F"])
        {
            // Singular or plural
            if ([self singularOrPlural] == SINGULAR)
            {
                NSRange range;
                range.location = 0;
                range.length = 1;
                if ([[[[self spanish] lowercaseString] substringWithRange:range] isEqualToString:@"a"])
                {
                    articleToReturn = @"el";
                }
                else
                {
                    articleToReturn = @"la";
                }
            }
            else if ([self singularOrPlural] == PLURAL)
            {
                articleToReturn = @"las";
            }            
        }
    }
    
    return articleToReturn;
}

- (int) genderIndex
{
    int index = 0;
    if ([[self gender] isEqualToString:@"M"])
    {
        index = 0;
    }
    else if ([[self gender] isEqualToString:@"F"])
    {
        index = 1;
    }
    else
    {
        index = 2;
    }
    
    return index;
}

- (int) singularPluralIndex
{
    int index = 0;
    if ([self singularOrPlural] == SINGULAR)
    {
        index = SINGULAR;
    }
    else if ([self singularOrPlural] == PLURAL)
    {
        index = PLURAL;
    }
    else
    {
        index = NA;
    }
    
    return index;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"Definition set: def id: %i\nenglish: %@\nspanish: %@\nEnglish example: %@\nSpanish example: %@\ngender: %@\nsingular or plural: %@\npart of speech: %@\nimage path: %@\naudio path: %@\ncategory id: %i",
            [self definitionID],
            [self english],
            [self spanish],
            [self englishExampleSentence],
            [self spanishExampleSentence],
            [self gender],
            [self singularOrPluralToString],
            [self partOfSpeech],
            [self imagePath],
            [self audioPath],
            [self categoryID]];
}

// Implement the copying protocol
- (id) copyWithZone:(NSZone *)zone
{
    DefinitionSet* copyOfDefSet = [[[self class] allocWithZone:zone] initWithEnglish:[self english] spanish:[self spanish] gender:[self gender] singularOrPlural:[self singularOrPlural] partOfSpeech:[self partOfSpeech] imagePath:[self imagePath] audioPath:[self audioPath] categoryID:[self categoryID]];
    [copyOfDefSet setEnglishExampleSentence:[self englishExampleSentence]];
    [copyOfDefSet setSpanishExampleSentence:[self spanishExampleSentence]];
    [copyOfDefSet setNewFromGoogle:[self newFromGoogle]];
    
    return copyOfDefSet;
}

@end
