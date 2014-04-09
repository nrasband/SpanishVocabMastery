//
//  SearchController.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/21/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "SearchController.h"

#pragma mark -
#pragma mark Private Interface
@interface SearchController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, WordControllerDelegate>

// Clears the TableView so that things don't get added twice or whatever.
- (void) clearTable;

@end

#pragma mark -
@implementation SearchController

#pragma mark Constructors
- (id) initWithRandomWord:(NSString*)randomWord
{
    self = [super init];
	if (self == nil)
		return self;
    
    [self setRandomWord:randomWord];
    
    [self setTitle:NSLocalizedString(@"Search", @"")];
    [self setTabBarItem:[[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0] autorelease]];
    
    // Set the initial lookup direction
    [self setDirection:ENG_SPA];
    
    // Find out if it is iPad or iPhone and set the font appropriately.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self setFontSize:30.0f];
    }
    else
    {
        [self setFontSize:17.0f];
    }
	
    return self;
}

- (void) dealloc 
{
    [self setDelegate:nil];
    [_randomWord release];
    [_searchTerm release];
    [_searchResults release];
    [_categories release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
@synthesize randomWord = _randomWord;
@synthesize direction = _direction;
@synthesize fontSize = _fontSize;
@synthesize searchTerm = _searchTerm;
@synthesize categories = _categories;

- (SearchView*) contentView
{
    return (SearchView*)[self view];
}

- (void) setSearchResults:(NSArray *)searchResults
{
    [_searchResults autorelease];
    _searchResults = [searchResults retain];
    [[[self contentView] resultsTable] reloadData];
}

- (NSArray*) searchResults
{
    return _searchResults;
}

#pragma mark -
#pragma mark Methods
- (void) clearTable
{
    [self setSearchResults:nil];
    [self setSearchTerm:nil];
    [[[self contentView] searchBar] setText:@""];
    [[[self contentView] resultsTable] reloadData];
}


// set the language direction based off of the index of the segmented control
- (void) updateLanguageDirection
{
    [self setDirection:[[[self contentView] languageDirectionSelection] selectedSegmentIndex]];
}

- (void) loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    SearchView* searchView = [[[SearchView alloc] initWithFrame:screen] autorelease];
    [self setView:searchView];
}

#pragma mark UIViewController Methods
- (void) viewDidLoad
{
    SearchView* searchView = [self contentView];
    // Set the label to the random work of the day
    [[searchView randomWordLabel] setText:[self randomWord]];
    
    // Make this view controller the delegate for the search bar.
    [[searchView searchBar] setDelegate:self];
    
    // Associate a method with the segmented control
    [[searchView languageDirectionSelection] addTarget:self action:@selector(updateLanguageDirection) forControlEvents:UIControlEventValueChanged];
    [[searchView languageDirectionSelection] setSelectedSegmentIndex:ENG_SPA];
    
    // Set the delegate and data source for the table view.
    [[searchView resultsTable] setDelegate:self];
    [[searchView resultsTable] setDataSource:self];
}

- (void) viewDidUnload
{
}

#pragma mark UISearchBarDelegate methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    SearchView* searchView = [self contentView];
    [[searchView searchBar] setText:@""];
    [[searchView searchBar] resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Store the search term
    [self setSearchTerm:[[[self contentView] searchBar] text]];
    
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(searchController:searchFor:inDirection:)])
    {
        [[self delegate] searchController:self searchFor:[self searchTerm] inDirection:[self direction]];
    }
    
    // Hide the keyboard
    [[[self contentView] searchBar] resignFirstResponder];
}

