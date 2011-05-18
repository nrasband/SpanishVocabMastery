//
//  DefinitionSetsController.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/17/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "DefinitionSetsController.h"

#pragma mark -
#pragma mark Private Interface
@interface DefinitionSetsController ()<UITableViewDelegate, UITableViewDataSource, WordControllerDelegate>
@end

#pragma mark -
@implementation DefinitionSetsController

#pragma mark Constructors
- (id) init
{
    self = [super init];
	if (self == nil)
		return self;
	
    return self;
}

- (id) initWithDefinitionSets:(NSArray*)sets category:(int)catId
{
    self = [super init];
	if (self == nil)
		return self;
    
    [self setDefinitionSets:sets];
    [self setCategoryId:catId];
    
    // Personalize view controller
    [self setTitle:NSLocalizedString(@"Add/Update definitions", @"")];
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	
    return self;    
}

- (void) dealloc 
{
    [self setDelegate:nil];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
@synthesize categoryId = _categoryId;

- (void) setDefinitionSets:(NSArray*)defSets
{
    [_definitionSets autorelease];
    _definitionSets = [defSets retain];
}

#pragma mark -
#pragma mark Methods
- (void) addDefinition
{
    // Opens up the WordController and allows the user to create a brand new definition.
    DefinitionSet* defSet = [[[DefinitionSet alloc] init] autorelease];
    WordController* wordController = [[[WordController alloc] initWithDefinitionSet:defSet isNew:YES allowChangeCategory:NO] autorelease];
    [wordController setDelegate:self];
    [[self navigationController] pushViewController:wordController animated:TRUE];
}

// Returns a Boolean value indicating whether the view controller supports the specified orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) loadView
{
    // Set up the view for this ViewController
    CGRect screen = [[UIScreen mainScreen] bounds];
    _defSetView = [[[DefinitionSetsView alloc] initWithFrame:screen] autorelease];
    [self setView:_defSetView];
}

#pragma mark UIViewController Methods
- (void) viewDidLoad
{
    // Make this class handle the button presses
    [[_defSetView button] addTarget:self action:@selector(addDefinition) forControlEvents:UIControlEventTouchUpInside];
    
    // Need to initially get all categories.
    UITableView* tableView = [_defSetView tableView];
    [tableView setDataSource:self];
    [tableView setDelegate:self];

}

- (void) viewDidUnload
{
}

#pragma mark UITableViewDataSource Methods
// Asks the data source for a cell to insert in a particular location of the table view. (required)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve the definition set that needs to be associated with this cell
    DefinitionSet* defSet = [_definitionSets objectAtIndex:[indexPath row]];
    
    // Create a cell to represent this definition set
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    // Show english = (article) spanish (part of speech)
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ = %@ %@ (%@)", [defSet english], [defSet article], [defSet spanish], [defSet partOfSpeech]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
    return cell;
    
}

// Tells the data source to return the number of rows in a given section of a table view. (required)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_definitionSets count];
}

// Asks the data source for the title of the header of the specified section of the table view.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Tap a definition to update", @"");
}

// Asks the data source to verify that the given row is editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}

// Asks the data source to commit the insertion or deletion of a specified row in the receiver.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [indexPath row];
    DefinitionSet* defSet = [_definitionSets objectAtIndex:index];
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(definitionSetsController:deleteDefinitionSet:)])
        {
            // Send message to the delegate to update the dictionary
            [[self delegate] definitionSetsController:self deleteDefinitionSet:[defSet definitionID]];
            
            // Remove the definition set from the array
            [_definitionSets removeObjectAtIndex:index];
            [[_defSetView tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
	}
}

#pragma mark UITableViewDelegate methods
// Tells the delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // When a particular row is selected, I load the wordController to allow the user to modify the definition set
    DefinitionSet* defSet = [_definitionSets objectAtIndex:[indexPath row]];
    
    // Opens up the WordController and allows the definition to be edited.
    WordController* wordController = [[[WordController alloc] initWithDefinitionSet:defSet isNew:NO allowChangeCategory:NO] autorelease];
    [wordController setDelegate:self];
    [[self navigationController] pushViewController:wordController animated:TRUE];
    
    [[_defSetView tableView] deselectRowAtIndexPath:indexPath animated:TRUE];
}

//
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

@end
