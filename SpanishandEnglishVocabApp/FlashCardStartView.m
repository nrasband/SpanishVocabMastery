//
//  FlashCardStartView.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/21/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "FlashCardStartView.h"

#pragma mark -
#pragma mark Private Interface
@interface FlashCardStartView ()

@end

#pragma mark -
@implementation FlashCardStartView

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
    [self setAutoresizesSubviews:TRUE];
    
    _direction = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"English to Spanish", @""), NSLocalizedString(@"Spanish to English", @""), nil]];
    [_direction setSegmentedControlStyle:UISegmentedControlStyleBar];
    [self addSubview:_direction];
    
    _pictureLocation = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Picture on front", @""), NSLocalizedString(@"Picture on back", @""), NSLocalizedString(@"No picture", @""), nil]];
    [_pictureLocation setSegmentedControlStyle:UISegmentedControlStyleBar];
    [self addSubview:_pictureLocation];
    
    _showEnglishExample = [[UILabel alloc] initWithFrame:CGRectZero];
    [_showEnglishExample setFont:[UIFont systemFontOfSize:fontSize]];
    [_showEnglishExample setText:NSLocalizedString(@"Show English example", @"")];
    [_showEnglishExample setBackgroundColor:backgroundColor];
    [self addSubview:_showEnglishExample];
    
    _englishExampleSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_englishExampleSwitch setContentMode:UIViewContentModeCenter];
    [self addSubview:_englishExampleSwitch];
    
    _showSpanishExample = [[UILabel alloc] initWithFrame:CGRectZero];
    [_showSpanishExample setFont:[UIFont systemFontOfSize:fontSize]];
    [_showSpanishExample setText:NSLocalizedString(@"Show Spanish example", @"")];
    [_showSpanishExample setBackgroundColor:backgroundColor];
    [self addSubview:_showSpanishExample];
    
    _spanishExampleSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self addSubview:_spanishExampleSwitch];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self addSubview:_tableView];
	
    return self;
}

- (void) dealloc 
{
    [_direction release];
    [_pictureLocation release];
    [_showEnglishExample release];
    [_showSpanishExample release];
    [_englishExampleSwitch release];
    [_spanishExampleSwitch release];
    [_tableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
- (UISegmentedControl*) direction
{
    return _direction;
}

- (UISegmentedControl*) pictureLocation
{
    return _pictureLocation;
}

- (UISwitch*) englishExampleSwitch
{
    return _englishExampleSwitch;
}

- (UISwitch*) spanishExampleSwitch
{
    return _spanishExampleSwitch;
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
    CGRect mainView = [self frame];
    float height = mainView.size.height;
    float width = mainView.size.width;
    CGRect directionRect = CGRectZero;
    CGRect pictureRect = CGRectZero;
    CGRect englishExampleLabelRect = CGRectZero;
    CGRect spanishExampleLabelRect = CGRectZero;
    CGRect englishExampleRect = CGRectZero;
    CGRect spanishExampleRect = CGRectZero;
    CGRect tableRect = CGRectZero;
    CGRect marginRect = CGRectZero;
    
    // Put a little margin between the content and the top, left, bottom, and right edges.
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.01f, CGRectMaxYEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMinXEdge);
    CGRectDivide(mainView, &marginRect, &mainView, width * 0.01f, CGRectMaxXEdge);
    
    // Slice off the direction rectangle
    CGRectDivide(mainView, &directionRect, &mainView, height * 0.15f, CGRectMinYEdge);
    
    // Add some margin
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
    
    // Slice off the picture rectangle
    CGRectDivide(mainView, &pictureRect, &mainView, height * 0.15f, CGRectMinYEdge);   
    
    // Add some margin
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
    
    // Slice off the english example rectangle
    CGRectDivide(mainView, &englishExampleLabelRect, &mainView, [[_showEnglishExample text] sizeWithFont:[_showEnglishExample font]].height , CGRectMinYEdge);
    CGRectDivide(englishExampleLabelRect, &englishExampleLabelRect, &englishExampleRect, width * 0.65f, CGRectMinXEdge);
    
    // Add some margin
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.02f, CGRectMinYEdge);
    
    // Slice off the spanish example rectangle
    CGRectDivide(mainView, &spanishExampleLabelRect, &mainView, [[_showSpanishExample text] sizeWithFont:[_showSpanishExample font]].height, CGRectMinYEdge);
    CGRectDivide(spanishExampleLabelRect, &spanishExampleLabelRect, &spanishExampleRect, width * 0.65f, CGRectMinXEdge);
    
    CGRectDivide(mainView, &marginRect, &mainView, height * 0.04f, CGRectMinYEdge);
    
    // The rest is table
    tableRect = mainView;
    
    directionRect = CGRectIntegral(directionRect);
    pictureRect = CGRectIntegral(pictureRect);
    englishExampleLabelRect = CGRectIntegral(englishExampleLabelRect);
    spanishExampleLabelRect = CGRectIntegral(spanishExampleLabelRect);
    englishExampleRect = CGRectIntegral(englishExampleRect);
    spanishExampleRect = CGRectIntegral(spanishExampleRect);
    tableRect = CGRectIntegral(tableRect);
    
    [_direction setFrame:directionRect];
    [_pictureLocation setFrame:pictureRect];
    [_englishExampleSwitch setFrame:englishExampleRect];
    [_spanishExampleSwitch setFrame:spanishExampleRect];
    [_showEnglishExample setFrame:englishExampleLabelRect];
    [_showSpanishExample setFrame:spanishExampleLabelRect];
    [_tableView setFrame:tableRect];
}

@end
