//
//  AddCarViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import "AddCarViewController.h"
#import "UIViewController+Ext.h"
#import "UIViewController+NavigationBar.h"
#import "UIView+ConcisePureLayout.h"
#import "InputTextField.h"
#import "AAButton+Styles.h"
#import "InputTextField+Validation.h"

@interface AddCarViewController ()
@end

@implementation AddCarViewController {
    CarTypesTabbarView *carTypesTabbarView;
    InputTextField *_numberField;
    InputTextField *_markaField;
}

- (id)init
{
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

    [carTypesTabbarView setCarType:CarTypeSedan];

    if(kDEBUGMODE) {
        [_numberField setValue:@"B248ZFN"];
        [_markaField setValue:@"Toyota Camry"];
    }
}

#pragma mark -
#pragma mark Actions

- (void)add
{
    if (![_numberField validate]) return;
    if (![_markaField validate]) return;

    [self.view endEditing:YES];

    Car *car = [Car new];
    car.carType = carTypesTabbarView.carType;
    car.carNumber = _numberField.value;
    car.carModel = _markaField.value;

    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate AddCarViewControllerCarAdded:car];
    }];
}

#pragma mark -
#pragma mark CarTypesTabbarView

- (void)carTypesTabbarViewDidChangeTabWithType:(CarType)carType {

}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setNavigationBarTransparent];
    [self setNavigationCloseAtLeft:NO];
    self.title = @"Добавить машину";

    carTypesTabbarView = [[CarTypesTabbarView alloc] initWithCarTypeIds:@[@(CarTypeSedan), @(CarTypeSmallJeep), @(CarTypeJeep), @(CarTypeMinibus)]];
    carTypesTabbarView.delegate = self;
    [self.contentView addSubview:carTypesTabbarView];
    [carTypesTabbarView aa_setDimensions];
    [carTypesTabbarView aa_superviewTop:25];

    _numberField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    [_numberField setPlaceholder:@"Гос. номер"];
    _numberField.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [self.contentView addSubview:_numberField];
    [_numberField aa_setDimensions];
    [_numberField aa_pinUnderView:carTypesTabbarView offset:20];
    [_numberField aa_centerHorizontal];

    _markaField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    [_markaField setPlaceholder:@"Марка автомобиля"];
    _markaField.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self.contentView addSubview:_markaField];
    [_markaField aa_setDimensions];
    [_markaField aa_pinUnderView:_numberField offset:5];
    [_markaField aa_centerHorizontal];

    __weak AddCarViewController * weakSelf = self;
    AAButton *addButton = [[AAButton alloc] initWithWidth:150 onTap:^(UIView *_self) {
        [weakSelf add];
    }];
    [addButton commonStyleButtonWithTitle:@"Добавить"];
    [addButton setTitleFont:[UIFont robotoRegular:18]];
    addButton.height = 40;
    [self.contentView addSubview:addButton];
    [addButton aa_setDimensions];
    [addButton aa_pinUnderView:_markaField offset:30];
    [addButton aa_centerHorizontal];
    [addButton aa_superviewBottom:25];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end
