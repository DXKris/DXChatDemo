//
//  AppDelegate.m
//  ChatDemo
//
//  Created by Xu Du on 2018/8/15.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "AppDelegate.h"

/**
 账号:
 4028808563ce66080163d409dd4a009f 5db0cbf19f10b759 wtl
 402880855d2fd9cc015d3a09fe320096 1714c47882a317c8 liuyuan
 40288581653cab8201653cc96f3a0039 65eda3bb2e4805c1 yy1
 40288581653cab8201653cc913780031 0bfc6c838923c4ed xx1
 */

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[DXChatClient share].loginManger loginWithUsername:@"yy1" password:@"65eda3bb2e4805c1" clientId:@"40288581653cab8201653cc96f3a0039" complete:^(NSError *error) {
        
//        DXChatMessage *message = [DXChatMessage messageWithContent:@"123" sessionId:@"40288581653cab8201653cc913780031" contentType:DXChatMessageTypeText chatRoomType:DXChatRoomTypeSingle];
//        
//        [[DXChatClient share].sessionManager insertMessage:message];
//        [[DXChatClient share].messageManager sendMessage:message];
        
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
