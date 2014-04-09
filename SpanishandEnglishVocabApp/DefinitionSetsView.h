//
//  DefinitionSetsView.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/18/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

@interface DefinitionSetsView : UIView 
{
    UITextField* _categoryTextField;
    UIButton* _button;
    UITableView* _tableView;
}

// Constructor
- (id) initWithFrame:(CGRect)frame;

// Properties
- (UIButton*) button;
- (UITextField*) categoryTextField;
- (UITableView*) tableView;

@end
