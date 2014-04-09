//
//  SearchView.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/21/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "SearchView.h"

#pragma mark -
#pragma mark Private Interface
@interface SearchView ()
@end

#pragma mark -
@implementation SearchView

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
        fontSize = 20.0f;
    }
    else
    {
        fontSize = 13.0f;
    }
    
    UIColor* backgroundColor = [UIColor colorWithRed:0.478f green:0.69f blue:0.839f alpha:1.0f];
    [self setBackgroundColor:backgroundColor];
    [self setAutoresizesSubviews:TRUE];
    
    _randomWordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_randomWordLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [_randomWordLabel setBackgroundColor:backgroundColor];
    [self addSubview:_randomWordLabel];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [_searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_searchBar setShowsCancelButton:TRUE];
    [self addSubview:_searchBar];
    
    _languageDirectionSelection = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"English to Spanish", @""), NSLocalizedString(@"Spanish to English", @""), nil]];
    [_languageDirectionSelection setSegmentedControlStyle:UISegmentedControlStyleBar];
    [self addSubview:_languageDirectionSelection];
    
    _resultsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:_resultsTable];
    
	
    return self;
}

- (void) dealloc 
{
    [_searchBar setDelegate:nil];
    [_searchBar release];
    
    [_randomWordLabel release];
    
    [_languageDirectionSelection release];
    
    [_resultsTable setDelegate:nil];
    [_resultsTable setDataSource:nil];
    [_resultsTable release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
- (UILabel*) randomWordLabel
{
    return _randomWordLabel;
}

- (UISearchBar*) searchBar
{
    return _searchBar;
}

- (UISegmentedControl*) languageDirectionSelection
{
    return _languageDirectionSelection;
}

- (UITableView*) resultsTable
{
    return _resultsTable;
}

#pragma mark -
#pragma mark Methods

#pragma mark UIView Methods
- (void) layoutSubviews
{
    // Layout the views so that this view looks good in landscape and portrait mode on both iPhone and iPad.
    CGRect mainView = [self frame];
    float height = mainView.size.height;
    CGRect labelRect = CGRectZero;
    CGRect searchRect = CGRectZero;
    CGRect segmentRect = CGRectZero;
    CGRect tableRect = CGRectZero;
    
    // Label
    CGRectDivide(mainView, &labelRect, &mainView, height * 0.08f, CGRectMinYEdge);
    
    // Search bar
    CGRectDivide(mainView, &searchRect, &mainView, height * 0.15f, CGRectMinYEdge);
    
    // Segmented control
    CGRectDivide(mainView, &segmentRect, &mainView, height * 0.12f, CGRectMinYEdge);
    
    // Table rect
    tableRect = mainView;
    
    // Make all rectangles integral
    labelRect = CGRectIntegral(labelRect);
    searchRect = CGRectIntegral(searchRect);
    segmentRect = CGRectIntegral(segmentRect);
    tableRect = CGRectIntegral(tableRect);
    
    // Set frames of all controls
    [_randomWordLabel setFrame:labelRect];
    [_searchBar setFrame:searchRect];
    [_languageDirectionSelection setFrame:segmentRect];
    [_resultsTable setFrame:tableRect];
}

@end
