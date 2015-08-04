//
//  AppDelegate.m
//  PUER
//
//  Created by admin on 14-8-13.
//  Copyright (c) 2014年 com.dieshang.PUER. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LQLockWindow.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LQCoverWindow.h"

//用于判断指纹锁的出现，每次点击指纹锁取消的时候都会调用applicationDidBecomeActive，为了防止这个方法无限调用指纹锁
static BOOL fingerprint = YES;

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];;
    
    //    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getNetWorkStates) userInfo:nil repeats:YES];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    //输出当前的分辨率
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSLog(@"宽%f*高%f",SCREEN_WIDTH*scale_screen,SCREEN_HEIGHT*scale_screen);
    
//    NSString *homeDir = NSHomeDirectory();
//    NSLog(@"%@",homeDir);
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    
    //如果设置了手势则显示手势界面
    BOOL lockSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch"];
    BOOL loginsuccess = [[NSUserDefaults standardUserDefaults] boolForKey:@"loginsuccess"];
    
    if (lockSwitch)
    {
        if (loginsuccess)
        {
            // 手势解锁相关
            NSString* pswd = [LLLockPassword loadLockPassword];
            if (pswd)
            {
                [[LQLockWindow shareInstance] show];
            }
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    fingerprint = YES;
    
    BOOL lockSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch"];
    BOOL loginsuccess = [[NSUserDefaults standardUserDefaults] boolForKey:@"loginsuccess"];
    
    if (lockSwitch)
    {
        if (loginsuccess)
        {
            // 手势解锁相关
            NSString* pswd = [LLLockPassword loadLockPassword];
            if (pswd)
            {
                [[LQLockWindow shareInstance] show];
            }
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    BOOL fingerprintSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"fingerprintSwitch"];
    BOOL lockSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch"];
    BOOL loginsuccess = [[NSUserDefaults standardUserDefaults] boolForKey:@"loginsuccess"];
    
    if (lockSwitch)
    {
        if (loginsuccess)
        {
            if (fingerprintSwitch && fingerprint)
            {
                [self touchID];
            }
        }
    }
}

#pragma mark - 指纹验证
- (void)touchID
{
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"";
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过验证指纹登陆PUER" reply:
     ^(BOOL success, NSError *authenticationError) {
         if (success) {
             NSLog(@"验证成功");
             [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_DidBecomeActive" object:nil];
         } else {
             NSLog(@"验证失败%@",authenticationError);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_DidClose" object:nil];
         }
     }];
    
    fingerprint = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    
    //cookie清除
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    NSString *lock = [[NSUserDefaults standardUserDefaults] valueForKey:@"lock"];
    if (lock == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"lockSwitch"];
    }
    
    //删除关于的信息
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ContentViewController"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Author"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Tel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Bottom"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PUER" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PUER.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
