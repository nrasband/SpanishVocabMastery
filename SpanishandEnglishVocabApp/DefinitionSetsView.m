//
//  DefinitionSetsView.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/18/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "DefinitionSetsView.h"

#pragma mark -
#pragma mark Private Interface
@interface DefinitionSetsView ()
@end

#pragma mark -
@implementation DefinitionSetsView

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
    
    // Add text field for changing category name
    _categoryTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [_categoryTextField setFont:[UIFont systemFontOfSize:fontSize]];
    [_categoryTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_categoryTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_categoryTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_categoryTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_categoryTextField setBackgroundColor:backgroundColor];
    [_categoryTextField setClearsOnBeginEditing:YES];
    [_categoryTextField setClearButtonMode:YES];
    [_categoryTextField setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_categoryTextField];
    
    _button = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [[_button titleLabel] setFont:[UIFont systemFontOfSize:fontSize]];
    [_button setTitle:NSLocalizedString(@"Add definition", @"") forState:UIControlStateNormal];
    [self addSubview:_button];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self addSubview:_tableView];  
	
    return self;
}

- (void) dealloc 
{
    [_categoryTextField setDelegate:nil];
    [_categoryTextField release];
    [_button release];
    [_tableView setDelegate:nil];
    [_tableView setDataSource:nil];
    [_tableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (UITextField*) categoryTextField
{
    return _categoryTextField;
}

- (UIButton*) button
{
    return _button;
}

- (UITableView*) tableView
{
    return _tableView;
}

#pragma mark -
#pragma mark Methods


#pragma mark UIView Methods
- (void) layoutSubviews
{
    CGRect screenBounds = [self frame];
    float height = screenBounds.size.height;
    float width = screenBounds.size.width;
    
    // Create rectangles for each portion of the layout
    CGRect marginRect = CGRectZero;
    CGRect categoryTextRect = CGRectZero;
    CGRect tableRect = CGRectZero;
    CGRect buttonRect = CGRectZero;
    
    // Put a little margin between the content and the top, left, bottom, and right edges.
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.02f, CGRectMinYEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.01f, CGRectMaxYEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, width * 0.01f, CGRectMinXEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, width * 0.01f, CGRectMaxXEdge);
    
    // Slice off a portion for the text field
    CGRectDivide(screenBounds, &categoryTextRect, &screenBounds, height * 0.15f, CGRectMinYEdge);
    
    // Put a little space between the category renaming and the Add definition button
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.02, CGRectMinYEdge);
    
    // Slice off portion for the button
    CGRectDivide(screenBounds, &buttonRect, &screenBounds, height * 0.15f, CGRectMinYEdge);
    CGRectDivide(buttonRect, &buttonRect, &marginRect, width * (5.0f/8.0f), CGRectMinXEdge);
    
    // Put a little space between the button and the table
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.02, CGRectMinYEdge);
    
    // Give the rest of the space to the table
    tableRect = screenBounds;
    
    
    // Make sure all of the rectanges we are using are integral
    categoryTextRect = CGRectIntegral(categoryTextRect);
    buttonRect = CGRectIntegral(buttonRect);
    tableRect = CGRectIntegral(tableRect);
    
    // Resize text field
    [_categoryTextField setFrame:categoryTextRect];
    
    // Resize button
    [_button setFrame:buttonRect];
    
    // Resize the UITableView
    [_tableView setFrame:tableRect];
}

@end
