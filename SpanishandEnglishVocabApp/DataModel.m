//
//  DataModel.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/15/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "DataModel.h"

#pragma mark -
#pragma mark Private Interface
@interface DataModel ()

// Checks to see if the database has already been copied over to the documents
// folder. If not, it copies it. It returns a boolean indicating whether or not the
// database was just created.
-(void) createDatabase;

// Opens the sqlite database. Returns TRUE if successful and FALSE otherwise
-(BOOL) openDatabase;

// Closes the sqlite database
-(void) closeDatabase;

// Prepare a sqlite3 statement
-(sqlite3_stmt*) prepareStatement:(NSString*)statement;

// Create a definition set from a row of data
- (void) createDefinitionSetFromRow:(DefinitionSet*)defSet statement:(sqlite3_stmt*)statement;

// Checks to see if the category is already in the dictionary
- (BOOL) categoryAlreadyInDictionary:(NSString*)word;

// Parses the json string returned by the Google Translation API to extract the definition
- (NSString*) parseTranslation:(NSString*)str;

// Looks up the word with the Google translation API and returns the a definition set if a translation was found
- (DefinitionSet*) lookupWordWithGoogleAPI:(NSString*)wordToTranslate inDirection:(int)direction;

@end

#pragma mark -
@implementation DataModel

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
	
	_databaseName = @"SpanEngDict.sqlite";
	
	// Get the path to the documents directory and append the databaseName
	// We are referencing the user's Documents directory on the iPhone. The "YES" expands out the full file name where ~'s are found.
	NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	// Get the first (and only) result.
	NSString* documentsDirectory = [documentPaths objectAtIndex:0];
	
	// Append the database name to the path to get the full path to the database.
	_databasePath = [documentsDirectory stringByAppendingPathComponent:_databaseName];
	
	// Create the database
	[self createDatabase];
	
	BOOL openResult = [self openDatabase];
	if (openResult == FALSE)
    {
		NSLog(@"Could not open database!");
    }
    else
    {
        // Find out what the max id is for definition sets.
        NSString* tempStatement = [NSString stringWithFormat:@"SELECT MAX(definition_id) FROM definition_set;"];
        
        sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
        if (sqlStatement != 0) {
            
            if (sqlite3_step(sqlStatement) == SQLITE_ROW) 
            {
                int storedInt = sqlite3_column_int(sqlStatement, 0);
                [self setLastDefSetIndex:storedInt];
            }
        }
        else 
        {
            NSLog(@"Problem with sql statement when searching for lastIndex");
        }
        
        sqlite3_finalize(sqlStatement);
        
        // Find out what the max id is for categories.
        tempStatement = [NSString stringWithFormat:@"SELECT MAX(category_id) FROM categories;"];
        
        sqlStatement = [self prepareStatement:tempStatement];
        if (sqlStatement != 0) {
            
            if (sqlite3_step(sqlStatement) == SQLITE_ROW) 
            {
                [self setLastCategoryIndex:sqlite3_column_int(sqlStatement, 0)];
            }
            else 
            {
                [self setLastCategoryIndex:DEFAULT];
            }
            
            
        }
        else 
        {
            NSLog(@"Problem with sql statement when searching for lastIndex");
        }
        
        sqlite3_finalize(sqlStatement);
    }

    return self;
}

- (void) dealloc
{
	[self closeDatabase];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
- (sqlite3*) database
{
	return _database;
}

@synthesize lastDefSetIndex = _lastDefSetIndex;
@synthesize lastCategoryIndex = _lastCategoryIndex;

#pragma mark Private Methods
-(void) createDatabase
{
	// Check if the SQL database has already been saved to the user's phone, if not then copy it over
	BOOL success = FALSE;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the user's filesystem
	success = [fileManager fileExistsAtPath:_databasePath];
	
	// If the database already exists then return without doing anything
	if (success)
	{
		return;
	}
	
	// If not then proceed to copy the database from the application to the user's filesystem
	
	// Get the path to the database in the application package
	NSString* databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_databaseName];
    
    NSError* error = nil;
	
	// Copy the database from the package to the user's filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:_databasePath error:&error];
    
    if (error != nil)
    {
        NSLog(@"Error copying database to user's phone: %@", error);
    }
	
	[fileManager release];
}

