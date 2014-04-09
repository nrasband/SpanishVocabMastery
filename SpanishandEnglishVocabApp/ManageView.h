//
//  ManageView.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/16/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

@interface ManageView : UIView 
{
    UITextField* _textField;
    UITableView* _tableView;
}

// Constructor
- (id) initWithFrame:(CGRect)frame;

// Properties
- (UITextField*) textField;
- (UITableView*) tableView;

@end
