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
    
    [self setBackgroundColor:[UIColor colorWithRed:0.478f green:0.69f blue:0.839f alpha:1.0f]];
    [self setAutoresizesSubviews:YES];
    
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button setTitle:NSLocalizedString(@"Add definition", @"") forState:UIControlStateNormal];
    [self addSubview:_button];
    
    _tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
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
    CGRect tableRect = CGRectZero;
    CGRect buttonRect = CGRectZero;
    
    // Put a little margin between the content and the top, left, bottom, and right edges.
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.02f, CGRectMinYEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.01f, CGRectMaxYEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, width * 0.01f, CGRectMinXEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, width * 0.01f, CGRectMaxXEdge);
    
    // Slice off portion for the button
    CGRectDivide(screenBounds, &buttonRect, &screenBounds, height * 0.10f, CGRectMinYEdge);
    CGRectDivide(buttonRect, &buttonRect, &marginRect, width * (3.0f/8.0f), CGRectMinXEdge);
    
    // Carve out a spot for the table
    CGRectDivide(screenBounds, &tableRect, &screenBounds, height * 0.85f, CGRectMaxYEdge);
    
    
    // Make sure all of the rectanges we are using are integral
    buttonRect = CGRectIntegral(buttonRect);
    tableRect = CGRectIntegral(tableRect);
    
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
