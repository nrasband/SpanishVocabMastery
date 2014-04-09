//
//  ExampleSentencesView.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 6/16/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "ExampleSentencesView.h"

#pragma mark -
#pragma mark Private Interface
@interface ExampleSentencesView ()
@end

#pragma mark -
@implementation ExampleSentencesView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame english:(NSString*)englishExample spanish:(NSString*)spanishExample
{
    self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
    
    UIColor* backgroundColor = [UIColor colorWithRed:0.478f green:0.69f blue:0.839f alpha:1.0f];
    
    [self setBackgroundColor:backgroundColor];
    [self setAutoresizesSubviews:YES];
    
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
    
    _englishExampleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_englishExampleLabel setText:NSLocalizedString(@"English example:", @"")];
    [_englishExampleLabel setBackgroundColor:backgroundColor];
    [_englishExampleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self addSubview:_englishExampleLabel];
    
    _spanishExampleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_spanishExampleLabel setText:NSLocalizedString(@"Spanish example:", @"")];
    [_spanishExampleLabel setBackgroundColor:backgroundColor];
    [_spanishExampleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self addSubview:_spanishExampleLabel];
    
    _englishExampleText = [[UITextView alloc] initWithFrame:CGRectZero];
    [_englishExampleText setText:englishExample];
    [_englishExampleText setFont:[UIFont systemFontOfSize:fontSize]];
    [_englishExampleText setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_englishExampleText setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_englishExampleText];    
    
    _spanishExampleText = [[UITextView alloc] initWithFrame:CGRectZero];
    [_spanishExampleText setText:spanishExample];
    [_spanishExampleText setFont:[UIFont systemFontOfSize:fontSize]];
    [_spanishExampleText setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_spanishExampleText setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_spanishExampleText];
	
    return self;
}

- (void) dealloc 
{
    [_englishExampleLabel release];
    [_spanishExampleLabel release];
    
    [_englishExampleText release];
    [_spanishExampleText release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
- (UILabel*) englishExampleLabel
{
    return _englishExampleLabel;
}

- (UILabel*) spanishExampleLabel
{
    return _spanishExampleLabel;
}

- (UITextView*) englishExampleText
{
    return _englishExampleText;
}

- (UITextView*) spanishExampleText
{
    return _spanishExampleText;
}

#pragma mark -
#pragma mark Methods

#pragma mark UIView Methods
- (void) layoutSubviews
{
    CGRect mainView = [self frame];
    float width = mainView.size.width;
    float height = mainView.size.height;
    CGRect marginRect = CGRectZero;
    CGRect englishLabelRect = CGRectZero;
    CGRect spanishLabelRect = CGRectZero;
    CGRect englishTextRect = CGRectZero;
    CGRect spanishTextRect = CGRectZero;
    
    // Put a little margin between the content and the top, left, bottom, and right edges.
    //CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMinYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMaxYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMinXEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMaxXEdge);
    
    // Slice out a place for the english label
    CGRectDivide(mainView, &englishLabelRect, &mainView, height * 0.15f, CGRectMinYEdge);
    englishLabelRect = CGRectIntegral(englishLabelRect);
    [_englishExampleLabel setFrame:englishLabelRect];
    
    // Create a margin
    //CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMinYEdge);
    
    // Slice out a place for the English text
    CGRectDivide(mainView, &englishTextRect, &mainView, height * 0.30f, CGRectMinYEdge);
    englishTextRect = CGRectIntegral(englishTextRect);
    [_englishExampleText setFrame:englishTextRect];
    
    // Create a margin
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMinYEdge);
    
    // Slice out a place for the spanish label
    CGRectDivide(mainView, &spanishLabelRect, &mainView, height * 0.15f, CGRectMinYEdge);
    spanishLabelRect = CGRectIntegral(spanishLabelRect);
    [_spanishExampleLabel setFrame:spanishLabelRect];
    
    // Create a margin
    //CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMinYEdge);
    
    // Slice out a place for the english text
    CGRectDivide(mainView, &spanishTextRect, &mainView, height * 0.30f, CGRectMinYEdge);
    spanishTextRect = CGRectIntegral(spanishTextRect);
    [_spanishExampleText setFrame:spanishTextRect];
}

@end
