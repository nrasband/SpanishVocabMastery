//
//  SearchView.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/21/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

@interface SearchView : UIView 
{
    UILabel* _randomWordLabel;
    UISearchBar* _searchBar;
    UISegmentedControl* _languageDirectionSelection;
    UITableView* _resultsTable;
}

// Constructors
- (id) initWithFrame:(CGRect)frame;

// Properties
- (UILabel*) randomWordLabel;
- (UISearchBar*) searchBar;
- (UISegmentedControl*) languageDirectionSelection;
- (UITableView*) resultsTable;


@end
