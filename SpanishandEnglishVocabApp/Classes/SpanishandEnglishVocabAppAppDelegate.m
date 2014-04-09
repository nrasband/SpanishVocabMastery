//
//  SpanishandEnglishVocabAppAppDelegate.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/15/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "SpanishandEnglishVocabAppAppDelegate.h"

@implementation SpanishandEnglishVocabAppAppDelegate

#pragma mark UIApplicationDelegate Methods
- (void) applicationDidFinishLaunching:(UIApplication*)application 
{   
    // Create window and make key
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window makeKeyAndVisible];
    
    // Get device orientation notifications
    //[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    _dictionary = [[DataModel alloc] init];
    NSString* randomWord = [_dictionary getRandomWord];
    
    _searcher = [[SearchController alloc] initWithRandomWord:randomWord];
    [_searcher setDelegate:self];
    
    _flasher = [[FlashCardController alloc] init];
    [_flasher setDelegate:self];
    
    _manager = [[ManageController alloc] init];
    [_manager setDelegate:self];
    
    _help = [[SpanishAppHelp alloc] init];
    
    _manageNavController = [[UINavigationController alloc] initWithRootViewController:_manager];
    _searchNavController = [[UINavigationController alloc] initWithRootViewController:_searcher];
    _flashNavController = [[UINavigationController alloc] initWithRootViewController:_flasher];
    
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController setViewControllers:[NSArray arrayWithObjects:_searchNavController, _flashNavController, _manageNavController, _help, nil]];
    [_tabBarController setSelectedViewController:_searchNavController];
    [_tabBarController setDelegate:self];
    [_window setRootViewController:_tabBarController];
}

- (void) applicationWillTerminate:(UIApplication*)application
{
    [_dictionary release];
    [_searcher release];
    [_flasher release];
    [_manager release];
    [_help release];
    [_manageNavController release];
    [_searchNavController release];
    [_flashNavController release];
    [_tabBarController release];
    [_window release];
    [super dealloc];
}

- (void) applicationWillResignActive:(UIApplication*)application
{
}

- (void) applicationDidEnterBackground:(UIApplication*)application
{
}

- (void) applicationWillEnterForeground:(UIApplication*)application
{
}

- (void) applicationDidBecomeActive:(UIApplication*)application
{
    
}

#pragma mark UITabBarControllerDelegate methods
- (BOOL)tabBarController:(UITabBarController *)aTabBar shouldSelectViewController:(UIViewController *)viewController
{
    // I do this to prevent a tab from being tapped to cause the viewcontroller to return to its root view controller when
    // tapped.
    if ([[aTabBar selectedViewController] isEqual:viewController])
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

#pragma mark ManageControllerDelegate implementation
- (int) getNextDefinitionId
{
    return [_dictionary lastDefSetIndex];
}

- (void) manageController:(ManageController*)manageController addCategoryToDatabase:(NSString*)categoryName
{
    // Add the new category to the dictionary
    [_dictionary addCategoryToDictionary:categoryName];
    
    // Update the categories in the ManageController
    [manageController setCategories:[_dictionary getCategoriesFromDictionary]];
}

- (void) manageController:(ManageController*)manageController requestAllCategories:(BOOL)all
{
    // Get all of the categories and upate that on the ManageController
    NSArray* categories = [_dictionary getCategoriesFromDictionary];
    [manageController setCategories:categories];
}

- (NSArray*) manageController:(ManageController*)manageController requestDefinitionSetsForCategory:(int)category
{
    // Get all of the definition sets for the current category
    NSArray* definitionSets = [_dictionary getDefinitionSetsFromCategory:category];
    return definitionSets;
}

// Move the definition sets under a particular category to the default category, and then delete the category
- (void) manageController:(ManageController*)manageController moveDefinitionSetsToUnassignedFromCategory:(int)category
{
    [_dictionary moveDefinitionSetsToDefaultCategoryFromCategory:category];
    [_dictionary deleteCategory:category];
    [manageController setCategories:[_dictionary getCategoriesFromDictionary]]; // Update the list of active categories.
}

// Delete the specified definition set from the dictionary
- (void) manageController:(ManageController*)manageController deleteDefinitionSet:(int)defSetId
{
    [_dictionary deleteDefinitionSet:defSetId];
}

// Add a new definition set to the dictionary
- (void) manageController:(ManageController*)manageController addDefinitionSet:(DefinitionSet*)defSet updateDefinitionSets:(BOOL)update
{
    [_dictionary addDefinitionSetToDictionary:defSet];
    
    if (update)
    {
        DefinitionSet* definitionSet = [_dictionary getDefinitionSetFromDictionary:[_dictionary lastDefSetIndex]];
        [manageController setDefinitionSet:definitionSet];
    }
}

// Update an existing definition set in the dictionary
- (void) manageController:(ManageController*)manageController updateDefinitionSet:(DefinitionSet*)defSet
{
    [_dictionary updateDefinitionSetInDictionary:defSet];
}

// Add a category to the dictionary and return the result.
- (int) manageController:(ManageController*)manageController addCategory:(NSString*)category
{
    int categoryID = [_dictionary addCategoryToDictionary:category];
    
    // Update the categories in the ManageController
    [manageController setCategories:[_dictionary getCategoriesFromDictionary]];
    
    return categoryID;
}

- (void) manageController:(ManageController*)manageController renameCategory:(WordCategory*)category toName:(NSString*)catName
{
    [_dictionary updateCategoryNameTo:catName withCategoryID:[category categoryID]];
    [manageController setCategories:[_dictionary getCategoriesFromDictionary]];
}

#pragma mark UISearchBarDelegate methods
- (void) searchController:(SearchController*)searchController searchFor:(NSString*)searchTerm inDirection:(int)direction
{
    NSArray* searchResults = [_dictionary searchFor:searchTerm inDirection:direction];
    [searchController setSearchResults:searchResults];
}

- (void) searchController:(SearchController *)searchController updateDefinitionSet:(DefinitionSet*)defSet
{
    [_dictionary updateDefinitionSetInDictionary:defSet];
}

- (void) searchController:(SearchController *)searchController addDefinitionSet:(DefinitionSet*)defSet
{
    [_dictionary addDefinitionSetToDictionary:defSet];
}

- (void) searchController:(SearchController *)searchController retrieveCategories:(BOOL)retrieve
{
    [searchController setCategories:[_dictionary getCategoriesFromDictionary]];
}

- (int) searchController:(SearchController *)searchController addCategory:(NSString*)category
{
    return [_dictionary addCategoryToDictionary:category];
}

#pragma mark FlashCardControllerDelegate methods
- (void) flashCardController:(FlashCardController*)flashCardController getDefinitionSetsForCategory:(WordCategory*)wordCategory
{
    NSArray* defSets = [_dictionary getDefinitionSetsFromCategory:[wordCategory categoryID]];
    [flashCardController setDefinitionSets:defSets];
}

- (void) flashCardController:(FlashCardController *)flashCardController requestAllCategories:(BOOL)request
{
    [flashCardController setCategories:[_dictionary getCategoriesFromDictionary]];
}

@end
