//
//  SetCarwashOtherInfosViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SetCarwashOtherInfosViewController.h"
#import "UIViewController+Ext.h"
#import "UILabel+Components.h"
#import "TitleInputFieldView.h"
#import "UIView+Ext.h"
#import "RowButtonCheckmarkView.h"
#import "CompanyCarwashRefs.h"
#import "Cache.h"
#import "CreateCarwashDraft.h"
#import "IdTitleObject.h"
#import "User.h"

@interface SetCarwashOtherInfosViewController ()
@end

@implementation SetCarwashOtherInfosViewController {
    NSArray *addInfos;
    NSArray *payoptions;
    TitleInputFieldView *telfield;
    TitleInputFieldView *websitefield;
    TitleInputFieldView *emailfield;
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
    [self configAction];

    [Cache companyCarwashRefs:^(id obj) {
        addInfos = [(CompanyCarwashRefs *)obj additionalInfo];
        payoptions = [(CompanyCarwashRefs *)obj payoptions];
        [self buildUI];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideKeyboard];

    CreateCarwashDraft *draft = [CreateCarwashDraft sharedInstance];
    draft.telephone = [telfield value];
    draft.website = [websitefield value];
    draft.email = [emailfield value];
}

- (void)configAction
{

}

#pragma mark -
#pragma mark Actions

- (void)payoptionTapped:(RowButtonView *)view
{
    RowButtonCheckmarkView *row = (RowButtonCheckmarkView *)view;
    if([row isChecked]) {
        [[CreateCarwashDraft sharedInstance] addPayoption:row.userData];
    } else {
        [[CreateCarwashDraft sharedInstance] removePayoption:row.userData];
    }
}

- (void)additionalInfoTapped:(RowButtonView *)view
{
    RowButtonCheckmarkView *row = (RowButtonCheckmarkView *)view;
    if([row isChecked]) {
        [[CreateCarwashDraft sharedInstance] addAdditionalInfo:row.userData];
    } else {
        [[CreateCarwashDraft sharedInstance] removeAdditionalInfo:row.userData];
    }
}

#pragma mark -

- (void)buildUI
{
    CGFloat fieldsSpacing = 10;
    __weak SetCarwashOtherInfosViewController *wSelf = self;
    CreateCarwashDraft *draft = [CreateCarwashDraft sharedInstance];

    // Contacts
    UIView *contactsTitleView = [UIView headerViewWithTitle:@"Контакты"];
    contactsTitleView.y = 5;
    [sv addSubview:contactsTitleView];

    telfield = [[TitleInputFieldView alloc] initWithTitle:@"Телефон:" fieldPlaceholder:@"Номер телефона"];
    telfield.y = contactsTitleView.bottom + 10;
    telfield.inputTextField.textField.keyboardType = UIKeyboardTypePhonePad;
    if(draft.telephone.length > 0) {
        [telfield setValue:draft.telephone];
    } else {
        [telfield setValue:[User currentUser].mobile];
    }
    [sv addSubview:telfield];

    websitefield = [[TitleInputFieldView alloc] initWithTitle:@"Вэб страница:" fieldPlaceholder:@"www.company.kz"];
    websitefield.y = telfield.bottom + fieldsSpacing;
    websitefield.inputTextField.textField.keyboardType = UIKeyboardTypeURL;
    [websitefield setValue:draft.website];
    [sv addSubview:websitefield];

    emailfield = [[TitleInputFieldView alloc] initWithTitle:@"E-mail:" fieldPlaceholder:@"Электронный адрес"];
    emailfield.y = websitefield.bottom + fieldsSpacing;
    emailfield.inputTextField.textField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailfield setValue:draft.email];
    [sv addSubview:emailfield];

    // Payoptions
    UIView *payoptionsTitleView = [UIView headerViewWithTitle:@"Средства оплаты"];
    payoptionsTitleView.y = emailfield.bottom + 15;
    [sv addSubview:payoptionsTitleView];

    // Generate pay options list
    CGFloat lastY = payoptionsTitleView.bottom + 10;

    for(IdTitleObject *payoption in payoptions)
    {
        RowButtonCheckmarkView *row = [[RowButtonCheckmarkView alloc] initWithTitle:payoption.title onTap:^(RowButtonView *rowButtonView) {
            [wSelf payoptionTapped:rowButtonView];
        }];
        row.userData = payoption;
        row.centerX = sv.centerX;
        row.y = lastY;
        [sv addSubview:row];

        // Check if already set
        if([[CreateCarwashDraft sharedInstance] hasPayoptionWithId:payoption.objectId]) {
            row.isChecked = YES;
        }

        lastY = row.bottom;
    }

    // Other infos
    UIView *otherInfosTitleView = [UIView headerViewWithTitle:@"Дополнительная информация"];
    otherInfosTitleView.y = lastY + 15;
    [sv addSubview:otherInfosTitleView];

    lastY = otherInfosTitleView.bottom + 10;
    for(IdTitleObject *info in addInfos)
    {
        RowButtonCheckmarkView *row = [[RowButtonCheckmarkView alloc] initWithTitle:info.title onTap:^(RowButtonView *rowButtonView) {
            [wSelf additionalInfoTapped:rowButtonView];
        }];
        row.userData = info;
        row.centerX = sv.centerX;
        row.y = lastY;
        [sv addSubview:row];

        // Check if already set
        if([[CreateCarwashDraft sharedInstance] hasAdditionalInfoWithId:info.objectId]) {
            row.isChecked = YES;
        }

        lastY = row.bottom;
    }

    [sv setContentSizeHeight:lastY + 10];
    [self addKeyboardControlFields:@[telfield.inputTextField.textField, websitefield.inputTextField.textField, emailfield.inputTextField.textField]];

}

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Дополнительно"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end