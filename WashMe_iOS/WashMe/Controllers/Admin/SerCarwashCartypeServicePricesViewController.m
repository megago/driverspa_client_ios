//
//  SerCarwashCartypeServicePricesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SerCarwashCartypeServicePricesViewController.h"
#import "UIViewController+Ext.h"
#import "IdTitleObject.h"
#import "CompanyCarwashRefs.h"
#import "Cache.h"
#import "TitleInputFieldView.h"
#import "InputTextField.h"
#import "CarwashMenuItem.h"
#import "CreateCarwashDraft.h"

@interface SerCarwashCartypeServicePricesViewController ()
@end

@implementation SerCarwashCartypeServicePricesViewController {
    NSArray *services;
    UILabel *titleLabel;
    NSMutableArray *fields;
    NSMutableArray *timeFields;
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

    services = [[CreateCarwashDraft sharedInstance] services];
    [self createFields];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSMutableArray *prices = [NSMutableArray array];

    // Get prices and time
    for (int i = 0; i < fields.count; i++)
    {
        TitleInputFieldView *field = fields[i];
        TitleInputFieldView *timeField = timeFields[i];

        NSString *price = [field value];
        NSString *time = [timeField value];

        [prices addObject:[CarwashMenuItem instanceWithType:field.userData price:@([price intValue]) time:@([time intValue])]];
    }
    [[CreateCarwashDraft sharedInstance] setPrices:prices forCarType:_carType];
}

- (void)createFields
{
    fields = [[NSMutableArray alloc] init];
    timeFields = [[NSMutableArray alloc] init];

    // Predefined prices
    NSArray *previousPrices = [[CreateCarwashDraft sharedInstance] pricesForCarTypeId:_carType.objectId];
    NSMutableDictionary *carwashMenuItemDictionary = [NSMutableDictionary dictionary];
    for(CarwashMenuItem *item in previousPrices) {
        carwashMenuItemDictionary[item.type] = item;
    }

    NSMutableArray *textFields = [NSMutableArray array];
    CGFloat lastY = 55;
    for(IdTitleObject *service in services)
    {
        TitleInputFieldView *field = [[TitleInputFieldView alloc] initWithTitle:[NSString stringWithFormat:@"%@:", service.title] fieldPlaceholder:@"Цена"];
        [field setTitleFont:[UIFont robotoBold:15]];
        field.y = lastY;
        field.userData = service.objectId;
        [field setRightText:@"KZT"];
        field.inputTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        [sv addSubview:field];

        TitleInputFieldView *timeField = [[TitleInputFieldView alloc] initWithTitle:@"Время:" fieldPlaceholder:@"Время"];
        timeField.y = field.bottom + 6;
        [timeField setRightText:@"мин."];
        timeField.inputTextField.textField.keyboardType = UIKeyboardTypeNumberPad;

        [sv addSubview:timeField];

        [textFields addObject:field.inputTextField.textField];
        [textFields addObject:timeField.inputTextField.textField];

        [fields addObject:field];
        [timeFields addObject:timeField];

        lastY = timeField.bottom + 20;

        // Set value
        CarwashMenuItem *menuItem = carwashMenuItemDictionary[service.objectId];
        if(menuItem) {
            [field setValue:[NSString stringWithFormat:@"%@", menuItem.price]];

            if([menuItem.time intValue] > 0) {
                [timeField setValue:[NSString stringWithFormat:@"%@", menuItem.time]];
            }
        }

        if([timeField value].length == 0) {
            // The default value 30 minutes
            [timeField setValue:@"30"];
        }
    }

    [sv setContentSizeHeight:lastY + 5];
    [self addKeyboardControlFields:textFields];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Цены"];

    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont robotoRegular:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.text = [NSString stringWithFormat:@"Цены на\n\"%@\"", self.carType.title];
    [titleLabel sizeToFit];
    titleLabel.centerX = sv.centerX;
    titleLabel.y = 5;
    [sv addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end