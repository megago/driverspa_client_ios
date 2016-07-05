//
//  SetCarwashAddressViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/22/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIActionSheet+Blocks/UIActionSheet+Blocks.h>
#import "SetCarwashAddressViewController.h"
#import "UIViewController+Ext.h"
#import "InputTextField.h"
#import "RowButtonDisclosureView.h"
#import "SetCarwashCoordinateViewController.h"
#import "CreateCarwashDraft.h"
#import "RowButtonDropdownView.h"
#import "IdTitleObject.h"
#import "CompanyCarwashRefs.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "City.h"

@interface SetCarwashAddressViewController ()
@end

@implementation SetCarwashAddressViewController {
    RowButtonDisclosureView *mapButton;
    InputTextField *addressField;
    RowButtonDropdownView *cityButton;
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

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideKeyboard];

    [[CreateCarwashDraft sharedInstance] setAddress:[addressField value]];
}

#pragma mark -
#pragma mark Action

- (void)cityDropdownTapped
{
    NSArray *cities = [[Cache companyCarwashRefs] cities];
    NSMutableArray * cityNames = [NSMutableArray array];
    for(City *city in cities) {
        [cityNames addObject:city.title];
    }

    [UIActionSheet showInView:self.view withTitle:@"Укажите город мойки" cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:cityNames tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if(actionSheet.cancelButtonIndex != buttonIndex)
        {
            CreateCarwashDraft *draft = [CreateCarwashDraft sharedInstance];
            City *selectedCity = cities[buttonIndex];
            draft.city = selectedCity;

            [cityButton setTitle:selectedCity.title];
        }
    }];
}

- (void)setOnMapTapped
{
    [self hideKeyboard];
    SetCarwashCoordinateViewController *v = [[SetCarwashCoordinateViewController alloc] init];
    v.delegate = self;
    v.coordinate = [CreateCarwashDraft sharedInstance].coordinate;
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark SetCarwashCoordinateViewController

-(void)setCarwashCoordinateViewControllerCoordinateDidSet:(CLLocationCoordinate2D)coordinate {
    [[CreateCarwashDraft sharedInstance] setCoordinate:coordinate];
    [mapButton setTitle:[NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude]];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButton];
    [self setNavigationTitle:@"Адрес"];

    CreateCarwashDraft *draft = [CreateCarwashDraft sharedInstance];

    // City
    City *cityObject = draft.city;
    cityButton = [[RowButtonDropdownView alloc] initWithWidth:kContentWidth
                                                         icon:nil
                                                        title:(cityObject ? cityObject.title : @"Выберите город")
                                                       target:self
                                                     selector:@selector(cityDropdownTapped)];
    cityButton.y = 30;
    [cityButton removeTopLine];
    [sv addSubview:cityButton];

    // Address
    addressField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    addressField.centerX = self.view.centerX;
    addressField.y = cityButton.bottom + 10;
    addressField.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [addressField setPlaceholder:@"Улица"];
    [addressField setValue:draft.address];
    [sv addSubview:addressField];

    // Map button
    NSString *mapButtonTitle = @"Отметить на карте";
    if([draft issetCoordinate]) {
        CLLocationCoordinate2D coordinate = [draft coordinate];
        mapButtonTitle = [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
    }

    mapButton = [[RowButtonDisclosureView alloc] initWithWidth:kContentWidth icon:@"icon-pin" title:mapButtonTitle target:self selector:@selector(setOnMapTapped)];
    mapButton.y = addressField.bottom + 10;
    [mapButton removeTopLine];
    [sv addSubview:mapButton];

    [self addKeyboardControlFields:@[addressField.textField, addressField.textField]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end
