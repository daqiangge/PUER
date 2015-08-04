//
//  LQDataBackupData.m
//  PUER
//
//  Created by admin on 15/6/2.
//  Copyright (c) 2015年 com.dieshang.PUER. All rights reserved.
//

#import "LQDataBackupData.h"

@implementation LQDataBackupData
+ (NSDictionary *)objectClassInArray
{
    return @{ @"tableitems" : @"LQDataBackupTableItems",
              @"procitems" : @"LQDataBackupTableItems",
              @"viewitems" : @"LQDataBackupTableItems",
              @"funitems" : @"LQDataBackupTableItems",
              @"triggeritems" : @"LQDataBackupTableItems",
              @"traninfoitems" : @"LQDataMaintenanceTraninfoItems",
              @"dbitems" : @"LQDataMaintenanceDbItems"};
}

- (void)setSqltext:(NSString *)sqltext
{
    _sqltext = [[NSString alloc] ASCIIString:sqltext];
}

@end
