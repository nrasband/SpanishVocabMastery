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
    
    [self setBackgroundColor:[UIColor colorWithRed:0.478f green:0.69f blue:0.839f alpha:1.0f]];
    [self setAutoresizesSubviews:YES];
    
    // Add text field for creating new categories
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [_textField setFont:[UIFont systemFontOfSize:fontSize]];
    [_textField setText:NSLocalizedString(@"Add category", @"")];
    [_textField setClearsOnBeginEditing:YES];
    [_textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect];
    [_textField setBackgroundColor:[UIColor colorWithRed:0.478f green:0.69f blue:0.839f alpha:1.0f]];
    [_textField setClearButtonMode:YES];
    [_textField setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_textField];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self addSubview:_tableView];
    
    return self;
}

- (void) dealloc 
{
    [_textField setDelegate:nil];
    [_tableView setDelegate:nil];
    [_tableView setDataSource:nil];
    [_textField release];
    [_tableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
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


#pragma mark UIView Methods
- (void) layoutSubviews
{
    CGRect screenBounds = [self frame];
    float height = screenBounds.size.height;
    float width = screenBounds.size.width;
    
    // Create rectangles for each portion of the layout
    CGRect marginRect = CGRectZero;
    CGRect tableRect = CGRectZero;
    CGRect textFieldRect = CGRectZero;
    
    // Put a little margin between the content and the top, left, bottom, and right edges.
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.02f, CGRectMinYEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.01f, CGRectMaxYEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, width * 0.01f, CGRectMinXEdge);
    CGRectDivide(screenBounds, &marginRect, &screenBounds, width * 0.01f, CGRectMaxXEdge);
    
    // Slice off a portion for the text field
    CGRectDivide(screenBounds, &textFieldRect, &screenBounds, height * 0.15f, CGRectMinYEdge);
    
    // margin
    CGRectDivide(screenBounds, &marginRect, &screenBounds, height * 0.02f, CGRectMinYEdge);
       
    tableRect = screenBounds;
    
    
    // Make sure all of the rectanges we are using are integral
    textFieldRect = CGRectIntegral(textFieldRect);
    tableRect = CGRectIntegral(tableRect);
    
    // Resize the textfield
    [_textField setFrame:textFieldRect];
    
    // Resize the UITableView
    [_tableView setFrame:tableRect];
}

@end
