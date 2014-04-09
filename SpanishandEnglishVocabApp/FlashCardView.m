//
//  FlashCardView.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/21/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "FlashCardView.h"

#pragma mark -
#pragma mark Private Interface
@interface FlashCardView ()

@end

#pragma mark -
@implementation FlashCardView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame definitionSet:(DefinitionSet*)definitionSet direction:(int)direction showEngExample:(BOOL)showEng showSpanExample:(BOOL)showSpan showPicture:(BOOL)showPicture
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
    [self setAutoresizesSubviews:TRUE];    
    
    [self setDirection:direction];
    [self setDefinitionSet:definitionSet];
    
    if (showEng && direction == ENG_SPA)
    {
        if ([definitionSet englishExampleSentence] != nil && [[definitionSet englishExampleSentence] length] > 0)
        {
            [self setExample:[definitionSet englishExampleSentence]];
            [self setShowExample:TRUE];
        }
    }
    else if (showSpan && direction == SPA_ENG)
    {
        if ([definitionSet spanishExampleSentence] != nil && [[definitionSet spanishExampleSentence] length] > 0)
        {
            [self setExample:[definitionSet spanishExampleSentence]];
            [self setShowExample:TRUE];
        }
    }
    
    // See if we should and can show a picture
    if (showPicture && [[self definitionSet] imagePath] != nil && [[[self definitionSet] imagePath] length] > 0)
    {
        [self setShowPicture:TRUE];
    }
    else
    {
        [self setShowPicture:FALSE];
    }
    
    // Show image if they want to see it.
    if ([self showPicture])
    {
        NSString* imagePath = [[self definitionSet] imagePath];
        if (imagePath != nil && [imagePath length] > 0)
        {
            UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
            if (image != nil)
            {
                _imageView = [[UIImageView alloc] initWithImage:image];
                [self addSubview:_imageView];
            }
            else
            {
                [self setShowPicture:FALSE];
            }
        }
    }
    
    _wordLabel = [[UITextView alloc] initWithFrame:CGRectZero];
    NSString* partOfSpeech = [[[self definitionSet] partOfSpeech] isEqualToString:@"N/A"] ? @"": [NSString stringWithFormat:@"(%@)", [[self definitionSet] partOfSpeech]];
    
    // Set the label correctly.
    NSString* gender = [[[self definitionSet] gender] isEqualToString:@"N/A"] ? @"" : [NSString stringWithFormat:@"(%@)", [[self definitionSet] gender]];
    gender = [gender lowercaseString];
    
    if (direction == ENG_SPA)
    {

        [_wordLabel setText:[NSString stringWithFormat:@"%@: %@ %@ %@", NSLocalizedString(@"English", @""), [[self definitionSet] english], NSLocalizedString(partOfSpeech, @""), gender]];
    }
    else
    {
        [_wordLabel setText:[NSString stringWithFormat:@"%@: %@ %@ %@ %@", NSLocalizedString(@"Spanish", @""), [[self definitionSet] article], [[self definitionSet] spanish], NSLocalizedString(partOfSpeech, @""), gender]];
    }
    
    [_wordLabel setBackgroundColor:backgroundColor];
    [_wordLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [_wordLabel setEditable:FALSE];
    [self addSubview:_wordLabel];
    
    if ([self showExample])
    {
        _exampleSentence = [[UITextView alloc] initWithFrame:CGRectZero];
        [_exampleSentence setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Example", @""), [self example]]];
        [_exampleSentence setBackgroundColor:[UIColor yellowColor]];
        [_exampleSentence setFont:[UIFont systemFontOfSize:fontSize]];
        [_exampleSentence setEditable:FALSE];
        [self addSubview:_exampleSentence];
    }
    
    _flipButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [[_flipButton titleLabel] setFont:[UIFont systemFontOfSize:fontSize]];
    [_flipButton setTitle:NSLocalizedString(@"Flip", @"") forState:UIControlStateNormal];
    [self addSubview:_flipButton];
    
    _previousButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [[_previousButton titleLabel] setFont:[UIFont systemFontOfSize:fontSize]];
    [_previousButton setTitle:NSLocalizedString(@"Previous", @"") forState:UIControlStateNormal];
    [self addSubview:_previousButton];
    
    _nextButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [[_nextButton titleLabel] setFont:[UIFont systemFontOfSize:fontSize]];
    [_nextButton setTitle:NSLocalizedString(@"Next", @"") forState:UIControlStateNormal];
    [self addSubview:_nextButton];
	
    return self;
}

- (void) dealloc 
{
    if ([self showPicture])
    {
        [_imageView release];
    }
    
    [_wordLabel release];
    
    [_example release];
    
    [_flipButton release];
    [_previousButton release];
    [_nextButton release];
    [_definitionSet release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize definitionSet = _definitionSet;
@synthesize direction = _direction;
@synthesize example = _example;
@synthesize showExample = _showExample;
@synthesize showPicture = _showPicture;

- (UIImageView*) imageView
{
    return _imageView;
}

- (UITextView*) wordLabel
{
    return _wordLabel;
}

- (UITextView*) exampleSentence
{
    return _exampleSentence;
}

- (UIButton*) flipButton
{
    return _flipButton;
}

- (UIButton*) previousButton
{
    return _previousButton;
}

- (UIButton*) nextButton
{
    return _nextButton;
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
    CGRect wordRect = CGRectZero;
    CGRect exampleRect = CGRectZero;
    CGRect flipRect = CGRectZero;
    CGRect previousRect = CGRectZero;
    CGRect nextRect = CGRectZero;
    
    // Put a little margin between the content and the top, left, bottom, and right edges.
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMaxYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMinXEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMaxXEdge);
    
    
    // Portrait view
    if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        if ([self showPicture])
        {
            CGRect imageRect = CGRectZero;
            
            // Slice off a piece for the image
            float lengthOfSquare = height * 0.5f;
            float borderWidth = (width - lengthOfSquare) / 2.0f;
            CGRectDivide(mainView, &imageRect, &mainView, lengthOfSquare, CGRectMinYEdge);
            
            // Left border
            CGRectDivide(imageRect, &marginRect, &imageRect, borderWidth, CGRectMinXEdge);
            CGRectDivide(imageRect, &imageRect, &marginRect, lengthOfSquare, CGRectMinXEdge);
            
            imageRect = CGRectIntegral(imageRect);
            [_imageView setFrame:imageRect];
        }
        
        // Word
        CGRectDivide(mainView, &wordRect, &mainView, height * 0.15f, CGRectMinYEdge);
            
        // Show explanation if needed
        if ([self showExample])
        {            
            CGRectDivide(mainView, &exampleRect, &mainView, height * 0.2f, CGRectMinYEdge);
            exampleRect = CGRectIntegral(exampleRect);
            [_exampleSentence setFrame:exampleRect];
        }
        
        // Margin
        CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
            
        // Buttons
        CGRect buttons = CGRectZero;
        CGRectDivide(mainView, &buttons, &mainView, height * 0.15f, CGRectMinYEdge);
        CGRectDivide(buttons, &flipRect, &buttons, width * 0.30f, CGRectMinXEdge);
        CGRectDivide(buttons, &marginRect, &buttons, width * 0.05f, CGRectMinXEdge);
        CGRectDivide(buttons, &previousRect, &buttons, width * 0.30f, CGRectMinXEdge);
        CGRectDivide(buttons, &marginRect, &nextRect, width * 0.05f, CGRectMinXEdge);
        
        // Make all rectangles of integral size
        
        wordRect = CGRectIntegral(wordRect);
        flipRect = CGRectIntegral(flipRect);
        previousRect = CGRectIntegral(previousRect);
        nextRect = CGRectIntegral(nextRect);
        
        // Resize controls
        [_wordLabel setFrame:wordRect];
        [_flipButton setFrame:flipRect];
        [_previousButton setFrame:previousRect];
        [_nextButton setFrame:nextRect];
    }
    else
    {
        if ([self showPicture])
        {
            CGRect imageRect = CGRectZero;    
            // Slice off a piece for the image
            float lengthOfSquare = height - (height * 0.04f);
            CGRectDivide(mainView, &imageRect, &mainView, lengthOfSquare, CGRectMinXEdge);      
            
            // Make all rectangles of integral size
            imageRect = CGRectIntegral(imageRect);
            
            // Resize controls
            [_imageView setFrame:imageRect];
        }
        
        // Small margin
        CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMinXEdge);
        
        // Setup the word
        CGRectDivide(mainView, &wordRect, &mainView, height * 0.3f, CGRectMinYEdge);
        wordRect = CGRectIntegral(wordRect);
        [_wordLabel setFrame:wordRect];
        
        // Margin
        CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
        
        // Setup the example
        if ([self showExample])
        {
            CGRectDivide(mainView, &exampleRect, &mainView, height * 0.4f, CGRectMinYEdge);
            exampleRect = CGRectIntegral(exampleRect);
            [_exampleSentence setFrame:exampleRect];
        }
        
        // Margin
        CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
        
        // Buttons
        CGRect buttons = CGRectZero;
        float remainingWidth = mainView.size.width;
        CGRectDivide(mainView, &buttons, &mainView, height * 0.2f, CGRectMinYEdge);
        CGRectDivide(buttons, &flipRect, &buttons, remainingWidth * 0.30f, CGRectMinXEdge);
        CGRectDivide(buttons, &marginRect, &buttons, remainingWidth * 0.01f, CGRectMinXEdge);
        CGRectDivide(buttons, &previousRect, &buttons, remainingWidth * 0.30f, CGRectMinXEdge);
        CGRectDivide(buttons, &marginRect, &nextRect, remainingWidth * 0.01f, CGRectMinXEdge);
        
        flipRect = CGRectIntegral(flipRect);
        previousRect = CGRectIntegral(previousRect);
        nextRect = CGRectIntegral(nextRect);
        
        [_flipButton setFrame:flipRect];
        [_previousButton setFrame:previousRect];
        [_nextButton setFrame:nextRect];
    }
    

}

@end
