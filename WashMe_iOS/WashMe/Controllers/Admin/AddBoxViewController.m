//
//  AddBoxViewController.m
//  WashMe
//
//  Created by Ivan Korotkikh on 23.09.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "AddBoxViewController.h"
#import "UIViewController+Ext.h"
#import "InputTextField.h"
#import "RowButtonCheckmarkView.h"
#import "AAButton+Styles.h"

@interface AddBoxViewController () {
    InputTextField *boxNameField;
    RowButtonCheckmarkView *rowOnline;
    RowButtonCheckmarkView *rowOffline;

}

@end

@implementation AddBoxViewController

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
}

#pragma mark -
#pragma mark Actions

- (void)payoptionTapped:(RowButtonView *)view {
    RowButtonCheckmarkView *row = (RowButtonCheckmarkView *)view;
    if (row == rowOnline){
        [rowOffline setIsChecked:NO];
    } else {
        [rowOnline setIsChecked:NO];
    }
}

- (void)continueTapped {

}

- (void)deleteTapped {
    
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Добавление бокса"];
    
    CGFloat lastY = boxNameField.bottom + 10;
    // Address
    boxNameField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    boxNameField.centerX = self.view.centerX;
    boxNameField.y = lastY;
    boxNameField.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [boxNameField setPlaceholder:@"Название бокса"];
    [sv addSubview:boxNameField];
    lastY = boxNameField.bottom;

    __weak AddBoxViewController *wSelf = self;
    rowOnline = [[RowButtonCheckmarkView alloc] initWithTitle:@"Онлайн" onTap:^(RowButtonView *rowButtonView) {
        [wSelf payoptionTapped:rowButtonView];
    }];
    rowOnline.userData = @"online";
    rowOnline.centerX = sv.centerX;
    rowOnline.y = lastY;
    [sv addSubview:rowOnline];
    lastY = rowOnline.bottom;

    rowOffline = [[RowButtonCheckmarkView alloc] initWithTitle:@"Оффлайн" onTap:^(RowButtonView *rowButtonView) {
        [wSelf payoptionTapped:rowButtonView];
    }];
    rowOffline.userData = @"offline";
    rowOffline.centerX = sv.centerX;
    rowOffline.y = lastY;
    [sv addSubview:rowOffline];
    lastY = rowOffline.bottom;
    
    if (!_editMode){
        AAButton *continueButton = [[AAButton alloc] initWithWidth:kButtonWidth onTap:^(UIView *_self) {
            [wSelf continueTapped];
        }];
        [continueButton commonStyleButtonWithTitle:@"ДОБАВИТЬ БОКС"];
        [continueButton setTitleFont:[UIFont robotoRegular:18]];
        continueButton.centerX = self.view.centerX;
        continueButton.y = lastY + 30;
        continueButton.height = 40;
        [sv addSubview:continueButton];
        lastY = continueButton.bottom;
    } else {
        AAButton *deleteButton = [[AAButton alloc] initWithWidth:kButtonWidth onTap:^(UIView *_self) {
            [wSelf continueTapped];
        }];
        [deleteButton commonStyleButtonWithTitle:@"УДАЛИТЬ БОКС"];
        [deleteButton setTitleFont:[UIFont robotoRegular:18]];
        deleteButton.centerX = self.view.centerX;
        deleteButton.y = lastY + 30;
        deleteButton.height = 40;
        [sv addSubview:deleteButton];
        lastY = deleteButton.bottom;
    }

    [self setScrollContentHeight:lastY];
    [self addKeyboardControlFields:@[boxNameField.textField]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
}

@end
