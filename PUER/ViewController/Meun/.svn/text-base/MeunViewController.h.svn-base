//
//  MeunViewController.h
//  PUER
//
//  Created by admin on 14-8-14.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@class  CustomStatueBar;

@interface MeunViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{    
    CustomStatueBar *statueBar;
}

@property (nonatomic,retain) MainViewController *mainView;

@property int heartbeatPacketsNum;//心跳包的第几次请求

@property (nonatomic,retain) MBProgressHUD *restartTheServiceHUD;
@property (nonatomic,retain) MBProgressHUD *restartTheApplicationHUD;

@property (nonatomic,retain) NSString *platformFirstdatetime;//平台重启时间

@property BOOL msgAlterShow;//判断是否展示了广播消息
@property (nonatomic,retain) NSMutableDictionary *msgDic;
@property BOOL logOut;//判断是否退出登陆了
@property int clientTag;//区分设备获取广播的唯一标识

@end
