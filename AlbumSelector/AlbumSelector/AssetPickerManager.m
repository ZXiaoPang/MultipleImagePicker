//
//  AssetPickerManager.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/27.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "AssetPickerManager.h"
#import "AlbumListController.h"
@interface AssetPickerManager()
@property (nonatomic,strong) AlbumListController *albumCtr;
@end
@implementation AssetPickerManager
static AssetPickerManager *manager;

+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager)
        {
            manager = [[AssetPickerManager alloc] init];
            manager.maxSelectCount = 9;
        }
    });
    return manager;
}

- (void)pushToAlbumListWithController:(UIViewController *)controller {
    AlbumListController *albumCtr = [[AlbumListController alloc] init];
    [controller.navigationController pushViewController:albumCtr animated:YES];
}

- (AlbumListController *)albumCtr {
    if (!_albumCtr) {
        _albumCtr = [[AlbumListController alloc] init];
    }
    return _albumCtr;
}

@end
