//
//  SetCarwashScheduleViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SetCarwashScheduleViewController.h"
#import "UIViewController+Ext.h"
#import "TitleInputFieldView.h"
#import "TimeIntervalPickerView.h"
#import "CreateCarwashDraft.h"

@interface SetCarwashScheduleViewController ()
@end

@implementation SetCarwashScheduleViewController {
    TitleInputFieldView *monfield;
    TitleInputFieldView *tuefield;
    TitleInputFieldView *wedfield;
    TitleInputFieldView *thufield;
    TitleInputFieldView *frifield;
    TitleInputFieldView *satfield;
    TitleInputFieldView *sunfield;

    UITextField *activeTextField;
    TimeIntervalPickerView *timePickerView;
    TitleInputFieldView *commentsField;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];

    // Set values
    CreateCarwashDraft *draft = [CreateCarwashDraft sharedInstance];
    [commentsField setValue:draft.scheduleComment];
    [monfield setValue:draft.schedule[0]];
    [tuefield setValue:draft.schedule[1]];
    [wedfield setValue:draft.schedule[2]];
    [thufield setValue:draft.schedule[3]];
    [frifield setValue:draft.schedule[5]];
    [satfield setValue:draft.schedule[4]];
    [sunfield setValue:draft.schedule[6]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    CreateCarwashDraft *draft = [CreateCarwashDraft sharedInstance];
    draft.scheduleComment = [commentsField value];

    NSMutableArray *times = [NSMutableArray array];
    [times addObject:[monfield value]];
    [times addObject:[tuefield value]];
    [times addObject:[wedfield value]];
    [times addObject:[thufield value]];
    [times addObject:[frifield value]];
    [times addObject:[satfield value]];
    [times addObject:[sunfield value]];
    draft.schedule = times;
}

#pragma mark -
#pragma mark Actions

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSLog(@"%@", datePicker);
//    NSLog(@"%@", [datePicker tar]);
}

#pragma mark -
#pragma mark TimeIntervalPickerView

- (void)timeIntervalPickerViewDidChange:(NSString *)timeIntervalString {
    activeTextField.text = timeIntervalString;
}

#pragma mark -
#pragma mark UITExtField

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    activeTextField = textField;

    [timePickerView updateDatePickerDatesFromTextFieldText:textField.text];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Часы работы"];

    // Times picker
    timePickerView = [[TimeIntervalPickerView alloc] init];
    timePickerView.delegate = self;
    [timePickerView setTitle:@"Работает от:" left:YES];
    [timePickerView setTitle:@"Работает до:" left:NO];

    CGFloat fieldsSpacing = 10;
    NSString *defaultValue = [NSString stringWithFormat:@"09:00%@22:00", timePickerView.timesSeparator];

    monfield = [[TitleInputFieldView alloc] initWithTitle:@"Понедельник:" fieldPlaceholder:defaultValue];
    monfield.y = 10;
    [sv addSubview:monfield];

    tuefield = [[TitleInputFieldView alloc] initWithTitle:@"Вторник:" fieldPlaceholder:defaultValue];
    tuefield.y = monfield.bottom + fieldsSpacing;
    [sv addSubview:tuefield];

    wedfield = [[TitleInputFieldView alloc] initWithTitle:@"Среда:" fieldPlaceholder:defaultValue];
    wedfield.y = tuefield.bottom + fieldsSpacing;
    [sv addSubview:wedfield];

    thufield = [[TitleInputFieldView alloc] initWithTitle:@"Четверг:" fieldPlaceholder:defaultValue];
    thufield.y = wedfield.bottom + fieldsSpacing;
    [sv addSubview:thufield];

    frifield = [[TitleInputFieldView alloc] initWithTitle:@"Пятница:" fieldPlaceholder:defaultValue];
    frifield.y = thufield.bottom + fieldsSpacing;
    [sv addSubview:frifield];

    satfield = [[TitleInputFieldView alloc] initWithTitle:@"Суббота:" fieldPlaceholder:defaultValue];
    satfield.y = frifield.bottom + fieldsSpacing;
    [sv addSubview:satfield];

    sunfield = [[TitleInputFieldView alloc] initWithTitle:@"Воскресенье:" fieldPlaceholder:defaultValue];
    sunfield.y = satfield.bottom + fieldsSpacing;
    [sv addSubview:sunfield];

    [monfield setValue:defaultValue];
    [tuefield setValue:defaultValue];
    [wedfield setValue:defaultValue];
    [thufield setValue:defaultValue];
    [frifield setValue:defaultValue];
    [satfield setValue:defaultValue];
    [sunfield setValue:defaultValue];

    monfield.inputTextField.textField.inputView = timePickerView;
    tuefield.inputTextField.textField.inputView = timePickerView;
    wedfield.inputTextField.textField.inputView = timePickerView;
    thufield.inputTextField.textField.inputView = timePickerView;
    frifield.inputTextField.textField.inputView = timePickerView;
    satfield.inputTextField.textField.inputView = timePickerView;
    sunfield.inputTextField.textField.inputView = timePickerView;
    
    // Comments field
    commentsField = [[TitleInputFieldView alloc] initWithTitle:@"Комментарии:" fieldPlaceholder:@"Опционально"];
    commentsField.y = sunfield.bottom + 25;
    commentsField.inputTextField.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [sv addSubview:commentsField];

    [sv setContentSizeHeight:commentsField.bottom + 15];
    [self addKeyboardControlFields:@[monfield.inputTextField.textField, tuefield.inputTextField.textField, wedfield.inputTextField.textField, thufield.inputTextField.textField, frifield.inputTextField.textField, satfield.inputTextField.textField, sunfield.inputTextField.textField, commentsField.inputTextField.textField]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end