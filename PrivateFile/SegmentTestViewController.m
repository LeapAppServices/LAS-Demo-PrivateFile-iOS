//
//  SegmentTestViewController.m
//  FileTest
//
//  Created by Sun Jin on 15/1/23.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#import "SegmentTestViewController.h"
#import <LAS/LAS.h>

#import <LAS/LASSessionManager.h>
#import "LASPaymentDB+Test.h"
#import <LAS/LASIAPObserver.h>
#import <LAS/LASInstallation+Private.h>

#define GENDER_KEY @"segmenttest.gender"
#define EVENT_COUNT_KEY @"sengemnttest.eventcount"
#define TOTAL_CONSUME_KEY @"segmenttest.totalconsume"

@implementation SegmentTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger gender_index = [[NSUserDefaults standardUserDefaults] integerForKey:GENDER_KEY];
    if (gender_index > 0) {
        self.genderSelector.selectedSegmentIndex = gender_index;
        self.genderSelector.enabled = NO;
        self.ageSelector.selectedSegmentIndex = gender_index;
        self.ageSelector.enabled = NO;
    } else {
        self.genderSelector.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.ageSelector.selectedSegmentIndex = UISegmentedControlNoSegment;
    }
    
    self.totalEventLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:EVENT_COUNT_KEY] stringValue];
    
    double consume = [[NSUserDefaults standardUserDefaults] doubleForKey:TOTAL_CONSUME_KEY];
    double actureValue = consume/1000000;
    self.totalConsumeLable.text = [@(actureValue) stringValue];
}

- (IBAction)updateInstallation:(id)sender {
    LASInstallation *curInstall = [LASInstallation currentInstallation];
    if (NO == [curInstall[@"appVersion"] isEqualToString:@"1"]) {
        curInstall[@"appVersion"] = @"1";
    }
    if (NO == [curInstall[@"national"] isEqualToString:@"cn"]) {
        curInstall[@"locale"] = @"cn";
    }
    if (NO == [curInstall[@"language"] isEqualToString:@"zh"]) {
        curInstall[@"language"] = @"zh";
    }
    [LASDataManager saveObjectInBackground:curInstall block:nil];
}


- (IBAction)sendEventAction:(id)sender {
    [LASAnalytics trackEvent:@"event1" dimensions:@{@"foo" : @"bar"}];
    
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:EVENT_COUNT_KEY];
    count ++;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:EVENT_COUNT_KEY];
    
    self.totalEventLabel.text = [@(count) stringValue];
}

- (IBAction)genderValueChanged:(id)sender {
    if (self.genderSelector.selectedSegmentIndex == 0) {
        // female, age = 31
        LASInstallation *curInstall = [LASInstallation currentInstallation];
        curInstall[@"gender"] = @"female";
        curInstall[@"age"] = @31;
        [LASDataManager saveObjectInBackground:curInstall block:nil];
        
        self.ageSelector.selectedSegmentIndex = 0;
        
        self.genderSelector.enabled = NO;
        self.ageSelector.enabled = NO;
        
    } else if (self.genderSelector.selectedSegmentIndex == 1) {
        // male, age = -1
        LASInstallation *curInstall = [LASInstallation currentInstallation];
        curInstall[@"gender"] = @"male";
        curInstall[@"age"] = @(-1);
        [LASDataManager saveObjectInBackground:curInstall block:nil];
        
        self.ageSelector.selectedSegmentIndex = 1;
        
        self.genderSelector.enabled = NO;
        self.ageSelector.enabled = NO;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.genderSelector.selectedSegmentIndex forKey:GENDER_KEY];
}

