//
//  DefinitionSetsView.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/18/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

@interface DefinitionSetsView : UIView 
{
    UIButton* _button;
    UITableView* _tableView;
}

// Constructor
- (id) initWithFrame:(CGRect)frame;

// Methods
- (void) layoutViews;

// Properties
- (UIButton*) button;
- (UITableView*) tableView;

@end
