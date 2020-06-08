//
//  AlbumListController.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/25.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "AlbumListController.h"
#import <Photos/Photos.h>
#import "AssetCollectionViewController.h"
@interface AlbumListController ()
typedef void(^completion)(BOOL isOpera, NSMutableArray *array);
@property (nonatomic,strong) NSMutableArray<PHAssetCollection *> *albums;
@end
static NSString * const reuseIdentifier = @"AlbumNameCell";

@implementation AlbumListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    typeof(self) __weak weakSelf = self;
    [self requestCollectionWithHandler:^(BOOL isOpera, NSMutableArray *array) {
        weakSelf.albums = array;
        [weakSelf.tableView reloadData];
    }];
}

- (NSMutableArray<PHAssetCollection *> *)albums {
    if (!_albums) {
        self.albums = [NSMutableArray array];
    }
    return _albums;
}

- (void)requestCollectionWithHandler:(completion)handler {
    __block completion operation = handler;
    
    if ([self checkAlbumAuthorization]) {
        __block NSMutableArray *array1 = [NSMutableArray new];
        PHFetchResult *result1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        [result1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                [array1 addObject:obj];
            }
        }];
        
        __block NSMutableArray *array2 = [NSMutableArray new];
        PHFetchResult *result2 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        [result2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                [array2 addObject:obj];
            }
        }];
        
        [array1 addObjectsFromArray:array2];
        if (operation) {
            dispatch_async(dispatch_get_main_queue(), ^{
                operation(YES, array1);
            });
        }
        
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self requestCollectionWithHandler:operation];
            }
        }];
    }
}

- (BOOL)checkAlbumAuthorization {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    //读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusNotDetermined){
        return NO;
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = self.albums[indexPath.row].localizedTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 2;
    CGFloat itemHeight = (self.view.frame.size.width - margin * 4) / 4;
    layout.itemSize = CGSizeMake(itemHeight, itemHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 2, 2);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    AssetCollectionViewController *vc = [[AssetCollectionViewController alloc] initWithCollectionViewLayout:layout];
    vc.assetCollection = self.albums[indexPath.row];
    vc.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.albums[indexPath.row] options:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)dealloc {
    NSLog(@"%@", [self class]);
}
@end
