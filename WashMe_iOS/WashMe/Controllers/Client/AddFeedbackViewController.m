//
// Created by Almas Adilbek on 10/1/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "AddFeedbackViewController.h"
#import "UIViewController+Ext.h"
#import "Carwash.h"
#import "AMRatingControl.h"
#import "TextareaField.h"
#import "AAButton+Styles.h"
#import "UIScrollView+Ext.h"
#import "CarwashApi.h"


@interface AddFeedbackViewController ()
@end

@implementation AddFeedbackViewController {
    AMRatingControl *ratingControl;
    TextareaField *field;
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
}

- (void)configAction
{

}

#pragma mark -
#pragma mark Actions

- (void)addTapped
{
    [self hideKeyboard];

    if(ratingControl.rating == 0) {
        [UIHelper showAlertWithMessageTitle:@"Укажите свою оценку" message:@"Минимальная оценца одна звезда!"];
        [self.view endEditing:YES];
        return;
    }
    
    if([[field value] isEqual:@""]) {
        [UIHelper showAlertWithMessageTitle:@"Введите Ваше сообщение" message:@"Введите текст отзыва"];
        [field focus];
        return;
    }

    [Toast showHudWithTitle:@"Отправка"];
    [CarwashApi addFeedback:[field value] mark:ratingControl.rating carwashId:self.carwash.resourceUri success:^(id response) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate addFeedbackViewControllerFeedbackSent];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

#pragma mark -

-(void)configUI
{
    [super configUI];

    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Добавить отзыв"];

    sv.y = 64;
    sv.height = [ASize screenHeightWithoutStatusBarAndNavigationBar];

    // Title
    UILabel *carwashTitle = [sv setNavigationSubtitle:self.carwash.name];
    carwashTitle.y = 10;


    // Rate
    ratingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0)
                                                     emptyImage:[UIImage
                                                             imageWithName:@"star-big-empty"]
                                                     solidImage:[UIImage imageWithName:@"star-big-rated"]
                                                   andMaxRating:5];
    ratingControl.starSpacing = 4;
    ratingControl.starWidthAndHeight = 25;
    [sv addSubview:ratingControl];
    ratingControl.centerX = sv.centerX;
    ratingControl.y = carwashTitle.bottom + 20;

    // Field
    CGFloat padding = 15;
    field = [[TextareaField alloc] initWithWidth:sv.width - 2 * padding height:100];
    field.x = padding;
    field.y = ratingControl.bottom + 20;
    field.textarea.placeholderText = @"Напишитe свой отзыв...";
    [sv addSubview:field];

    // Button
    __weak AddFeedbackViewController *wSelf = self;
    AAButton *addButton = [[AAButton alloc] initWithWidth:200 onTap:^(UIView *_self) {
        [wSelf addTapped];
    }];
    [addButton commonStyleButtonWithTitle:@"ДОБАВИТЬ ОТЗЫВ"];
    [addButton setTitleFont:[UIFont robotoRegular:18]];
    addButton.centerX = sv.centerX;
    addButton.y = field.bottom + 15;
    addButton.height = 40;
    [sv addSubview:addButton];

    [self addKeyboardControlFields:@[field.textarea]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end