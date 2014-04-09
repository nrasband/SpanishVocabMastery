//
//  CategoryView.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/20/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "CategoryView.h"

#pragma mark -
#pragma mark Private Interface
@interface CategoryView ()
@end

#pragma mark -
@implementation CategoryView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame
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
    
    _categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_categoryLabel setTextAlignment:UITextAlignmentCenter];
    [_categoryLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [_categoryLabel setText:NSLocalizedString(@"Add new or select existing category", @"")];
    [self addSubview:_categoryLabel];
    
    _categoryText = [[UITextField alloc] initWithFrame:CGRectZero];
	[_categoryText setBorderStyle:UITextBorderStyleRoundedRect];
    [_categoryText setFont:[UIFont systemFontOfSize:fontSize]];
	[_categoryText setReturnKeyType:UIReturnKeyDone];
	[_categoryText setAutocorrectionType:UITextAutocorrectionTypeNo]; // Don't autocorrect
	[_categoryText setAutocapitalizationType:UITextAutocapitalizationTypeNone]; // Don't autocapitalize
    [_categoryText setClearsOnBeginEditing:TRUE];
    [_categoryText setPlaceholder:NSLocalizedString(@"Enter category here", @"")];
	[self addSubview:_categoryText];
    
    
    _categoryPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [_categoryPicker setShowsSelectionIndicator:TRUE];
    [self addSubview:_categoryPicker];
    
    return self;
}

- (void) dealloc 
{
    [_categoryText setDelegate:nil];
    [_categoryPicker setDelegate:nil];
    [_categoryLabel release];
    [_categoryText release];
    [_categoryPicker release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (UITextField*) categoryText
{
    return _categoryText;
}

- (UIPickerView*) categoryPicker
{
    return _categoryPicker;
}

#pragma mark -
#pragma mark Methods


#pragma mark UIView Methods
- (void) layoutSubviews
{
    CGRect mainView = [self frame];
    float height = mainView.size.height;
    float width = mainView.size.width;
    CGRect labelRect = CGRectZero;
    CGRect textRect = CGRectZero;
    CGRect pickerRect = CGRectZero;
    CGRect marginRect = CGRectZero;
    
    // Put a little margin between the content and the top, left, bottom, and right edges.
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMaxYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMinXEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMaxXEdge);
    
    // Give label 10% of screen
    CGRectDivide(mainView, &labelRect, &mainView, height * 0.10f, CGRectMinYEdge);
    
    // Put a little margin between label and text field.
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMinYEdge);
    
    // Give text field 10% of screen
    CGRectDivide(mainView, &textRect, &mainView, height * 0.10f, CGRectMinYEdge);
    
    // Put a little margin between text field and picker
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMinYEdge);
    
    // Give the picker the rest of the screen.
    CGRectDivide(mainView, &pickerRect, &mainView, mainView.size.height, CGRectMinYEdge);
    
    
    // Make all rectangles integral.
    labelRect = CGRectIntegral(labelRect);
    textRect = CGRectIntegral(textRect);
    pickerRect = CGRectIntegral(pickerRect);
    
    // Set frames on all controls
    [_categoryLabel setFrame:labelRect];
    [_categoryText setFrame:textRect];
    [_categoryPicker setFrame:pickerRect]; 
}

@end
