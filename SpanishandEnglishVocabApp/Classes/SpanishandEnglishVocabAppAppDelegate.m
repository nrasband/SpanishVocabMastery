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
    
    _dictionary = [[DataModel alloc] init];
    //NSString* randomWord = [_dictionary getRandomWord];
    
    _manager = [[[ManageController alloc] init] autorelease];
    [_manager setDelegate:self];
    
    _help = [[[SpanishAppHelp alloc] init] autorelease];
    
    _manageNavController = [[[UINavigationController alloc] initWithRootViewController:_manager] autorelease];
    
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController setViewControllers:[NSArray arrayWithObjects:_manageNavController, _help, nil]];
    [_tabBarController setSelectedViewController:_manageNavController];
    [_window addSubview:[_tabBarController view]];
}

- (void) applicationWillTerminate:(UIApplication*)application
{
    [_dictionary release];
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

#pragma mark UITabBarDelegate implementation
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [tabBarController setSelectedViewController:viewController];
}

#pragma mark ManageControllerDelegate implementation

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

@end