- (IBAction)buy099:(id)sender {
    NSDictionary *dict = @{
                           @"productId": @"com.apponyxlimited.repost.handofcoins",
                           @"national": @"cn",
                           @"description": @"100 coins = $0.99",
                           @"channel": @"app store",
                           @"priceCurrency": @"CNY",
                           @"appId": [LAS applicationId],
                           @"type": @"none",
                           @"os": @"ios",
                           @"title": @"Hand of Coins",
                           @"installationId": [LASInstallation currentInstallation].installationId,
                           @"userCreateTime": @((long)[[LASInstallation currentInstallation].createdAt timeIntervalSince1970]),
                           @"paySource": @"app store",
                           @"sessionId": [LASSessionManager currentSession].sessionId,
                           @"language": @"zh-Hans",
                           @"priceAmount": @6000000,
                           @"status": @"0",
                           @"sdkVersion": LAS_VERSION
                           };
    [LASPaymentDB insertPaymentDictionary:dict];
    
    // success
    NSMutableDictionary *dict_m = [dict mutableCopy];
    dict_m[@"status"] = @"3";
    [LASPaymentDB insertPaymentDictionary:dict_m];
    
    [[LASIAPObserver sharedInstance] tryToSendAdTracking];
    
    double consume = [[NSUserDefaults standardUserDefaults] doubleForKey:TOTAL_CONSUME_KEY];
    consume += [dict_m[@"priceAmount"] doubleValue];
    [[NSUserDefaults standardUserDefaults] setDouble:consume forKey:TOTAL_CONSUME_KEY];
    
    double actureValue = consume/1000000.f;
    self.totalConsumeLable.text = [@(actureValue) stringValue];
    
}
- (IBAction)buy199:(id)sender {
}
- (IBAction)buy299:(id)sender {
}
- (IBAction)buy999:(id)sender {
    NSDictionary *dict = @{
                           @"productId": @"com.apponyxlimited.repost.bagofcoins",
                           @"national": @"cn",
                           @"description": @"3000 coins = $9.99",
                           @"channel": @"app store",
                           @"priceCurrency": @"CNY",
                           @"appId": [LAS applicationId],
                           @"type": @"none",
                           @"os": @"ios",
                           @"title": @"Bag of Coins",
                           @"installationId": [LASInstallation currentInstallation].installationId,
                           @"userCreateTime": @((long)[[LASInstallation currentInstallation].createdAt timeIntervalSince1970]),
                           @"paySource": @"app store",
                           @"sessionId": [LASSessionManager currentSession].sessionId,
                           @"language": @"zh-Hans",
                           @"priceAmount": @68000000,
                           @"status": @"0",
                           @"sdkVersion": LAS_VERSION
                           };
    [LASPaymentDB insertPaymentDictionary:dict];
    
    // success
    NSMutableDictionary *dict_m = [dict mutableCopy];
    dict_m[@"status"] = @"3";
    [LASPaymentDB insertPaymentDictionary:dict_m];
    
    [[LASIAPObserver sharedInstance] tryToSendAdTracking];
    
    double consume = [[NSUserDefaults standardUserDefaults] doubleForKey:TOTAL_CONSUME_KEY];
    consume += [dict_m[@"priceAmount"] doubleValue];
    [[NSUserDefaults standardUserDefaults] setDouble:consume forKey:TOTAL_CONSUME_KEY];
    
    double actureValue = consume/1000000.f;
    self.totalConsumeLable.text = [@(actureValue) stringValue];
}



- (IBAction)paymentsSimulator:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self sendPaymentData];
    });
}

