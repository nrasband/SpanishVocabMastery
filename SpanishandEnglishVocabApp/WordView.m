//
//  WordView.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/18/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "WordView.h"

#pragma mark -
#pragma mark Private Interface
@interface WordView ()
@end

#pragma mark -
@implementation WordView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame
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
    
   
    // Instantiate all of our labels, textfields, buttons, and segmented controls.
    _englishLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_englishLabel setText:NSLocalizedString(@"English", @"")];
    [_englishLabel setBackgroundColor:backgroundColor];
    [_englishLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self addSubview:_englishLabel];
    
    _spanishLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_spanishLabel setText:NSLocalizedString(@"Spanish", @"")];
    [_spanishLabel setBackgroundColor:backgroundColor];
    [_spanishLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self addSubview:_spanishLabel];
    
    _exampleSentenceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_exampleSentenceLabel setText:NSLocalizedString(@"Example sentence:", @"")];
    [_exampleSentenceLabel setBackgroundColor:backgroundColor];
    [_exampleSentenceLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self addSubview:_exampleSentenceLabel];
    
    _genderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_genderLabel setText:NSLocalizedString(@"Gender", @"")];
    [_genderLabel setBackgroundColor:backgroundColor];
    [_genderLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self addSubview:_genderLabel];
    
    _singularOrPluralLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_singularOrPluralLabel setText:@"Sing/Plur"];
    [_singularOrPluralLabel setBackgroundColor:backgroundColor];
    [_singularOrPluralLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [self addSubview:_singularOrPluralLabel];
    
    _englishText = [[UITextField alloc] initWithFrame:CGRectZero];
    [_englishText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_englishText setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_englishText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_englishText setFont:[UIFont systemFontOfSize:fontSize]];
    [_englishText setBorderStyle:UITextBorderStyleRoundedRect];
    [_englishText setBackgroundColor:backgroundColor];
    [_englishText setClearButtonMode:YES];
    [_englishText setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_englishText];
    
    _spanishText = [[UITextField alloc] initWithFrame:CGRectZero];
    [_spanishText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_spanishText setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_spanishText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_spanishText setBorderStyle:UITextBorderStyleRoundedRect];
    [_spanishText setBackgroundColor:backgroundColor];
    [_spanishText setFont:[UIFont systemFontOfSize:fontSize]];
    [_spanishText setClearButtonMode:YES];
    [_spanishText setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_spanishText];
    
    _exampleSentenceButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [[_exampleSentenceButton titleLabel] setFont:[UIFont systemFontOfSize:fontSize]];
    [_exampleSentenceButton setTitle:NSLocalizedString(@"Example sentences", @"") forState:UIControlStateNormal];
    [self addSubview:_exampleSentenceButton];
    
    _categoryButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [[_categoryButton titleLabel] setFont:[UIFont systemFontOfSize:fontSize]];
    [_categoryButton setTitle:NSLocalizedString(@"Category", @"") forState:UIControlStateNormal];
    [self addSubview:_categoryButton];
    
    _partOfSpeechButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [[_partOfSpeechButton titleLabel] setFont:[UIFont systemFontOfSize:fontSize]];
    [_partOfSpeechButton setTitle:NSLocalizedString(@"Part of Speech", @"") forState:UIControlStateNormal];
    [self addSubview:_partOfSpeechButton];
    
    _imageButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [[_imageButton titleLabel] setFont:[UIFont systemFontOfSize:fontSize]];
    [self addSubview:_imageButton];    
    
    _genderControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"M", @"F", @"N/A", nil]];
	[self addSubview:_genderControl];
    
    _singularOrPluralControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Singular", @"Plural", @"N/A", nil]];
	[self addSubview:_singularOrPluralControl];
	
    return self;
}

