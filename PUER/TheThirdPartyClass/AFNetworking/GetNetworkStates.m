//
//  GetNetworkStates.m
//  检测当前网络环境
//
//  Created by 奥盟科技 on 14-9-29.
//  Copyright (c) 2014年 LiuChunXia. All rights reserved.
//

#import "GetNetworkStates.h"

@implementation GetNetworkStates
+ (BOOL)getNetWorkStates{
    
    UIApplication *app=[UIApplication sharedApplication];
    NSArray *children=[[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state=@"";
    int netType=0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            netType=[[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (netType) {
                case 0:
                {
//                    NSLog(@"----当前无网络----");
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常请,检查你的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alter show];
                    return NO;
                }
                    break;
                case 1:
                    state=@"2G";break;
                case 2:
                    state=@"3G";break;
                case 3:
                    state=@"4G";break;
                case 5:
                    state=@"WIFI";break;
                    
                default:
                    break;
            }
        }
    }
    
    return YES;
}
@end
