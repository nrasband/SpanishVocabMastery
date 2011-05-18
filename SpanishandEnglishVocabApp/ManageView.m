//
//  ManageView.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/16/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "ManageView.h"

#pragma mark -
#pragma mark Private Interface
@interface ManageView ()
@end

#pragma mark -
@implementation ManageView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
    
    [self setBackgroundColor:[UIColor colorWithRed:0.478f green:0.69f blue:0.839f alpha:1.0f]];
    [self setAutoresizesSubviews:YES];
    
    // Add text field for creating new categories
    _textField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
    //[_textField setTextAlignment:UITextAlignmentCenter];
    [_textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];
    [_textField setBackgroundColor:[UIColor colorWithRed:0.478f green:0.69f blue:0.839f alpha:1.0f]];
    [_textField setClearButtonMode:YES];
    [_textField setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_textField];
    
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button setTitle:NSLocalizedString(@"Add category", @"") forState:UIControlStateNormal];
    [self addSubview:_button];
    
    _tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
    //[_tableView setBackgroundColor:[UIColor colorWithRed:0.478f green:0.69f blue:0.839f alpha:1.0f]];
    [self addSubview:_tableView];
    
    // Layout each view.
    [self layoutViews];
    
    return self;
}

- (void) dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
- (UIButton*) button
{
    return _button;
}

- (UITextField*) textField
{
    return _textField;
}

- (UITableView*) tableView
{
    return _tableView;
}

#pragma mark -
#pragma mark Methods
- (void) layoutViews
{
    CGRect screenBounds = [self frame];
    float height = screenBounds.size.height;
    float width = screenBounds.size.width;
    
    // Create rectangles for each portion of the layout
    CGRect marginRect = CGRectZero;
    CGRect addRect = CGRectZero;
    CGRect tableRect = CGRectZero;
    CGRect textFieldRect = CGRectZero;
    CGRect buttonRect = CGRectZero;
    
    // Put a little margin between the content and the top, left, bottom, and right edges.
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.02f, CGRectMinYEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.01f, CGRectMaxYEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, width * 0.01f, CGRectMinXEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, width * 0.01f, CGRectMaxXEdge);
    
    // Slice off portions for the text field and button with a little margin in between
    CGRectDivide(screenBounds, &addRect, &screenBounds, height * 0.10f, CGRectMinYEdge);
    CGRectDivide(addRect, &buttonRect, &textFieldRect, width * (3.0f/8.0f), CGRectMaxXEdge);
    CGRectDivide(textFieldRect, &marginRect, &textFieldRect, width * (0.5f/8.0f), CGRectMaxXEdge);
    
    // Carve out a spot for the table
    CGRectDivide(screenBounds, &tableRect, &screenBounds, height * 0.85f, CGRectMaxYEdge);
    
    
    // Make sure all of the rectanges we are using are integral
    textFieldRect = CGRectIntegral(textFieldRect);
    buttonRect = CGRectIntegral(buttonRect);
    tableRect = CGRectIntegral(tableRect);
    
    // Resize the textfield
    [_textField setFrame:textFieldRect];
    
    // Resize button
    [_button setFrame:buttonRect];
    
    // Resize the UITableView
    [_tableView setFrame:tableRect];

}

#pragma mark UIView Methods
- (void) layoutSubviews
{
    [self layoutViews];
}

@end
