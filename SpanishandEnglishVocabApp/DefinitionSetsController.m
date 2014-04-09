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
@interface DefinitionSetsController ()<UITableViewDelegate, UITableViewDataSource, WordControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
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

- (id) initWithDefinitionSets:(NSArray*)sets category:(WordCategory*)category
{
    self = [super init];
	if (self == nil)
		return self;
    
    [self setDefinitionSets:sets];
    [self setCategory:category];
    
    // Personalize view controller
    [self setTitle:NSLocalizedString(@"Definitions", @"")];
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
    [_category release];
    [_definitionSets release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
@synthesize category = _category;
@synthesize indexOfDefinitionSetBeingModified = _indexOfDefinitionSetBeingModified;
@synthesize fontSize = _fontSize;

- (DefinitionSetsView*) contentView
{
    return (DefinitionSetsView*)[self view];
}

- (void) setDefinitionSets:(NSArray*)defSets
{
    [_definitionSets autorelease];
    _definitionSets = (NSMutableArray*)[defSets retain];
}

#pragma mark -
#pragma mark Methods
- (void) renameCategory
{
    UITextField* categoryTextField = [[self contentView] categoryTextField];
    if ([categoryTextField text] != nil && [[categoryTextField text] length] > 0)
    {
        if ([[[self category] categoryName] isEqualToString:@"default"])
        {
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"The default category cannot be modified.", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] autorelease];
            [alert show];
            [categoryTextField setText:NSLocalizedString(@"Cannot rename default category", @"")];
        }
        else
        {
            if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(definitionSetsController:renameCategory:toName:)])
            {
                [[self delegate] definitionSetsController:self renameCategory:[self category] toName:[categoryTextField text]];
                
                // Update categoryName
                [[self category] setCategoryName:[categoryTextField text]];
                
                // Clear out field
                [categoryTextField setText:@""];                
                
                // Set placeholder text
                [categoryTextField setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Rename category", @""), [[self category] categoryName]]];
                
                // Display success
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"") message:NSLocalizedString(@"The category name was successfully changed.", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] autorelease];
                [alert show];
            }
        }
    }
}

- (void) addDefinition
{
    // Opens up the WordController and allows the user to create a brand new definition.
    DefinitionSet* defSet = [[[DefinitionSet alloc] init] autorelease];
    
    // Make sure this definition knows to which category it belongs.
    [defSet setCategoryID:[[self category] categoryID]];
    WordController* wordController = [[[WordController alloc] initWithDefinitionSet:defSet isNew:YES] autorelease];
    [wordController setDelegate:self];
    [[self navigationController] pushViewController:wordController animated:TRUE];
}

- (void) addDefinitionSetToDefinitionSets:(DefinitionSet*)defSet
{
    [_definitionSets addObject:defSet];
}



- (void) loadView
{
    // Set up the view for this ViewController
    CGRect screen = [[UIScreen mainScreen] bounds];
    DefinitionSetsView* defSetView = [[[DefinitionSetsView alloc] initWithFrame:screen] autorelease];
    [self setView:defSetView];
}

#pragma mark UIViewController Methods
- (void) viewDidLoad
{
    UITextField* categoryText = [[self contentView] categoryTextField];
    
    if ([[[self category] categoryName] isEqualToString:@"default"])
    {
        [categoryText setText:NSLocalizedString(@"Cannot rename default category", @"")];
        [categoryText setEnabled:FALSE];
    }
    else
    {
        [categoryText setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Rename category", @""), [[self category] categoryName]]];
        [categoryText setDelegate:self];
    }
    
    // Make this class handle the button presses
    [[[self contentView] button] addTarget:self action:@selector(addDefinition) forControlEvents:UIControlEventTouchUpInside];
    
    // Need to initially get all categories.
    UITableView* tableView = [[self contentView] tableView];
    [tableView setDataSource:self];
    [tableView setDelegate:self];

}

- (void) viewDidUnload
{

}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [[[self contentView] tableView] setEditing:editing animated:animated];
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
    [[cell textLabel]  setFont:[UIFont systemFontOfSize:[self fontSize]]];
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
            // Make sure to delete the associated image, if there is one.
            NSString* imagePath = [defSet imagePath];
            if (imagePath != nil && [imagePath length] > 0)
            {
                NSError* error = nil;
                NSFileManager* fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:imagePath error:&error];
                
                if (error != nil)
                {
                    NSLog(@"Error deleting image: %@", error);
                }
            }
            // Send message to the delegate to update the dictionary
            [[self delegate] definitionSetsController:self deleteDefinitionSet:[defSet definitionID]];
            
            // Remove the definition set from the array
            [_definitionSets removeObjectAtIndex:index];
            [[[self contentView] tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
	}
}

#pragma mark UITableViewDelegate methods
// Tells the delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // When a particular row is selected, I load the wordController to allow the user to modify the definition set
    DefinitionSet* defSet = [_definitionSets objectAtIndex:[indexPath row]];
    [self setIndexOfDefinitionSetBeingModified:[indexPath row]];
    
    // Opens up the WordController and allows the definition to be edited.
    WordController* wordController = [[[WordController alloc] initWithDefinitionSet:defSet isNew:NO] autorelease];
    [wordController setDelegate:self];
    [[self navigationController] pushViewController:wordController animated:TRUE];
    
    [[[self contentView] tableView] deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
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
    // Remove the old one
    [_definitionSets removeObjectAtIndex:[self indexOfDefinitionSetBeingModified]];
    
    // Add the new one
    if ([defSet categoryID] == [[self category] categoryID])
    {
        [_definitionSets addObject:defSet];
    }
    
    // Notify the delegate to update in the database
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(definitionSetsController:updateDefinitionSet:)])
    {
        [[self delegate] definitionSetsController:self updateDefinitionSet:defSet];
    }
    [[self navigationController] popViewControllerAnimated:TRUE];
    [[[self contentView] tableView] reloadData];
    
}

- (void) wordController:(WordController *)wordController addDefinitionSet:(DefinitionSet*)defSet
{    
    // Notify my delegate so that the dictionary will be updated.
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(definitionSetsController:addDefinitionSet:updateDefinitionSets:)])
    {
        BOOL update = [defSet categoryID] == [[self category] categoryID] ? YES : NO;
        [[self delegate] definitionSetsController:self addDefinitionSet:defSet updateDefinitionSets:update];
    }
    [[self navigationController] popViewControllerAnimated:TRUE];
    [[[self contentView] tableView] reloadData];
}

- (NSArray*) wordController:(WordController *)wordController retrieveCategories:(BOOL)retrieve
{
    NSArray* categories = nil;
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(definitionSetsController:retrieveCategories:)])
    {
        categories = [[self delegate] definitionSetsController:self retrieveCategories:TRUE];
    }
    
    return categories;
}

- (int) wordController:(WordController*)wordController addCategory:(NSString*)category
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(definitionSetsController:addCategory:)])
    {
        return [[self delegate] definitionSetsController:self addCategory:category];
    }
    // If no delegate, return -1.
    return -1;
}

- (void) cancelUpdate
{
    [[self navigationController] popViewControllerAnimated:TRUE];
    [[[self contentView] tableView] reloadData];
}

#pragma mark UITextFieldDelegate implementation
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self renameCategory];
    [textField resignFirstResponder];
    UITextField* categoryText = [[self contentView] categoryTextField];
    [categoryText setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Rename category", @""), [[self category] categoryName]]];
    return NO;
}

#pragma mark UIAlertViewDelegate methods
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    
//}

@end
