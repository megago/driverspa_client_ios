//
//  BoxSettingsListViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 3/17/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import "BoxSettingsListViewController.h"
#import "User.h"
#import "UIViewController+Ext.h"
#import "SimpleDisclosureCell.h"
#import "AdminApi.h"
#import "Carwash.h"
#import "CarwashComplex.h"
#import "AdminBoxViewController.h"
#import "CarwashApi.h"
#import "BoxSetting.h"
#import "NSArray+ObjectiveSugar.h"
#import "IdTitleObject.h"
#import "CarwashesHelper.h"
#import "UIViewController+NoContent.h"

@interface BoxSettingsListViewController ()
@end

@implementation BoxSettingsListViewController {
    UITableView *list;
    UIView *noContentMessageView;
    NSString *carwashId;
    NSMutableArray *boxSettings;
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

    [self loadCarwashes];
}

- (void)loadCarwashes
{
    [Toast showHudLoading];
    [AdminApi myCarwashes:^(id response) {
        [self onCarwashesLoaded:response];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)onCarwashesLoaded:(id)response
{
    NSArray *carwashes = response;
    if(carwashes.count == 0)
    {
        [self showNoContentMessage:@"У Вас нет автомоек"];
    }
    else
    {
        [self removeNoContentMessageIfExists];
        Carwash *carwash = [carwashes firstObject];
        carwashId = carwash.carwashId;

        [Toast showHudWait];
        [CarwashApi getCarwashDetails:carwashId success:^(id response) {
            boxSettings = [[(CarwashComplex *)response boxSettings] mutableCopy];
            list.hidden = NO;
            [list reloadData];
        } failure:^(NSInteger code, NSString *message) {

        }];
    }
}

- (void)addTapped
{
    [UIActionSheet showInView:self.view
                    withTitle:@"Создание бокса.\nВыберите тип бокса:"
            cancelButtonTitle:@"Отмена"
       destructiveButtonTitle:nil
            otherButtonTitles:[CarwashesHelper carwashBoxTypeTitles]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if(buttonIndex != actionSheet.cancelButtonIndex) {

            IdTitleObject *type = [CarwashesHelper carwashBoxTypes][buttonIndex];

            [Toast showHudWithTitle:@"Создание бокса"];
            [CarwashApi createBoxForCarwash:carwashId bookingType:type.objectId success:^(id response)
            {
                if(response) {
                    [Toast showSuccessToastWithMessage:@"Бокс создан"];
                    [boxSettings addObject:response];
                    [list reloadData];
                }
            } failure:^(NSInteger code, NSString *message)
            {

            }];
        }
    }];
}

#pragma mark -
#pragma mark UITableView

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return boxSettings.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    SimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    [cell setTitle:[NSString stringWithFormat:@"Бокс #%i", indexPath.row + 1]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BoxSetting *boxSetting = boxSettings[indexPath.row];
    if(boxSetting)
    {
        NSMutableArray *types = [NSMutableArray array];
        NSMutableArray *boxTypes = [[CarwashesHelper carwashBoxTypes] mutableCopy];

        [boxTypes eachWithIndex:^(IdTitleObject *type, NSUInteger index) {
            NSString *title = [NSString stringWithFormat:@"%@ %@", ([boxSetting.bookingType isEqualToString:type.objectId] ? @"√" : @" "), type.title];
            [types addObject:title];
        }];

        [UIActionSheet showFromRect:CGRectZero
                             inView:self.view
                           animated:YES
                          withTitle:@"Настройки бокса"
                  cancelButtonTitle:@"Отмена"
             destructiveButtonTitle:@"Удалить бокс"
                  otherButtonTitles:types
                           tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
                {
                    if (buttonIndex != actionSheet.cancelButtonIndex)
                    {
                        if (buttonIndex == actionSheet.destructiveButtonIndex)
                        {
                            // Delete the box
                            [UIAlertView showWithTitle:@"Удалить бокс?" message:@"" cancelButtonTitle:@"Отмена" otherButtonTitles:@[@"Удалить"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
                            {
                                if (buttonIndex != alertView.cancelButtonIndex)
                                {
                                    [Toast showHudWithTitle:@"Удаление"];
                                    [CarwashApi deleteBoxOfCarwash:carwashId boxId:boxSetting.uid success:^(id response) {
                                        [boxSettings removeObject:boxSetting];
                                        [list reloadData];
                                    } failure:^(NSInteger code, NSString *message) {

                                    }];
                                }
                            }];
                        }
                        else
                        {
                            // Set the box type
                            IdTitleObject *type = boxTypes[buttonIndex - 1];

                            [Toast showHudWithTitle:@"Обновление бокса"];
                            [CarwashApi editBoxOfCarwash:carwashId
                                                   boxId:boxSetting.uid
                                             bookingType:type.objectId
                                                 success:^(id response)
                            {
                                boxSetting.bookingType = type.objectId;

                            } failure:^(NSInteger code, NSString *message)
                            {

                            }];
                        }
                    }
                }];
    }
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButton];
    [self setNavigationTitle:@"Настройка боксов"];

    [self createBarButtonAtLeft:NO buttonImage:@"icon-add-outline" target:self selector:@selector(addTapped)];

    CGFloat listY = 64;
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, listY, [ASize screenWidth], [ASize screenHeight] - listY - 44) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundView = [[UIView alloc] init];
    list.backgroundColor = [UIColor clearColor];
    list.separatorColor = [UIColor clearColor];
    list.hidden = YES;
    [self.view addSubview:list];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end