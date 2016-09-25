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
#import "CenterTitle.h"
#import "NSString+Ext.h"
#import "CarwashComplex.h"

@interface AdminBookViewController ()
@end

@implementation AdminBookViewController {
    UserObject *userObject;
    M13BadgeView *statusView;
    AAButton *editButton;
    
    NSTimer *timer;
    NSDate *waitingDate;
    CenterTitle *timerLabel;
    
    CenterTitle *secondBlockTitle;
    CenterTitle *nameLabel;
    CenterTitle *carLabel;
    CenterTitle *serviceLabel;
    CenterTitle *dateLabel;
    AAButton *phoneButton;
    
    CGFloat yPosition;
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

- (void)telTapped
{
    NSString *tel = userObject.username;
    if(tel) {
        [UIActionSheet showInView:self.view withTitle:@"Позвонить?" cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@[tel] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if(buttonIndex != actionSheet.cancelButtonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [tel phoneNumberValidForCall]]]];
            }
        }];
    }
}

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

#pragma mark - Timer helpers

- (void)updateBookStatusView {
    
    for (UIView *view in sv.subviews){
        [view removeFromSuperview];
    }
    [self buildUI];
    
//    if(statusView) {
//        [statusView setText:[_book localizedStatus]];
//        [statusView setBadgeBackgroundColor:[UIColor carwashBookStatusColor:_book.status]];
//        statusView.centerX = sv.middleX;
//    }
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval - 6*60*60;
    if (ti < 0){
        NSInteger seconds = abs(ti)  % 60;
        NSInteger minutes = (abs(ti) / 60) % 60;
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
    }
    [self endTimer];
    return @"00:00";
}

- (void)updateValueTimerLabel {
    NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:waitingDate];
    timerLabel.text = [self stringFromTimeInterval:diff];
}

- (void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(updateValueTimerLabel)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)endTimer {
    [timer invalidate];
    timer = nil;
}

#pragma mark - ConfigUI