-(BOOL) openDatabase
{
	int result = sqlite3_open([_databasePath UTF8String], &_database);
	if (SQLITE_OK != result)
	{
		NSLog(@"Unable to open the sqlite database %@.", [self database]);
		NSLog(@"Error message: %@", sqlite3_errmsg([self database]));
		return FALSE;
	}
	else 
    {
		return TRUE;
	}
    
}

-(void) closeDatabase
{
	// Make sure the database is not nil before trying to close it.
	if ([self database])
	{
		sqlite3_close([self database]);
	}
}

-(sqlite3_stmt*) prepareStatement:(NSString*)statement
{
	// Convert NSString to char* UTF8 string
	const char* tempStatement = [statement UTF8String];
	sqlite3_stmt* preparedStatement;
	
	// Prepares the statement for use by sqlite. The -1 means "read to the first zero terminator", and the NULL means we don't
	// care about the part that wasn't compiled.
	int resultOfPrepare = sqlite3_prepare_v2([self database], tempStatement, -1, &preparedStatement, NULL);
	
	if (resultOfPrepare == SQLITE_OK)
	{
		return preparedStatement;
	}
	else 
	{
		// If the prepared statement did not work, return 0.
		NSString* error = [NSString stringWithUTF8String:(char *)sqlite3_errmsg([self database])];
		NSLog(@"Error with prepare_v2: %@ ", error);
		return 0;
	}
    
}

