//
//  DataModel.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/15/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "DefinitionSet.h"
#import "WordCategory.h"
#import <sqlite3.h>

#define ENG_SPA 0 
#define SPA_ENG 1 

@interface DataModel : NSObject 
{
	// Name of the database
	NSString* _databaseName;
	
	// Path to the database
	NSString* _databasePath;
	
	sqlite3* _database;
	
	int _lastDefSetIndex;
	int _lastCategoryIndex;
    
}

// Properties
- (sqlite3*) database;

@property (assign) int lastDefSetIndex; // CHECK
@property (assign) int lastCategoryIndex; // CHECK

// Methods

// Retrieves a random word from the database. Used to display a 
// random word to the user on the search page.
- (NSString*) getRandomWord;

// When a word is typed into the search bar, this method is called
// to find all relevant results from the SQL database. All results
// are returned as members of an array.
- (NSArray*) searchFor:(NSString*)searchTerm inDirection:(int)direction;

// This method is used to add new vocabulary to the SQL database.
- (void) addDefinitionSetToDictionary:(DefinitionSet*)definition;

// Update a definition set in the dictionary
- (void) updateDefinitionSetInDictionary:(DefinitionSet*)defSet;

// Retrieve a definition set from the dictionary
- (DefinitionSet*) getDefinitionSetFromDictionary:(int)defId;

// Retrieve all of the definition sets associated with a particular category
- (NSArray*) getDefinitionSetsFromCategory:(int)catID;

// Delete a definition set
- (void) deleteDefinitionSet:(int)defID;

// Assigns a definition set to the default category
- (void) moveDefinitionSetsToDefaultCategoryFromCategory:(int)catID; // CHECK

// Adds a category to the dictionary and returns its id.
- (int) addCategoryToDictionary:(NSString*)category;

// Updates the name of a given category
- (void) updateCategoryNameTo:(NSString*)name withCategoryID:(int)categoryID;

// Deletes a category from the dictionary
- (void) deleteCategory:(int)catID;

// Retrieves all categories from the dictionary
- (NSArray*) getCategoriesFromDictionary;

// Returns the id associated with a category.
- (int) idForCategory:(NSString*)category;

@end
