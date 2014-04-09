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
    [_definitionSet release];
    [_categories release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
@synthesize definitionSet = _definitionSet;
@synthesize fontSize = _fontSize;

- (void) setCategories:(NSArray*)categories
{
    [_categories autorelease];
    _categories = [categories retain];
}

- (ManageView*) contentView
{
    return (ManageView*)[self view];
}

#pragma mark -
#pragma mark Methods
- (void) loadView
{
    // Create the primary view
    CGRect screen = [[UIScreen mainScreen] bounds];
    ManageView* manageView = [[[ManageView alloc] initWithFrame:screen] autorelease];
    [self setView:manageView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:FALSE];
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:requestAllCategories:)])
    {
        [[self delegate] manageController:self requestAllCategories:TRUE];
    }
    
    [[[self contentView] tableView] reloadData];
}



#pragma mark UIViewController Methods
- (void) viewDidLoad
{    
    // Set this view controller as the delegate of the textfield
    [[[self contentView] textField] setDelegate:self];
    
    // Need to initially get all categories.
    UITableView* tableView = [[self contentView] tableView];
//    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:requestAllCategories:)])
//    {
//        [[self delegate] manageController:self requestAllCategories:TRUE];
//    }
    
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    //[[[self contentView] tableView] reloadData];
}

- (void) viewDidUnload
{

}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [[[self contentView] tableView] setEditing:editing animated:animated];
}

#pragma mark UITableViewDataSource implementation
// Asks the data source for a cell to insert in a particular location of the table view. (required)
- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	WordCategory* category = [_categories objectAtIndex:[indexPath row]];
	UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	[[cell textLabel] setText:[category categoryName]];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:[self fontSize]]];
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
		//NSLog(@"Retrieving definition sets for category #%i", [category categoryID]);
        
		NSArray* definitionSets = [[self delegate] manageController:self requestDefinitionSetsForCategory:[category categoryID]];
        DefinitionSetsController* defSetController = [[[DefinitionSetsController alloc] initWithDefinitionSets:definitionSets category:category] autorelease];
        [defSetController setDelegate:self];
		[[self navigationController] pushViewController:defSetController animated:TRUE];
	}
	[[[self contentView] tableView] deselectRowAtIndexPath:indexPath animated:TRUE];
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
                [tableView reloadData];
			}
		}
	}
}

// Add a category to the database
- (void) addCategory
{
    UITextField* textField = [[self contentView] textField];
    
    if ([textField text] != nil && [[textField text] length] > 0)
    {
        if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:addCategoryToDatabase:)])
        {
            // Get the text from the text field
            NSString* category = [[[self contentView] textField] text];
            if (category != nil && [category length] != 0)
            {
                [[self delegate] manageController:self addCategoryToDatabase:category];
                UITextField* textField = [[self contentView] textField];
                [textField resignFirstResponder];
                [textField setText:@""];
                [[[self contentView] tableView] reloadData];
            }
        }
    }
}

#pragma mark UITextFieldDelegate implementation
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self addCategory];
    [textField resignFirstResponder];
    [textField setText:NSLocalizedString(@"Add category", @"")];
    return NO;
}

#pragma mark DefinitionSetsControllerDelegate methods
- (int) getNextDefinitionId
{
    int defId = -1;
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(getNextDefinitionId)])
    {
        defId = [[self delegate] getNextDefinitionId];
    }
    return defId;
}

- (void) definitionSetsController:(DefinitionSetsController*)definitionSetsController deleteDefinitionSet:(int)defSetId
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:deleteDefinitionSet:)])
    {
        [[self delegate] manageController:self deleteDefinitionSet:defSetId];
    }
}

// Add a new definition set to the dictionary
- (void) definitionSetsController:(DefinitionSetsController *)definitionSetsController addDefinitionSet:(DefinitionSet*)defSet updateDefinitionSets:(BOOL)update
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:addDefinitionSet:updateDefinitionSets:)])
    {
        [[self delegate] manageController:self addDefinitionSet:defSet updateDefinitionSets:update];
        if (update)
        {
            [definitionSetsController addDefinitionSetToDefinitionSets:[self definitionSet]];
        }
    }
}

// Update an existing definition set in the dictionary
- (void) definitionSetsController:(DefinitionSetsController *)definitionSetsController updateDefinitionSet:(DefinitionSet*)defSet
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:updateDefinitionSet:)])
    {
        [[self delegate] manageController:self updateDefinitionSet:defSet];
    }
}

- (NSArray*) definitionSetsController:(DefinitionSetsController *)definitionSetsController retrieveCategories:(BOOL)retrieve
{
    return _categories;
}

- (int) definitionSetsController:(DefinitionSetsController*)definitionSetsController addCategory:(NSString*)category
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:addCategory:)])
    {
        int categoryID = [[self delegate] manageController:self addCategory:category];
        if (categoryID != -1)
        {
            [[[self contentView] tableView] reloadData];
        }
        return categoryID;
    }
    
    // No delegate
    return -1;
}

- (void) definitionSetsController:(DefinitionSetsController*)definitionSetsController renameCategory:(WordCategory*)category toName:(NSString*)catName
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(manageController:renameCategory:toName:)])
    {
        [[self delegate] manageController:self renameCategory:category toName:catName];
    }
}

@end