- (void) createDefinitionSetFromRow:(DefinitionSet*)defSet statement:(sqlite3_stmt*)statement
{
    [defSet setDefinitionID:sqlite3_column_int(statement, 0)];
    [defSet setEnglish:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
    [defSet setSpanish:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
    [defSet setGender:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
    [defSet setSingularOrPlural:sqlite3_column_int(statement, 4)];
    [defSet setPartOfSpeech:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
    [defSet setAudioPath:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
    [defSet setImagePath:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
    [defSet setCategoryID:sqlite3_column_int(statement, 8)];
}

- (BOOL) categoryAlreadyInDictionary:(NSString*)word
{
	NSString* lowerCaseVersion = [word lowercaseString];
	NSString* tempStatement = [NSString stringWithFormat:@"SELECT * FROM categories WHERE category_name =  '%@';", lowerCaseVersion];
	
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0)
	{
		if (sqlite3_step(sqlStatement) == SQLITE_ROW)
		{
			return TRUE;
		}
		else 
		{
			return FALSE;
		}
		
		
	}
	else {
		NSLog(@"Could not prepare sequel statement.");
		return FALSE;
	}
	
	// Finalize the statement
	sqlite3_finalize(sqlStatement);	
}

- (NSString*) parseTranslation:(NSString*)str
{
    NSRange range = [str rangeOfString:@"\"translatedText\": \""];
    range.location = range.location + range.length;
    
    NSString* result = [str substringFromIndex:range.location];
    NSRange quoteRange = [result rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    quoteRange.length = quoteRange.location;
    quoteRange.location = 0;
    result = [result substringWithRange:quoteRange];
    return result;
}

- (DefinitionSet*) lookupWordWithGoogleAPI:(NSString*)wordToTranslate inDirection:(int)direction
{
    DefinitionSet* defSet = nil;
    
    NSString* source;
    NSString* target;
    NSString* english;
    NSString* spanish;
    
    if (direction == ENG_SPA)
    {
        source = @"en";
        target = @"es";
        english = wordToTranslate;
    }
    else
    {
        source = @"es";
        target = @"en";
        spanish = wordToTranslate;
    }
    
    // My google API key
    NSString* key = @"AIzaSyArIutfCuuPmrfeGxjqZ2iEAh8P6rg-Ml8";
    NSString* urlString = [NSString stringWithFormat:@"https://www.googleapis.com/language/translate/v2?key=%@&source=%@&target=%@&q=%@", key, source, target, wordToTranslate];
    
    // Create a URL for the resource and a request
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"]; // Google API uses GET verb
    
    NSURLResponse* response = NULL;
    NSError* error = NULL;
    
    // Connect synchronously to the Google API and request a translation
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check for errors
    if (error != NULL)
    {
        NSLog(@"Error with connection: %@", error);
    }
    else
    {
        // Turn the resulting data into an NSString
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"jsonString: %@", jsonString);
        NSString* translation = [self parseTranslation:jsonString];
        [jsonString release]; // Free the memory since we no longer need the json string
        //NSLog(@"Translation: %@", translation);
        
        // If a translation can't be found, the json just returns the original word that was searched for.
        if (![[translation lowercaseString] isEqualToString:[wordToTranslate lowercaseString]])
        {
            // Set the translated term (we set the search term above)
            if (direction == ENG_SPA)
            {
                spanish = translation;
            }
            else
            {
                english = translation;
            }
            
            // Create the definition set and return it.
            defSet = [[[DefinitionSet alloc] initWithEnglish:english spanish:spanish gender:@"N/A" singularOrPlural:NA partOfSpeech:@"" imagePath:@"" audioPath:@"" categoryID:DEFAULT] autorelease];
        }
    }
    return defSet;
}

#pragma mark -
#pragma mark Methods

- (NSString*) getRandomWord
{
	int randomValue = ([self lastDefSetIndex] == 0) ? 0 : arc4random() % [self lastDefSetIndex] + 1;
	NSMutableString* randomWord = [NSMutableString stringWithCapacity:13];
    [randomWord setString:NSLocalizedString(@"Random word: ", @"")];
	NSString* tempStatement = [NSString stringWithFormat:@"SELECT * FROM definition_set WHERE definition_id = %i;", randomValue];
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0)
	{
		// Go through all of the columns in the row and build the definition set
		DefinitionSet* defSet = [[[DefinitionSet alloc] init] autorelease];
		if (sqlite3_step(sqlStatement) == SQLITE_ROW)
		{
			[self createDefinitionSetFromRow:defSet statement:sqlStatement];
            
            [randomWord appendFormat:@"%@ = %@ %@ (%@)", [defSet english], [defSet article], [defSet spanish], NSLocalizedString([defSet partOfSpeech], @"")];
			
			NSLog(@"Random word retrieved from database: %@", defSet);
		}
		else 
		{
			NSLog(@"Random word not found");
            [randomWord setString:NSLocalizedString(@"Random word: (dictionary empty)", @"")];
		}
		
	}
	else 
    {
		NSLog(@"Could not retrieve definition set from dictionary");
	}
	
	// Finalize the statement
	sqlite3_finalize(sqlStatement);
	
	return randomWord;
}

- (NSArray*) searchFor:(NSString*)searchTerm inDirection:(int)direction
{
	NSLog(@"searchTerm in searchFor method: %@", searchTerm);
	NSMutableArray* resultsArray = [[[NSMutableArray alloc] init] autorelease];
	
	NSString* column;
	
	column = direction == ENG_SPA ? @"english" : @"spanish";
	
	NSString* scrubbedTerm = [searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	scrubbedTerm = [scrubbedTerm lowercaseString];
	NSString* tempStatement = [NSString stringWithFormat:@"SELECT * FROM definition_set WHERE %@ = '%@';", column, scrubbedTerm];
	
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0) {
        
		while (sqlite3_step(sqlStatement) == SQLITE_ROW) 
		{
			DefinitionSet* defSet = [[[DefinitionSet alloc] init] autorelease];
			[self createDefinitionSetFromRow:defSet statement:sqlStatement];
			[resultsArray addObject:defSet];
		}
        
	}
	else 
	{
		NSLog(@"Problem with sql statement on search");
	}
    
	sqlite3_finalize(sqlStatement);
    
    
    BOOL useGoogleAPI = TRUE;
    
    // Check to see if we need to lookup the word in the Google API
    if (useGoogleAPI && [resultsArray count] == 0)
    {
        DefinitionSet* defSet = [self lookupWordWithGoogleAPI:searchTerm inDirection:direction];
        if (defSet != nil)
        {
            [resultsArray addObject:defSet];
        }
    }
	
    return resultsArray;
    
}

// This method inserts a new definition_set into the database
// The definition_set table is structured as follows:
// - definition_id int auto_increment not null
// - english TEXT NOT NULL,
// - spanish TEXT NOT NULL,
// - gender TEXT,
// - singularOrPlural int,
// - partOfSpeech TEXT,
// - audioPath TEXT,
// - imagePath TEXT,
// - category INT (foreign key)

- (void) addDefinitionSetToDictionary:(DefinitionSet*)definition
{
	if (definition.english != nil && definition.spanish != nil)
	{
		NSString* tempStatement = [NSString stringWithFormat:@"INSERT INTO definition_set VALUES (%i,'%@', '%@', '%@', %i, '%@', '', '', %i);", [self lastDefSetIndex] + 1, definition.english, definition.spanish, definition.gender, definition.singularOrPlural, definition.partOfSpeech, definition.categoryID];
		
		// increment lastDefSetIndex
		[self setLastDefSetIndex:[self lastDefSetIndex] + 1];
		
		sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
		if (sqlStatement != 0)
		{
			int result = sqlite3_step(sqlStatement);
			if (result != SQLITE_DONE)
			{
				NSLog(@"Error with inserting definition into dictionary");
			}
			else 
			{
				NSLog(@"Successfully added definition set to dictionary");
			}
            
		}
		else 
		{
			NSLog(@"Could not convert %@ into sql statement", tempStatement);
		}
		
		// Finalize the statement
		sqlite3_finalize(sqlStatement);
	}
    
}

- (DefinitionSet*) getDefinitionSetFromDictionary:(int)defId
{
	NSString* tempStatement = [NSString stringWithFormat:@"SELECT * FROM definition_set WHERE definition_id = %i;", defId];
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0)
	{
		// Go through all of the columns in the row and build the definition set
		DefinitionSet* defSet = [[[DefinitionSet alloc] init] autorelease];
		if (sqlite3_step(sqlStatement) == SQLITE_ROW)
		{
			[self createDefinitionSetFromRow:defSet statement:sqlStatement];
			
			NSLog(@"DefintionSet retrieved from database: %@", defSet);
			// Finalize the statement
			sqlite3_finalize(sqlStatement);
			return defSet;
		}
		else 
		{
			NSLog(@"Definition set not found");
		}
        
		
	}
	else {
		NSLog(@"Could not retrieve definition set from dictionary");
	}
	
	// Finalize the statement
	sqlite3_finalize(sqlStatement);
	
	return nil;
    
}

- (void) moveDefinitionSetsToDefaultCategoryFromCategory:(int)catID
{
	NSString* tempStatement = [NSString stringWithFormat:@"UPDATE definition_set SET category_id = 0 WHERE category_id = %i;", catID];
	
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0)
	{
		int result = sqlite3_step(sqlStatement);
		if (result != SQLITE_DONE)
		{
			NSLog(@"Error updating to unassigned category into dictionary");
		}
		else 
		{
			NSLog(@"Successfully updated to unassigned category in dictionary");
		}
		
	}
	else 
	{
		NSLog(@"Could not convert %@ into sql statement", tempStatement);
	}
	
	// Finalize the statement
	sqlite3_finalize(sqlStatement);
}

- (void) deleteCategory:(int)catID
{
	NSString* tempStatement = [NSString stringWithFormat:@"DELETE FROM categories WHERE category_id = %i;", catID];
	
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0)
	{
		int result = sqlite3_step(sqlStatement);
		if (result != SQLITE_DONE)
		{
			NSLog(@"Error deleting category from dictionary");
		}
		else 
		{
			NSLog(@"Category successfully deleted from dictionary");
		}
		
	}
	else 
	{
		NSLog(@"Could not convert %@ into sql statement", tempStatement);
	}
	
	// Finalize the statement
	sqlite3_finalize(sqlStatement);
}

- (void) deleteDefinitionSet:(int)defID
{
	NSString* tempStatement = [NSString stringWithFormat:@"DELETE FROM definition_set WHERE definition_id = %i;", defID];
	
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0)
	{
		int result = sqlite3_step(sqlStatement);
		if (result != SQLITE_DONE)
		{
			NSLog(@"Error deleting definition set from dictionary");
		}
		else 
		{
			NSLog(@"Definition set successfully deleted from dictionary");
		}
		
	}
	else 
	{
		NSLog(@"Could not convert %@ into sql statement", tempStatement);
	}
	
	// Finalize the statement
	sqlite3_finalize(sqlStatement);
}

