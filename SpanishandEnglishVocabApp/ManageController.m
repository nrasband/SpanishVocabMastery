//
//  ManageController.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/16/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "ManageController.h"

#pragma mark -
#pragma mark Private Interface
@interface ManageController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, DefinitionSetsControllerDelegate>
@end

#pragma mark -
@implementation ManageController

#pragma mark Constructors
- (id) init
{
    self = [super init];
	if (self == nil)
		return self;
    
    // Personalize view controller
    [self setTitle:NSLocalizedString(@"Manage", @"")];
    
    // Set image for tab bar item
    [[self tabBarItem] setImage:[UIImage imageNamed:@"manage.png"]];
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

#pragma mark -
#pragma mark Methods
- (void) loadView
{
    // Create the primary view
    CGRect screen = [[UIScreen mainScreen] bounds];
    _manageView = [[[ManageView alloc] initWithFrame:screen] autorelease];
    [self setView:_manageView];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return TRUE;
}

- (void) setCategories:(NSArray*)categories
{
    [_categories autorelease];
    _categories = [categories retain];
}

#pragma mark UIViewController Methods
- (void) viewDidLoad
{    
    // Set this view controller as the delegate of the textfield
    [[_manageView textField] setDelegate:self];
    
    // Make this class handle the button presses
    [[_manageView button] addTarget:self action:@selector(addCategory) forControlEvents:UIControlEventTouchUpInside];
    
    // Need to initially get all categories.
    UITableView* tableView = [_manageView tableView];
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:requestAllCategories:)])
    {
        [[self delegate] manageController:self requestAllCategories:TRUE];
    }
    
    [tableView setDataSource:self];
    [tableView setDelegate:self];
}

- (void) viewDidUnload
{
    [_manageView release];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [[_manageView tableView] setEditing:editing animated:animated];
}

#pragma mark UITableViewDataSource implementation
// Asks the data source for a cell to insert in a particular location of the table view. (required)
- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	WordCategory* category = [_categories objectAtIndex:[indexPath row]];
	UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	[[cell textLabel] setText:[category categoryName]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

// Tells the data source to return the number of rows in a given section of a table view. (required)
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // There is only one section, so just return the count of _categories
	return [_categories count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    // Only one section in table
	return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	return NSLocalizedString(@"Tap a category to work with its definition sets.", @"");
}

#pragma mark UITableViewDelegate Overrides
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
	// Get the definition sets for this category
	if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:requestDefinitionSetsForCategory:)])
	{
		WordCategory* category = [_categories objectAtIndex:[indexPath row]];
		NSLog(@"Retrieving definition sets for category #%i", [category categoryID]);
        
		NSArray* definitionSets = [[self delegate] manageController:self requestDefinitionSetsForCategory:[category categoryID]];
        DefinitionSetsController* defSetController = [[[DefinitionSetsController alloc] initWithDefinitionSets:definitionSets category:[category categoryID]] autorelease];
        [defSetController setDelegate:self];
		[[self navigationController] pushViewController:defSetController animated:TRUE];
	}
	[[_manageView tableView] deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Don't allow editing if it is the default category.
    if ([indexPath row] == 0)
    {
        return UITableViewCellEditingStyleNone;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}


- (void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// The "unassigned" category cannot be deleted.
		if ([indexPath row] != 0)
		{
			if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:moveDefinitionSetsToUnassignedFromCategory:)])
			{
				WordCategory* category = [_categories objectAtIndex:[indexPath row]];
			 	[[self delegate] manageController:self moveDefinitionSetsToUnassignedFromCategory:[category categoryID]];
				[[_manageView tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
			}
		}
	}
}

// Add a category to the database
- (void) addCategory
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:addCategoryToDatabase:)])
    {
        // Get the text from the text field
        NSString* category = [[_manageView textField] text];
        [[self delegate] manageController:self addCategoryToDatabase:category];
    }
    
    UITextField* textField = [_manageView textField];
    [textField resignFirstResponder];
    [textField setText:@""];
    [[_manageView tableView] reloadData];
}

#pragma mark UITextFieldDelegate implementation
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark DefinitionSetsControllerDelegate methods
- (void) definitionSetsController:(DefinitionSetsController*)definitionSetsController deleteDefinitionSet:(int)defSetId
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:deleteDefinitionSet:)])
    {
        [[self delegate] manageController:self deleteDefinitionSet:defSetId];
    }
}


@end
