//
//  PartOfSpeechView.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/19/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "PartOfSpeechView.h"

#pragma mark -
#pragma mark Private Interface
@interface PartOfSpeechView ()
@end

#pragma mark -
@implementation PartOfSpeechView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame partOfSpeech:(NSString*)partOfSpeech;
{
    self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
    
    // Find out if it is iPad or iPhone and set the font appropriately.
    float fontSize = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        fontSize = 30.0f;
    }
    else
    {
        fontSize = 17.0f;
    }
    
    UIColor* backgroundColor = [UIColor colorWithRed:0.478f green:0.69f blue:0.839f alpha:1.0f];
    
    [self setBackgroundColor:backgroundColor];
    [self setAutoresizesSubviews:YES];
    
    _partsOfSpeech = [[NSArray arrayWithObjects:@"adjective", @"adverb", @"conjunction", @"interjection",@"N/A", @"noun", @"preposition", @"pronoun", @"verb", nil] retain];
    
    _partOfSpeechPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [_partOfSpeechPicker setShowsSelectionIndicator:TRUE];
    [self addSubview:_partOfSpeechPicker];
    
    return self;
}

- (void) dealloc 
{
    [_partOfSpeechPicker setDelegate:nil];
    [_partOfSpeechPicker release];
    [_partsOfSpeech release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
- (UIPickerView*) partOfSpeechPicker
{
    return _partOfSpeechPicker;
}

- (NSArray*) partsOfSpeech
{
    return _partsOfSpeech;
}

#pragma mark -
#pragma mark Methods
- (int) partOfSpeechToIndex:(NSString*)partOfSpeech
{
    int index;
    
    for (index = 0; index < [_partsOfSpeech count]; ++index) 
    {
        if ([partOfSpeech isEqualToString:[_partsOfSpeech objectAtIndex:index]])
        {
            break;
        }
    }
    
    return index;
}

#pragma mark UIView Methods
- (void) layoutSubviews
{
    CGRect mainView = [self frame];
    float height = mainView.size.height;
    float width = mainView.size.width;
    CGRect pickerRect = CGRectZero;
    CGRect marginRect = CGRectZero;
    
    // Put a little margin between the content and the top, left, bottom, and right edges.
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMaxYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMinXEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMaxXEdge);
    
    // Give the picker as much of the screen as it will take
    CGRectDivide(mainView, &pickerRect, &mainView, height * 0.15f, CGRectMinYEdge);
        
    pickerRect = CGRectIntegral(pickerRect);
    
    [_partOfSpeechPicker setFrame:pickerRect];
}

@end