- (void)buildUI
{
    CGFloat rowsSpacing = 10;
    CGFloat rowWidth = [ASize screenWidth] - 2*rowsSpacing;
    yPosition = 10;
    
    if ([_book isPending]){
        CenterTitle *subtitleLabel = [[CenterTitle alloc] initWithTitle:@"Необходимо подтвердить бронь в течении" width:rowWidth];
        [subtitleLabel sizeToFit];
        subtitleLabel.centerX = sv.centerX;
        subtitleLabel.y = yPosition;
        [sv addSubview:subtitleLabel];
        yPosition = subtitleLabel.bottom;
        
        waitingDate = [[_book tsDate] dateByAddingTimeInterval:15*60];
        NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:waitingDate];
        timerLabel = [[CenterTitle alloc] initWithTitle:[self stringFromTimeInterval:diff] width:rowWidth];
        timerLabel.font = [UIFont robotoRegular:18];
        [timerLabel sizeToFit];
        timerLabel.centerX = sv.centerX;
        timerLabel.y = yPosition + rowsSpacing;
        [sv addSubview:timerLabel];
        yPosition = timerLabel.bottom;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition + rowsSpacing, rowWidth, 0.5)];
        [line setBackgroundColor:[UIColor whiteColor]];
        line.alpha = 0.2;
        line.centerX = sv.centerX;
        [sv addSubview:line];
        yPosition = line.bottom;
    }
    
    [self buildInfoBlockAfter:yPosition rowWidth:rowWidth rowsSpacing:rowsSpacing];
    
    if ([_book isPending]){
        __weak AdminBookViewController *wSelf = self;
        AAButton *approveButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
            [wSelf approveBook];
        }];
        [approveButton commonStyleButtonWithTitle:@"ПРИНЯТЬ БРОНЬ"];
        [approveButton setTitleFont:[UIFont robotoRegular:18]];
        approveButton.centerX = self.view.centerX;
        approveButton.y = yPosition + 30;
        approveButton.height = 40;
        [sv addSubview:approveButton];
        yPosition = approveButton.bottom;

        AAButton *rejectButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
            [wSelf rejectBook];
        }];
        [rejectButton commonStyleButtonWithTitle:@"ОТМЕНИТЬ БРОНЬ"];
        [rejectButton setTitleFont:[UIFont robotoRegular:18]];
        [rejectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        rejectButton.centerX = self.view.centerX;
        rejectButton.y = yPosition + 30;
        rejectButton.height = 40;
        [sv addSubview:rejectButton];
        yPosition = rejectButton.bottom;
    }
    
    if ([_book isApproved]){
        CarwashComplex *carwash = [CarwashComplex cashedCarwash];
        CenterTitle *subtitleLabel = [[CenterTitle alloc] initWithTitle:[carwash boxNameById:_book.boxId] width:rowWidth];
        [subtitleLabel sizeToFit];
        subtitleLabel.centerX = sv.centerX;
        subtitleLabel.y = yPosition + rowsSpacing;
        [sv addSubview:subtitleLabel];
        yPosition = subtitleLabel.bottom;
                
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition + rowsSpacing, rowWidth, 0.5)];
        [line setBackgroundColor:[UIColor whiteColor]];
        line.alpha = 0.2;
        line.centerX = sv.centerX;
        [sv addSubview:line];
        yPosition = line.bottom;
        
        __weak AdminBookViewController *wSelf = self;
        AAButton *finishButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
            [wSelf finishBook];
        }];
        [finishButton commonStyleButtonWithTitle:@"УСЛУГА ОКАЗАНА"];
        [finishButton setTitleFont:[UIFont robotoRegular:18]];
        finishButton.centerX = self.view.centerX;
        finishButton.y = yPosition + 30;
        finishButton.height = 40;
        [sv addSubview:finishButton];
        yPosition = finishButton.bottom;
        
        AAButton *notComeButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
            [wSelf clientDidNotCome];
        }];
        [notComeButton commonStyleButtonWithTitle:@"КЛИЕНТ НЕ ЯВИЛСЯ"];
        [notComeButton setTitleFont:[UIFont robotoRegular:18]];
        [notComeButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        notComeButton.centerX = self.view.centerX;
        notComeButton.y = yPosition + 30;
        notComeButton.height = 40;
        [sv addSubview:notComeButton];
        yPosition = notComeButton.bottom;
        
        AAButton *rejectButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
            [wSelf rejectBook];
        }];
        [rejectButton commonStyleButtonWithTitle:@"ОТМЕНИТЬ БРОНЬ"];
        [rejectButton setTitleFont:[UIFont robotoRegular:18]];
        [rejectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        rejectButton.centerX = self.view.centerX;
        rejectButton.y = yPosition + 30;
        rejectButton.height = 40;
        [sv addSubview:rejectButton];
        yPosition = rejectButton.bottom;
    }
    
    if ([_book isRejected]){
        CenterTitle *statusLabel = [[CenterTitle alloc] initWithTitle:@"БРОНЬ ОТМЕНЕНА АДМИНИСТРАТОРОМ" width:rowWidth];
        statusLabel.font = [UIFont robotoRegular:14];
        statusLabel.textColor = [UIColor redColor];
        [statusLabel sizeToFit];
        statusLabel.centerX = sv.centerX;
        statusLabel.y = yPosition + 2*rowsSpacing;
        [sv addSubview:statusLabel];
        yPosition = statusLabel.bottom;
    }
    
    if ([_book isCancelled]){
        CenterTitle *statusLabel = [[CenterTitle alloc] initWithTitle:@"БРОНЬ ОТМЕНЕНА КЛИЕНТОМ" width:rowWidth];
        statusLabel.font = [UIFont robotoRegular:14];
        statusLabel.textColor = [UIColor redColor];
        [statusLabel sizeToFit];
        statusLabel.centerX = sv.centerX;
        statusLabel.y = yPosition + 2*rowsSpacing;
        [sv addSubview:statusLabel];
        yPosition = statusLabel.bottom;
    }
    
    if ([_book isFinished]){
        CenterTitle *statusLabel = [[CenterTitle alloc] initWithTitle:@"УСЛУГА ЗАВЕРШЕНА" width:rowWidth];
        statusLabel.font = [UIFont robotoRegular:14];
        statusLabel.textColor = [UIColor greenColor];
        [statusLabel sizeToFit];
        statusLabel.centerX = sv.centerX;
        statusLabel.y = yPosition + 2*rowsSpacing;
        [sv addSubview:statusLabel];
        yPosition = statusLabel.bottom;
    }
    
    if ([_book isNoCome]){
        CenterTitle *statusLabel = [[CenterTitle alloc] initWithTitle:@"КЛИЕНТ НЕ ЯВИЛСЯ" width:rowWidth];
        statusLabel.font = [UIFont robotoRegular:14];
        statusLabel.textColor = [UIColor yellowColor];
        [statusLabel sizeToFit];
        statusLabel.centerX = sv.centerX;
        statusLabel.y = yPosition + 2*rowsSpacing;
        [sv addSubview:statusLabel];
        yPosition = statusLabel.bottom;
    }
    
    [sv setContentSizeHeight:yPosition + 20];
    if ([_book isPending]){
        [self startTimer];
    }
}