- (void) dealloc 
{
    [_englishText setDelegate:nil];
    [_spanishText setDelegate:nil];
    
    [_englishLabel release];
    [_spanishLabel release];
    [_exampleSentenceLabel release];
    [_genderLabel release];
    [_singularOrPluralLabel release];
    [_englishText release];
    [_spanishText release];
    [_exampleSentenceButton release];
    [_categoryButton release];
    [_partOfSpeechButton release];
    [_imageButton release];
    [_genderControl release];
    [_singularOrPluralControl release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (UIButton*) categoryButton
{
    return _categoryButton;
}

- (UIButton*) partOfSpeechButton
{
    return _partOfSpeechButton;
}

- (UIButton*) imageButton
{
    return _imageButton;
}

- (UISegmentedControl*) singularOrPluralControl
{
    return _singularOrPluralControl;
}

- (UISegmentedControl*) genderControl
{
    return _genderControl;
}

- (UITextField*) englishText
{
    return _englishText;
}

- (UITextField*) spanishText
{
    return _spanishText;
}

- (UIButton*) exampleSentenceButton
{
    return _exampleSentenceButton;
}


#pragma mark -
#pragma mark Methods

#pragma mark UIView Methods
- (void) layoutSubviews
{
    // Layout the views so that this view looks good in landscape and portrait mode on both iPhone and iPad.
    CGRect mainView = [self frame];
    float height = mainView.size.height;
    float width = mainView.size.width;
    CGRect marginRect = CGRectZero;
    
    CGRect englishRect = CGRectZero;
    CGRect englishLabelRect = CGRectZero;
    CGRect englishTextRect = CGRectZero;
    
    CGRect spanishRect = CGRectZero;
    CGRect spanishLabelRect = CGRectZero;
    CGRect spanishTextRect = CGRectZero;
    
    CGRect exampleRect = CGRectZero;
    CGRect exampleLabelRect = CGRectZero;
    CGRect exampleButtonRect = CGRectZero;
    
    CGRect genderRect = CGRectZero;
    CGRect genderLabelRect = CGRectZero;
    CGRect genderSegRect = CGRectZero;
    
    CGRect singPluralRect = CGRectZero;
    CGRect singPluralLabelRect = CGRectZero;
    CGRect singPuralSegRect = CGRectZero;
    
    // Put a little margin between the content and the top, left, bottom, and right edges.
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMaxYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMinXEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMaxXEdge);
    
    // Slice off portions for the label and text field and put a little margin in between.
    CGRectDivide(mainView, &englishRect, &mainView, height * 0.10f, CGRectMinYEdge);
    CGRectDivide(englishRect, &englishTextRect, &englishLabelRect, width * (6.0f/8.0f), CGRectMaxXEdge);
    CGRectDivide(englishRect, &marginRect, &englishLabelRect, width * (0.5f/8.0f), CGRectMaxXEdge);    
    
    // Put a margin between the English and Spanish text fields and labels
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
    
    // Slice off portions for the Spanish label and text field with a little margin in between.
    CGRectDivide(mainView, &spanishRect, &mainView, height * 0.10f, CGRectMinYEdge);
    CGRectDivide(spanishRect, &spanishTextRect, &spanishLabelRect, width * (6.0f/8.0f), CGRectMaxXEdge);
    CGRectDivide(spanishRect, &marginRect, &spanishLabelRect, width * (0.5f/8.0f), CGRectMaxXEdge);  
    
    // Put a margin between the Spanish and the example sentence.
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMinYEdge);
    
    // Slice off portions for the Example Sentence label and text field.
    CGRectDivide(mainView, &exampleRect, &mainView, height * 0.25f, CGRectMinYEdge);
    CGRectDivide(exampleRect, &exampleLabelRect, &exampleButtonRect, height * 0.08f, CGRectMinYEdge);
    
    // Put a margin between the Example fields and the gender fields.
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
    
    // Slice off a portion for the gender
    CGRectDivide(mainView, &genderRect, &mainView, height * 0.15f, CGRectMinYEdge);
    CGRectDivide(genderRect, &genderSegRect, &genderLabelRect, width * (6.0f/8.0f), CGRectMaxXEdge);
    CGRectDivide(genderRect, &marginRect, &genderLabelRect, width * (0.5f/8.0f), CGRectMaxXEdge);
    
    // Put a margin between the gender fields and the singular/plural fields.
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMinYEdge);
    
    // Slice off a portion for the singular/plural fields
    CGRectDivide(mainView, &singPluralRect, &mainView, height * 0.15f, CGRectMinYEdge);
    CGRectDivide(singPluralRect, &singPluralLabelRect, &singPuralSegRect, width * (1.8f/8.0f), CGRectMinXEdge);
    
    // Put a margin between the gender fields and the singular/plural fields.
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMinYEdge);
    
    // Slice off a portion for the category and part of speech buttons
    CGRect categoryRect = CGRectZero;
    CGRect partOfSpeechRect = CGRectZero;
    CGRect imageRect = CGRectZero;
    CGRectDivide(mainView, &categoryRect, &mainView, height * 0.15f, CGRectMinYEdge);
    CGRectDivide(categoryRect, &categoryRect, &partOfSpeechRect, width * (2.5f/8.0f), CGRectMinXEdge);
    CGRectDivide(partOfSpeechRect, &marginRect, &partOfSpeechRect, width * (0.1f/8.0f), CGRectMinXEdge);
    CGRectDivide(partOfSpeechRect, &partOfSpeechRect, &imageRect, width * (3.5f/8.0f), CGRectMinXEdge);
    CGRectDivide(imageRect, &marginRect, &imageRect, width * (0.1f/8.0f), CGRectMinXEdge);
    
    categoryRect = CGRectIntegral(categoryRect);
    partOfSpeechRect = CGRectIntegral(partOfSpeechRect);
    
    // Make the imageRect square.
    imageRect.size.width = imageRect.size.height;
    imageRect = CGRectIntegral(imageRect);
    
    [_categoryButton setFrame:categoryRect];
    [_partOfSpeechButton setFrame:partOfSpeechRect];
    [_imageButton setFrame:imageRect];
    
    // Make all rectangles of integral size
    englishLabelRect = CGRectIntegral(englishLabelRect);
    englishTextRect = CGRectIntegral(englishTextRect);
    
    spanishLabelRect = CGRectIntegral(spanishLabelRect);
    spanishTextRect = CGRectIntegral(spanishTextRect);
    
    exampleLabelRect = CGRectIntegral(exampleLabelRect);
    exampleButtonRect = CGRectIntegral(exampleButtonRect);
    
    genderLabelRect = CGRectIntegral(genderLabelRect);
    genderSegRect = CGRectIntegral(genderSegRect);
    
    singPluralLabelRect = CGRectIntegral(singPluralLabelRect);
    singPuralSegRect = CGRectIntegral(singPuralSegRect);
    
    // Update the frames of the individual UI elements
    [_englishLabel setFrame:englishLabelRect];
    [_englishText setFrame:englishTextRect];
    
    [_spanishLabel setFrame:spanishLabelRect];
    [_spanishText setFrame:spanishTextRect];
    
    [_exampleSentenceLabel setFrame:exampleLabelRect];
    [_exampleSentenceButton setFrame:exampleButtonRect];
    
    [_genderLabel setFrame:genderLabelRect];
    [_genderControl setFrame:genderSegRect];
    
    [_singularOrPluralLabel setFrame:singPluralLabelRect];
    [_singularOrPluralControl setFrame:singPuralSegRect];
}

@end