- (void)sendPaymentData {
    
    NSMutableArray *allDatas = [NSMutableArray arrayWithCapacity:100];
    
    // appid uuid installationid usercreateTime  sessionid status userid
    // 1419909174 +- 360000
    
    
    NSString * (^uuid_create)(void) = ^ NSString * {
        return [[[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    };
    
    
    
    LASInstallation * (^installCreate)(NSString *) = ^ LASInstallation * (NSString *installationId) {
        
        LASInstallation *install = [LASInstallation object];
        install.installationId = installationId;
        [install updateAutomaticInfo];
        
        static BOOL complete = NO, success = NO;
        complete = NO; success = NO;
        [LASDataManager saveObjectInBackground:install block:^(BOOL succeeded, NSError *error) {
            complete = YES;
            success = succeeded;
        }];
        
        while ( ! complete) {
            // wait installation saving
        }
        if (success) {
            return install;
        } else {
            return nil;
        }
    };
    
    
    int (^randomStatus)(BOOL) = ^int (BOOL shouldBe3) {
        
        static int status12 = 20, status3 = 100;
        
        if (shouldBe3) {
            status3 --;
            NSLog(@"status in 1/2: %d, 3: %d", status12, status3);
            return 3;
        }
        
        int status = 0;
        int seg = (arc4random() % 1200 < 1000) ? 0 : 1;
        
        while (status == 0 && (status12 > 0 || status3 > 0)) {
            
            if (seg == 0) {
                if (status3 > 0) {
                    /// *************************** ///
                    /// 完成 100 条 status = 3 的
                    /// *************************** ///
                    status = 3;
                    status3 --;
                } else {
                    seg ++;
                }
            }
            
            if (seg == 1) {
                if (status12 > 0) {
                    // cancel 1, failed 2
                    status = (arc4random() % 1000 < 750) ? 1: 2;
                    
                    status12 --;
                } else {
                    seg = 0;
                }
            }
        }
        
        NSLog(@"status in 1/2: %d, 3: %d", status12, status3);
        
        return status;
    };
    
    
    long (^randomUserCreateTime)(int, long) = ^long (int status, long defaultUserCreateTime) {
        
        if (status != 3)
            return defaultUserCreateTime;
        
        static int createTime_1 = 10, createTime3_7 = 10, createTime7_84 = 50, createTime84_ = 30;
        long userCreateTime = defaultUserCreateTime;
        
        // userCreateTime 模拟
        double ts = [[NSDate date] timeIntervalSince1970];
        long day = 86400;
        
        int segment = arc4random() % 4;
        
        
        while (userCreateTime == defaultUserCreateTime &&
               (createTime_1 > 0 || createTime3_7 > 0 || createTime7_84 > 0 || createTime84_ > 0)
               )
        {
            
            // (ts-usercreateTime*1000)/86400000 <= 1的10条,
            // [ts - d, nan)
            if (segment == 0) {
                if (createTime_1 > 0) {
                    userCreateTime = (long)(ts - day + random() % (10 * day));
                    createTime_1 --;
                } else {
                    segment ++;
                }
            }
            // 3<(ts-usercreateTime*1000)/86400000  <= 7 10条
            // [ts - 7d, ts - 3d)
            if (segment == 1) {
                if (createTime3_7 > 0) {
                    userCreateTime = (long)(ts - 7 * day + random() % (4 * day -1));
                    createTime3_7 --;
                } else {
                    segment ++;
                }
            }
            // 7<(ts-usercreateTime*1000)/86400000  <=84 50条
            // [ts - 84d, ts -7d)
            if (segment == 2) {
                if (createTime7_84 > 0) {
                    userCreateTime = (long)(ts - 84 * day + random() % ((84-7) * day -1));
                    createTime7_84 --;
                } else {
                    segment ++;
                }
            }
            // (ts-usercreateTime*1000)/86400000 > 84 30条
            // (nan, ts - 84d)
            if (segment == 3) {
                if (createTime84_ > 0) {
                    userCreateTime = (long)(ts - 84 * day - (random() % (10 * day)) + 1);
                    createTime84_ --;
                } else {
                    segment = 0;
                }
            }
        }
        
        NSLog(@"createTime _1: %d, 3_7: %d, 7_84: %d, 84_: %d", createTime_1, createTime3_7, createTime7_84, createTime84_);
        
        return userCreateTime;
    };
    
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"paymentTemplete" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *paymentTemplets = data?[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]:nil;
    NSArray *nationalList = paymentTemplets.allKeys;
    
    NSString *appId = [LAS applicationId];
    
    int totalCount = 100, status12 = 0, status3 = 0;
    int hasHistoryPayment = 25, sameUserId = 50;
    
    // 0 start, 1 cancelled, 2 failed, 3 success
    for (NSString *national in nationalList) {
        
        NSArray *tempList = paymentTemplets[national];
        
        NSString *userId = nil, *installationId = nil;
        int installIdRepeatCount = 0;
        BOOL repeatUserId = NO;
        long userCreateTime = 0;
        int status = 0;
        
        int count = totalCount / nationalList.count;
        
        while (count > 0) {
            
            // 随机取一个，保证金额不总是一样的
//            int index = arc4random() % tempList.count;
//            NSMutableDictionary *templete = [tempList[index] mutableCopy];
//            templete[@"appId"] = appId;
//            templete[@"uuid"] = uuid_create();
//            templete[@"sessionId"] = uuid_create();
//
//            status = randomStatus(installIdRepeatCount > 0 || repeatUserId);
//            if (status == 3) {
//                status3 ++;
//            } else {
//                status12 ++;
//            }
//            
            // 50条historypayment=0，其他的等于1
//            if (installIdRepeatCount > 0 && status == 3) {
//                installIdRepeatCount --;
//                hasHistoryPayment --;
//                
//            } else {
//                // 1. 完成 50 条 historyPayment = 1 的
//                if (hasHistoryPayment > 0 && status == 3) {
//                    
//                    installationId = uuid_create();
//                    LASInstallation *install = installCreate(installationId);
//                    if ( ! install) continue;
//                    
//                    userCreateTime = (long)([install.createdAt timeIntervalSince1970]);
//                    
//                    installIdRepeatCount ++;
//                    
//                } else {
//                    
//                    installationId = uuid_create();
//                    LASInstallation *install = installCreate(installationId);
//                    if ( ! install) continue;
//                    
//                    userCreateTime = (long)([install.createdAt timeIntervalSince1970]);
//                }
//            }
//            
//            
//            userCreateTime = randomUserCreateTime(status, userCreateTime);
//            
//            
            // 50条userid是重复的，其他的不重复
//            if (repeatUserId) {
//                sameUserId --;
//                repeatUserId = (sameUserId > 0) && (BOOL)(arc4random() % 2);
//                
//            } else {
//                userId = uuid_create();
//                repeatUserId = (sameUserId > 0 && status == 3);
//            }
            
            userId = uuid_create();
            installationId = uuid_create();
            LASInstallation *install = installCreate(installationId);
            if (install == nil) {
                continue;
            }
            userCreateTime = (long)([install.createdAt timeIntervalSince1970]);
            status = 3;
            
            int index = (count -1) / 25;
            NSMutableDictionary *templete = [tempList[index] mutableCopy];
            templete[@"appId"] = appId;
            templete[@"uuid"] = uuid_create();
            templete[@"sessionId"] = uuid_create();
            
            templete[@"userId"] = userId;
            templete[@"installationId"] = installationId;
            templete[@"userCreateTime"] = @(userCreateTime);
            
            templete[@"status"] = @"0";
            [allDatas addObject:templete];
            [LASPaymentDB insertPaymentDictionary:templete];
            
            NSMutableDictionary *payCopy = [NSMutableDictionary dictionaryWithDictionary:templete];
            payCopy[@"status"] = [@(status) stringValue];
            payCopy[@"uuid"] = uuid_create();
            [allDatas addObject:payCopy];
            [LASPaymentDB insertPaymentDictionary:payCopy];
            
            count --;
        }
    }
    [[LASIAPObserver sharedInstance] tryToSendAdTracking];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dataPath = [docPath stringByAppendingPathComponent:@"paymentData.json"];
    
    NSData *allPayemntsData = [NSJSONSerialization dataWithJSONObject:allDatas options:kNilOptions error:NULL];
    [allPayemntsData writeToFile:dataPath atomically:YES];
}


@end
