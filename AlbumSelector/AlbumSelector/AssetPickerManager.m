//
//  AssetPickerManager.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/27.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "AssetPickerManager.h"
#import "AssetCollectionViewController.h"
@interface AssetPickerManager()
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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 2;
    CGFloat itemHeight = (CGRectGetWidth([UIScreen mainScreen].bounds) - margin * 4) / 4;
    layout.itemSize = CGSizeMake(itemHeight, itemHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 2, 2);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    AssetCollectionViewController *vc = [[AssetCollectionViewController alloc] initWithCollectionViewLayout:layout];
    [controller.navigationController pushViewController:vc animated:YES];
}


@end
