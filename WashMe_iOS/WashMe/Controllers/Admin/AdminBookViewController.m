//
//  AdminBookViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 1/4/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import "AdminBookViewController.h"
#import "UIViewController+Ext.h"
#import "User.h"
#import "CarwashRefs.h"
#import "Cache.h"
#import "CarwashBook.h"
#import "TitleValueView.h"
#import "AAButton+Styles.h"
#import "UIScrollView+Ext.h"
#import "UIActionSheet+Blocks.h"
#import "AdminApi.h"
#import "M13BadgeView.h"
#import "UIAlertView+Blocks.h"
#import "UserObject.h"

@interface AdminBookViewController ()
@end

@implementation AdminBookViewController {
    UserObject *userObject;
    M13BadgeView *statusView;
    AAButton *editButton;
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

    [Toast showHudLoading];
    [AdminApi orderBook:self.book.carwashBookId success:^(id response)
    {
        self.book = response;

        [Toast showHudWithTitle:@"Загрузка пользователя"];
        NSString *path = [self.book.client stringByReplacingOccurrencesOfString:@"/api/v1/" withString:@""];
        [UserApi userWithResourceUri:path success:^(id response)
        {
            userObject = response;
            [self buildUI];

        } failure:^(NSInteger code, NSString *message)
        {
            if([message length] == 0) [UIHelper showAlertTryAgain];
            [self.navigationController popViewControllerAnimated:YES];
        }];

    } failure:^(NSInteger code, NSString *message)
    {
        if([message length] == 0) [UIHelper showAlertTryAgain];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark -
#pragma mark Actions

- (void)editTapped
{
    NSMutableArray * options = [NSMutableArray array];

    if([_book isPending])
    {
        [options addObject:@"Принять"];
        [options addObject:@"Отклонить"];
    }
    else if ([_book isApproved])
    {
        [options addObject:@"Начало выполнения услуг"];
        [options addObject:@"Клиент не явился"];
    }
    else if ([_book isStarted])
    {
        [options addObject:@"Завершение услуг"];
    }

    if(options.count > 0)
    {
        [UIActionSheet showInView:self.view
                        withTitle:@"Настройки"
                cancelButtonTitle:@"Отмена"
           destructiveButtonTitle:nil
                otherButtonTitles:options
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if(actionSheet.cancelButtonIndex != buttonIndex)
            {
                if([_book isPending])
                {
                    switch (buttonIndex) {
                        case 0:
                            [self approveBook];
                            break;
                        case 1:
                            [self rejectBook];
                            break;
                        default:break;
                    }
                }
                else if([_book isApproved])
                {
                    switch (buttonIndex) {
                        case 0:
                            [self startBook];
                            break;
                        case 1:
                            [self clientDidNotCome];
                            break;
                        default:break;
                    }
                }
                else if([_book isStarted])
                {
                    switch (buttonIndex) {
                        case 0:
                            [self finishBook];
                            break;
                        default:break;
                    }
                }
            }
        }];
    }
}

- (void)approveBook
{
    // Approve book
    [Toast showHudWait];
    [AdminApi approveBook:_book.carwashBookId success:^(id response) {
        [self checkUpdatedStatusResponse:response withStatus:kBookStatusApproved withSuccessTitle:@"Заказ принят" actionBlock:nil];
    } failure:^(NSInteger code, NSString *message) {
        [UIHelper showAlertTryAgain];
    }];
}

- (void)rejectBook
{
    [UIAlertView showWithTitle:@"Вы действительно хотите отклонить бронь?" message:nil cancelButtonTitle:@"Отмена" otherButtonTitles:@[@"Отклонить"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
       if(buttonIndex != alertView.cancelButtonIndex) {
           // Reject book
           [Toast showHudWithTitle:@"Отмена"];
           [AdminApi rejectBook:_book.carwashBookId success:^(id response) {
               __weak AdminBookViewController * weakSelf = self;
               [self checkUpdatedStatusResponse:response withStatus:kBookStatusRejected withSuccessTitle:@"Заказ отклонен" actionBlock:^{
                   [weakSelf.navigationController popViewControllerAnimated:YES];
               }];
           } failure:^(NSInteger code, NSString *message) {
               [UIHelper showAlertTryAgain];
           }];
       }
    }];
}

- (void)startBook
{
    // Start book
    [Toast showHudWait];
    [AdminApi startBook:_book.carwashBookId success:^(id response) {
        [self checkUpdatedStatusResponse:response withStatus:kBookStatusStarted withSuccessTitle:@"Старт" actionBlock:nil];
    } failure:^(NSInteger code, NSString *message) {
        [UIHelper showAlertTryAgain];
    }];
}

- (void)finishBook
{
    // Start book
    [Toast showHudWait];
    [AdminApi finishBook:_book.carwashBookId success:^(id response) {
        __weak AdminBookViewController * weakSelf = self;
        [self checkUpdatedStatusResponse:response withStatus:kBookStatusFinished withSuccessTitle:@"Услуги завершены" actionBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSInteger code, NSString *message) {
        [UIHelper showAlertTryAgain];
    }];
}

- (void)clientDidNotCome
{
    // Client did not come
    [Toast showHudWait];
    [AdminApi clientDidNotCome:_book.carwashBookId success:^(id response) {

        [self checkUpdatedStatusResponse:response withStatus:kBookStatusNoCome withSuccessTitle:@"Клиент не явился" actionBlock:^{
            [editButton setHidden:YES];
        }];

    } failure:^(NSInteger code, NSString *message) {
        [UIHelper showAlertTryAgain];
    }];
}

- (void)checkUpdatedStatusResponse:(id)response withStatus:(NSString *)bookStatus withSuccessTitle:(NSString *)toastTitle actionBlock:(void(^)(void))actionBlock
{
    NSString *status = response[@"status"];
    if([status isEqual:bookStatus])
    {
        [Toast showSuccessToastWithMessage:toastTitle];

        // Update the book status
        _book.status = status;
        [self updateBookStatusView];

        // Send delegate
        [self.delegate adminBookViewControllerBookStatusChanged:_book];

        if(actionBlock) {
            actionBlock();
        }

    } else {
        [UIHelper showAlertTryAgain];
    }
}

#pragma mark -

- (void)updateBookStatusView {
    if(statusView) {
        [statusView setText:[_book localizedStatus]];
        [statusView setBadgeBackgroundColor:[UIColor carwashBookStatusColor:_book.status]];
        statusView.centerX = sv.middleX;
    }
}

- (void)buildUI
{
    UILabel *subtitle = [sv setNavigationSubtitle:[self.book localizedPrettyDate]];
    subtitle.y = 10;

    // Status
    statusView = [[M13BadgeView alloc] initWithFrame:CGRectZero];
    statusView.font = [UIFont robotoBold:13];
    statusView.textColor = [UIColor whiteColor];
    statusView.horizontalAlignment = M13BadgeViewHorizontalAlignmentNone;
    statusView.verticalAlignment = M13BadgeViewVerticalAlignmentNone;
    statusView.cornerRadius = 5;
    [self updateBookStatusView];
    statusView.y = subtitle.bottom + 10;
    [sv addSubview:statusView];

    // Infos
    CGFloat rowWidth = [ASize screenWidth] - 50;

    NSMutableArray * rows = [NSMutableArray array];
    [rows addObject:@{@"title":@"Гос.номер", @"value":_book.clientKey}];
    [rows addObject:@{@"title":@"Клиент", @"value":[userObject fio]}];
    [rows addObject:@{@"title":@"Телефон", @"value":userObject.username}];
    [rows addObject:@{@"title":@"Марка авто", @"value":userObject.carModel}];
    [rows addObject:@{@"title":@"Тип авто", @"value":[_book carTypeTitle]}];
    [rows addObject:@{@"title":@"Услуги", @"value":[_book servicesTitles]}];
    [rows addObject:@{@"title":@"Стоимость", @"value":[_book localizedPrice]}];

    CGFloat nexty = statusView.bottom;
    for(NSDictionary *row in rows) {
        TitleValueView *rowView = [[TitleValueView alloc] initWithTitle:[NSString stringWithFormat:@"%@:", row[@"title"]] value:row[@"value"] width:rowWidth];
        rowView.centerX = sv.centerX;
        rowView.y = nexty + 20;
        [sv addSubview:rowView];
        nexty = rowView.bottom;
    }

    if(![_book isRejected] && ![_book isFinished] && ![_book isNoCome])
    {
        __weak AdminBookViewController *wSelf = self;
        editButton = [[AAButton alloc] initWithWidth:140 onTap:^(UIView *_self) {
            [wSelf editTapped];
        }];
        [editButton commonStyleButtonWithTitle:@"Изменить"];
        [editButton setTitleFont:[UIFont robotoRegular:18]];
        editButton.centerX = self.view.centerX;
        editButton.y = nexty + 30;
        editButton.height = 40;
        [sv addSubview:editButton];

        [sv setContentSizeHeight:editButton.bottom + 20];
    }
    else
    {
        [sv setContentSizeHeight:nexty + 20];
    }
}

-(void)configUI
{
    [super configUI];
    [self setBackButtonInNavigation];

    [self setBlueBackground];
    [self setNavigationTitle:[_book clientKey]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end