- (void)buildInfoBlockAfter : (CGFloat)after rowWidth:(CGFloat)rowWidth rowsSpacing:(CGFloat)rowsSpacing {
    secondBlockTitle = [[CenterTitle alloc] initWithTitle:@"Бронь на имя" width:rowWidth];
    secondBlockTitle.font = [UIFont robotoRegular:18.f];
    [secondBlockTitle sizeToFit];
    secondBlockTitle.centerX = sv.centerX;
    secondBlockTitle.y = after + rowsSpacing;
    [sv addSubview:secondBlockTitle];
    
    nameLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@", [userObject fio]] width:rowWidth];
    [nameLabel sizeToFit];
    nameLabel.centerX = sv.centerX;
    nameLabel.y = secondBlockTitle.bottom + 2*rowsSpacing;
    [sv addSubview:nameLabel];
    
    __weak AdminBookViewController *wSelf = self;
    phoneButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
        [wSelf telTapped];
    }];
    [phoneButton noBorderStyleButtonWithTitle:userObject.username];
    [phoneButton setTitleFont:[UIFont robotoRegular:14]];
    [phoneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    phoneButton.centerX = self.view.centerX;
    phoneButton.y = nameLabel.bottom;
    phoneButton.height = 30;
    [sv addSubview:phoneButton];
    
    carLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", [_book carTypeTitle], [_book localizedCarNumber]] width:rowWidth];
    [carLabel sizeToFit];
    carLabel.centerX = sv.centerX;
    carLabel.y = phoneButton.bottom;
    [sv addSubview:carLabel];
    
    
    serviceLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ за %@", [_book servicesTitles], [_book localizedPrice]] width:rowWidth];
    [serviceLabel sizeToFit];
    serviceLabel.centerX = sv.centerX;
    serviceLabel.y = carLabel.bottom;
    [sv addSubview:serviceLabel];
    
    dateLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ (%@) в %@", [_book localizedDaysAgo], [_book localizedBookDate], [_book localBookTime]] width:rowWidth];
    [dateLabel sizeToFit];
    dateLabel.centerX = sv.centerX;
    dateLabel.y = serviceLabel.bottom + 2*rowsSpacing;
    [sv addSubview:dateLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, dateLabel.bottom + rowsSpacing, rowWidth, 0.5)];
    [line setBackgroundColor:[UIColor whiteColor]];
    line.alpha = 0.2;
    line.centerX = sv.centerX;
    [sv addSubview:line];
    
    yPosition = line.bottom;
}

-(void)configUI
{
    [super configUI];
    [self setBackButtonInNavigation];

    [self setBlueBackground];
    [self setNavigationTitle:[NSString stringWithFormat:@"Бронь %@ в %@", [_book localizedDaysAgo], [_book localBookTime]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end
