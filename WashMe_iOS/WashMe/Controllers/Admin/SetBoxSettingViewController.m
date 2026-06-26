//
//  SetBoxSettingViewController.m
//  WashMe
//
//  Created by Ivan Korotkikh on 25.09.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "SetBoxSettingViewController.h"
#import "UIViewController+Ext.h"
#import "InputTextField.h"
#import "InputTextField+Validation.h"
#import "RowButtonCheckmarkView.h"
#import "AAButton+Styles.h"
#import "BoxSetting.h"
#import "AdminApi.h"
#import "CarwashComplex.h"
#import "UIHelper.h"
#import "UIActionSheet+Blocks.h"

@interface SetBoxSettingViewController ()

@end

@implementation SetBoxSettingViewController {
    InputTextField *boxNameField;
    RowButtonCheckmarkView *rowOnline;
    RowButtonCheckmarkView *rowOffline;    
}


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

- (void)createTapped {
    if ([self validPrepareBoxSetting]){
        NSMutableDictionary *o = [NSMutableDictionary dictionary];
        o[@"box_name"] = boxNameField.textField.text;
        if (rowOnline.isChecked){
            o[@"booking_type"] = @"online";
        }
        if (rowOffline.isChecked){
            o[@"booking_type"] = @"offline";
        }
        NSLog(@"info: %@", o);
        
        [Toast showHudWithTitle:@"Сохранение"];
        [AdminApi createCarwashBox:self.carwash.carwashId params:o success:^(id response) {
            [Toast showSuccessToastWithMessage:@"Сохранено"];
            [self.delegate boxSettingUpdated];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString *message) {
            
        }];
    }
}

- (void)updateTapped {
    if ([self validPrepareBoxSetting]){
        NSMutableDictionary *o = [NSMutableDictionary dictionary];
        o[@"box_name"] = boxNameField.textField.text;
        if (rowOnline.isChecked){
            o[@"booking_type"] = @"online";
        }
        if (rowOffline.isChecked){
            o[@"booking_type"] = @"offline";
        }
        NSLog(@"info: %@", o);
        
        [Toast showHudWithTitle:@"Сохранение"];
        [AdminApi updateCarwashBox:self.carwash.carwashId box:self.box.uid params:o success:^(id response) {
            [Toast showSuccessToastWithMessage:@"Сохранено"];
            [self.delegate boxSettingUpdated];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString *message) {
        }];
    }
}

- (void)deleteTapped {
    __weak SetBoxSettingViewController *weakSelf = self;
    NSString *question = [NSString stringWithFormat:@"Удалить %@?", _box.boxName];
    [UIActionSheet showInView:self.view withTitle:question cancelButtonTitle:@"Отмена" destructiveButtonTitle:@"Удалить" otherButtonTitles:nil tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == actionSheet.destructiveButtonIndex){
            [Toast showHudWithTitle:@"Удаление"];
            [AdminApi deleteCarwashBox:weakSelf.carwash.carwashId box:weakSelf.box.uid success:^(id response) {
                [Toast showSuccessToastWithMessage:@"Удалено"];
                [weakSelf.delegate boxSettingUpdated];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } failure:^(NSInteger code, NSString *message) {
                NSLog(@"%li", code);
            }];
        }
    }];
}

- (BOOL)validPrepareBoxSetting {
    if(![boxNameField validate]) {
        [UIHelper showAlertFillRequiredField];
        return NO;
    }
    
    if (![rowOnline isChecked] && ![rowOffline isChecked]){
        [UIHelper showErrorAlertWithMessage:@"Обязательно выберите тип бокса."];
        return NO;
    }
    return YES;
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    
    if (_editMode){
        [self setNavigationTitle:@"Настройка бокса"];
    } else {
        [self setNavigationTitle:@"Добавление бокса"];
    }
    
    CGFloat lastY = boxNameField.bottom + 10;
    // Address
    boxNameField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    boxNameField.centerX = self.view.centerX;
    boxNameField.y = lastY;
    boxNameField.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [boxNameField setPlaceholder:@"Название бокса"];
    [sv addSubview:boxNameField];
    lastY = boxNameField.bottom;
    
    __weak SetBoxSettingViewController *wSelf = self;
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
            [wSelf createTapped];
        }];
        [continueButton commonStyleButtonWithTitle:@"ДОБАВИТЬ БОКС"];
        [continueButton setTitleFont:[UIFont robotoRegular:18]];
        continueButton.centerX = self.view.centerX;
        continueButton.y = lastY + 30;
        continueButton.height = 40;
        [sv addSubview:continueButton];
        lastY = continueButton.bottom;
    } else {
        AAButton *updateButton = [[AAButton alloc] initWithWidth:kButtonWidth onTap:^(UIView *_self) {
            [wSelf updateTapped];
        }];
        [updateButton commonStyleButtonWithTitle:@"СОХРАНИТЬ"];
        [updateButton setTitleFont:[UIFont robotoRegular:18]];
        updateButton.centerX = self.view.centerX;
        updateButton.y = lastY + 30;
        updateButton.height = 40;
        [sv addSubview:updateButton];
        lastY = updateButton.bottom;
        
        AAButton *deleteButton = [[AAButton alloc] initWithWidth:kButtonWidth onTap:^(UIView *_self) {
            [wSelf deleteTapped];
        }];
        [deleteButton commonStyleButtonWithTitle:@"УДАЛИТЬ БОКС"];
        [deleteButton setTitleFont:[UIFont robotoRegular:18]];
        [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        deleteButton.centerX = self.view.centerX;
        deleteButton.y = lastY + 30;
        deleteButton.height = 40;
        [sv addSubview:deleteButton];
        lastY = deleteButton.bottom;
    }
    
    [self setScrollContentHeight:lastY];
    [self addKeyboardControlFields:@[boxNameField.textField]];
    
    if (_editMode) [self buildUI];
}

- (void)buildUI {
    if (_box){
        boxNameField.textField.text = _box.boxName;
        if ([_box.bookingType isEqual:@"online"]){
            [rowOnline setIsChecked:YES];
            [rowOffline setIsChecked:NO];
        }
        if ([_box.bookingType isEqual:@"offline"]){
            [rowOnline setIsChecked:NO];
            [rowOffline setIsChecked:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
}

@end
