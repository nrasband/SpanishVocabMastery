//
//  FlashCardController.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/21/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "FlashCardController.h"

#pragma mark -
#pragma mark Private Interface
@interface FlashCardController ()<UITableViewDelegate, UITableViewDataSource>

- (void) changePictureLocation;

@end

#pragma mark -
@implementation FlashCardController

#pragma mark Constructors
- (id) init
{
    self = [super init];
	if (self == nil)
		return self;
    
    [self setTitle:NSLocalizedString(@"Flash cards", @"")];
    [[self tabBarItem] setImage:[UIImage imageNamed:@"flash.png"]];
    
    [self setDirection:0];
    
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
    [_categories release];
    [_definitionSets release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
@synthesize direction = _direction;
@synthesize pictureLocation = _pictureLocation;
@synthesize categories = _categories;
@synthesize definitionSets = _definitionSets;
@synthesize fontSize = _fontSize;

- (FlashCardStartView*) contentView
{
    return (FlashCardStartView*)[self view];
}

#pragma mark -
#pragma mark Methods
- (void) changeDirection
{
    UISegmentedControl* direction = [[self contentView] direction];
    [self setDirection:[direction selectedSegmentIndex]];
}

- (void) changePictureLocation
{
    [self setPictureLocation:[[[self contentView] pictureLocation] selectedSegmentIndex]];
}



- (void) loadView
{
    FlashCardStartView* startView = [[[FlashCardStartView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self setView:startView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:FALSE];
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(flashCardController:requestAllCategories:)])
    {
        [[self delegate] flashCardController:self requestAllCategories:TRUE];
    }
    
    [[[self contentView] tableView] reloadData];
}

#pragma mark UIViewController Methods
- (void) viewDidLoad
{
    FlashCardStartView* startView = [self contentView];
    UISegmentedControl* direction = [startView direction];
    [direction addTarget:self action:@selector(changeDirection) forControlEvents:UIControlEventValueChanged];
    [direction setSelectedSegmentIndex:0];
    
    UISegmentedControl* pictureLocation = [startView pictureLocation];
    [pictureLocation addTarget:self action:@selector(changePictureLocation) forControlEvents:UIControlEventValueChanged];
    [pictureLocation setSelectedSegmentIndex:2];

    UITableView* tableView = [startView tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
}

- (void) viewDidUnload
{
}

#pragma mark UITableViewDataSource methods
// Asks the data source for a cell to insert in a particular location of the table view. (required)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:[self fontSize]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    WordCategory* category = (WordCategory*)[[self categories] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[category categoryName]];
    
    return cell;
}

// Asks the data source to return the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Tells the data source to return the number of rows in a given section of a table view. (required)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self categories] count];
}

// Asks the data source for the title of the header of the specified section of the table view.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Tap a category to begin", @"");
}

#pragma mark UITableViewDelegate methods
// Tells the delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This is where we start the flash cards.

    // Get the definition sets for the selected category
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(flashCardController:getDefinitionSetsForCategory:)])
    {
        WordCategory* category = (WordCategory*)[[self categories] objectAtIndex:[indexPath row]];
        [[self delegate] flashCardController:self getDefinitionSetsForCategory:category];
        
        if ([[self definitionSets] count] > 0)
        {
            // Create the FlashCardCardController and push it onto the navigationController stack
            FlashCardCardController* flashCCController = [[[FlashCardCardController alloc] initWithDefinitionSets:[self definitionSets] andDirection:[self direction] andPictureLocation:[self pictureLocation] showEngExample:[[[self contentView] englishExampleSwitch] isOn] showSpanExample:[[[self contentView] spanishExampleSwitch] isOn] andCategoryName:[category categoryName]] autorelease];
            
            [[self navigationController] pushViewController:flashCCController animated:TRUE];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}


@end