- (NSArray*) getDefinitionSetsFromCategory:(int)catID
{
	NSMutableArray* resultsArray = [[[NSMutableArray alloc] init] autorelease];
	
	NSString* tempStatement = [NSString stringWithFormat:@"SELECT * FROM definition_set WHERE category_id = %i;", catID];
	
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0) {
		
		while (sqlite3_step(sqlStatement) == SQLITE_ROW) 
		{
			DefinitionSet* defSet = [[[DefinitionSet alloc] init] autorelease];
			[self createDefinitionSetFromRow:defSet statement:sqlStatement];
			NSLog(@"defSet: %@", defSet);
			[resultsArray addObject:defSet];
		}
		NSLog(@"Definition Sets for category successfully retrieved from database");
		NSLog(@"%@", resultsArray);
		
	}
	else 
	{
		NSLog(@"Problem with sql statement when trying to get definition sets for a category");
	}
	
	sqlite3_finalize(sqlStatement);
	
	return resultsArray;
}


// This method inserts a new definition_set into the database
// The definition_set table is structured as follows:
// - definition_id int auto_increment not null
// - english TEXT NOT NULL,
// - spanish TEXT NOT NULL,
// - gender TEXT,
// - singularOrPlural int,
// - partOfSpeech TEXT,
// - audioPath TEXT,
// - imagePath TEXT,
// - category INT (foreign key)
- (void) updateDefinitionSetInDictionary:(DefinitionSet*)defSet
{
	NSString* tempStatement = [NSString stringWithFormat:@"UPDATE definition_set SET english = \"%@\", spanish = \"%@\", gender = \"%@\", singularOrPlural = %i, partOfSpeech = \"%@\", audioPath = \"%@\", imagePath = \"%@\", category_id = %i WHERE definition_id = %i;", [defSet english], [defSet spanish], [defSet gender], [defSet singularOrPlural], [defSet partOfSpeech], [defSet audioPath], [defSet imagePath], [defSet categoryID], [defSet definitionID]];
	
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0)
	{
		int result = sqlite3_step(sqlStatement);
		if (result != SQLITE_DONE)
		{
			NSLog(@"Error updating definition into dictionary");
		}
		else 
		{
			NSLog(@"Successfully updated definition set in dictionary");
		}
		
	}
	else 
	{
		NSLog(@"Could not convert %@ into sql statement", tempStatement);
	}
	
	// Finalize the statement
	sqlite3_finalize(sqlStatement);
	
	DefinitionSet* tempDefSet = [self getDefinitionSetFromDictionary:[defSet definitionID]];
	NSLog(@"Def set returned from dictionary: %@", tempDefSet);
}