#pragma mark UITableViewDelegate methods
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    WordController* wordController;
	// If the "Add word to dictionary" row is selected, go to that.
	if ([self searchTerm] != nil)
	{
        // New word
        if ([indexPath section] == 0)
        {
            DefinitionSet* definitionSet = [[[DefinitionSet alloc] init] autorelease];

            if ([self direction] == ENG_SPA)
            {
                [definitionSet setEnglish:[self searchTerm]];
                [definitionSet setSpanish:@""];
            }
            else 
            {
                [definitionSet setSpanish:[self searchTerm]];
                [definitionSet setEnglish:@""];
            }
            
            wordController = [[[WordController alloc] initWithDefinitionSet:definitionSet isNew:YES] autorelease];
        }
        else
        {
            DefinitionSet* definitionSet = [[self searchResults] objectAtIndex:[indexPath row]];
            wordController = [[[WordController alloc] initWithDefinitionSet:definitionSet isNew:[definitionSet newFromGoogle]]  autorelease];
        }
        
        [wordController setDelegate:self];
        [[self navigationController] pushViewController:wordController animated:TRUE];
	}

	[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
}

#pragma mark UITableViewDataSource methods
//Asks the data source for a cell to insert in a particular location of the table view. (required)
- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	
	UITableViewCell* cell;
	
	if ([indexPath section] == 0)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		if ([self searchTerm] != nil)
		{
			NSString* add = NSLocalizedString(@"Add", @"");
			NSString* toDictionary = NSLocalizedString(@"to dictionary", @"");
			NSString* label = [NSString stringWithFormat:@"%@ \"%@\" %@", add, [self searchTerm], toDictionary];
			[[cell textLabel] setText:label];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:[self fontSize]]];
		}
		else 
		{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
			[[cell textLabel] setText:NSLocalizedString(@"No search results", @"")];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:[self fontSize]]];
		}
	}
	else 
	{
		cell  = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		// Get the Definition Set
		DefinitionSet* defSet = [[self searchResults] objectAtIndex:[indexPath row]];
		
		NSString* label;
		
		if ([self direction] == ENG_SPA)
		{
			label = [NSString stringWithFormat:@"%@ = %@", defSet.english, defSet.spanish];
		}
		else 
		{
			label = [NSString stringWithFormat:@"%@ = %@", defSet.spanish, defSet.english];
		}
        
		
		[[cell textLabel] setText:label];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:[self fontSize]]];
		
        // Set an image for the definition set if there is one.
		if ([defSet imagePath] != nil)
		{
            UIImage* image = [UIImage imageWithContentsOfFile:[defSet imagePath]];
			[[cell imageView] setImage:image];
		}
        
	}
	
	return cell;
}

// Tells the data source to return the number of rows in a given section of a table view. (required)
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
	{
		return 1;
	}
	else if ([self searchResults] != nil)
	{
		//NSLog(@"searchResults count: %i", [[self searchResults] count]);
		return [[self searchResults] count];
	}
	else 
	{
		return 0;
	}
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
	return 2;
}

#pragma mark WordControllerDelegate methods
- (int) getNextDefinitionId
{
    int defId = -1;
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(getNextDefinitionId)])
    {
        defId = [[self delegate] getNextDefinitionId];
    }
    return defId;
}
- (void) wordController:(WordController*)wordController updateDefinitionSet:(DefinitionSet*)defSet
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(searchController:updateDefinitionSet:)])
    {
        [[self delegate] searchController:self updateDefinitionSet:defSet];
    }
    
    [[self navigationController] popViewControllerAnimated:TRUE];    
    [self clearTable];
}

- (void) wordController:(WordController *)wordController addDefinitionSet:(DefinitionSet*)defSet
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(searchController:addDefinitionSet:)])
    {
        [[self delegate] searchController:self addDefinitionSet:defSet];
    }
    
    [[self navigationController] popViewControllerAnimated:TRUE];
    [self clearTable];

    
}

- (NSArray*) wordController:(WordController *)wordController retrieveCategories:(BOOL)retrieve
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(searchController:retrieveCategories:)])
    {
        [[self delegate] searchController:self retrieveCategories:TRUE];
        return [self categories];
    }
    
    return nil;
}

- (int) wordController:(WordController*)wordController addCategory:(NSString*)category
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(searchController:addCategory:)])
    {
        return [[self delegate] searchController:self addCategory:category];
    }
    
    // No delegate
    return -1;
}

- (void) cancelUpdate
{
    [[self navigationController] popViewControllerAnimated:TRUE];    
    [self clearTable];
}

@end
