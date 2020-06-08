//
//  AppDelegate.h
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/21.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