- (NSArray*) getCategoriesFromDictionary
{
	NSMutableArray* categoryArray = [[[NSMutableArray alloc] init] autorelease];
	
	NSString* tempStatement = @"SELECT * FROM categories;";
	
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0)
	{
		while (sqlite3_step(sqlStatement) == SQLITE_ROW) 
		{
			WordCategory* category = [[[WordCategory alloc] init] autorelease];
			[category setCategoryID:sqlite3_column_int(sqlStatement, 0)];
			[category setCategoryName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)]];
			[categoryArray addObject:category];
		}
		
	}
	else 
    {
		NSLog(@"Could not prepare sql statement.");
	}
	
	// Finalize the statement
	sqlite3_finalize(sqlStatement);	
	
	NSLog(@"Category Array: %@", categoryArray);
	
	return categoryArray;
	
}


- (void) addCategoryToDictionary:(NSString*)category
{
	if (![self categoryAlreadyInDictionary:category])
    {
		NSString* tempStatement = [NSString stringWithFormat:@"INSERT INTO categories VALUES (%i,'%@');", [self lastCategoryIndex] + 1, category];
		
		// Increment last category index
		[self setLastCategoryIndex:[self lastCategoryIndex] + 1];
		
		sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
		if (sqlStatement != 0)
		{
			int result = sqlite3_step(sqlStatement);
			if (result != SQLITE_DONE)
			{
				NSLog(@"Error with inserting category into dictionary");
			}
		}
		else 
		{
			NSLog(@"Could not convert %@ into sql statement", tempStatement);
		}
        
		// Finalize the statement
		sqlite3_finalize(sqlStatement);
	}
}

- (int) idForCategory:(NSString*)category
{
	NSString* lowerCaseVersion = [category lowercaseString];
	NSString* tempStatement = [NSString stringWithFormat:@"SELECT * FROM categories WHERE category_name =  '%@';", lowerCaseVersion];
	
	int catID = 0;
	
	sqlite3_stmt* sqlStatement = [self prepareStatement:tempStatement];
	if (sqlStatement != 0)
	{
		if (sqlite3_step(sqlStatement) == SQLITE_ROW)
		{
			catID = sqlite3_column_int(sqlStatement, 0);
		}
		else 
		{
			NSLog(@"problem retrieving category id");
		}
		
		
	}
	else {
		NSLog(@"Could not prepare sequel statement.");
	}
	
	return catID;
	
	// Finalize the statement
	sqlite3_finalize(sqlStatement);	
	
}

@end

