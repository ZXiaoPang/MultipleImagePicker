//
//  ImageAssetManager.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/6/11.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "ImageAssetManager.h"
#import <UIKit/UIKit.h>
@interface ImageAssetManager()
@property (nonatomic,strong) PHCachingImageManager *cachingImageManager;
@end
@implementation ImageAssetManager
static ImageAssetManager *manager;

+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager)
        {
            manager = [[ImageAssetManager alloc] init];
        }
    });
    return manager;
}


/// 获取所有非空相册
/// @param handler 回调所有相册和相册数据
- (void)requestCollectionWithHandler:(allAlbumsPickerComplete)handler {
    __block allAlbumsPickerComplete complete = handler;
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    if ([self checkAlbumAuthorization]) {
        __block NSMutableArray *album = [NSMutableArray new];
        __block NSMutableArray *result = [NSMutableArray new];
        PHFetchResult *myPhotoResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
        PHFetchResult *smartResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchResult *topLevelUserResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        PHFetchResult *syncedResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        PHFetchResult *sharedResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
        [myPhotoResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *collection = obj;
                if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
                    if (assetResult.count > 0) {
                        [album addObject:obj];
                        [result addObject:assetResult];
                    }
                }
            }
        }];
        [smartResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *collection = obj;
                if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
                    if (assetResult.count > 0) {
                        [album addObject:obj];
                        [result addObject:assetResult];
                    }
                }
            }
        }];
        [topLevelUserResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *collection = obj;
                if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
                    if (assetResult.count > 0) {
                        [album addObject:obj];
                        [result addObject:assetResult];
                    }
                }
            }
        }];
        [syncedResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj isKindOfClass:[PHAssetCollection class]]) {
                   PHAssetCollection *collection = obj;
                   if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos
                       && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden
                       && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                       PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
                       if (assetResult.count > 0) {
                           [album addObject:obj];
                           [result addObject:assetResult];
                       }
                   }
               }
        }];
        [sharedResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj isKindOfClass:[PHAssetCollection class]]) {
                   PHAssetCollection *collection = obj;
                   if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos
                       && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden
                       && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                       PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
                       if (assetResult.count > 0) {
                           [album addObject:obj];
                           [result addObject:assetResult];
                       }
                   }
               }
        }];
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(album,result);
            });
        }
        
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self requestCollectionWithHandler:complete];
            }
        }];
    }
}


/// 首次获取最近相册
/// @param handler 回调图片数组
- (void)getRecentlyAlbumWithHandler:(recentlyAlbumComplete)handler {
    __block recentlyAlbumComplete complete = handler;
    if (![self checkAlbumAuthorization]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self getRecentlyAlbumWithHandler:complete];
            }
        }];
        return;
    }
    __block PHFetchResult *result;
    __block PHAssetCollection *assetCollection;
    __block NSMutableArray *imageDataSource = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *recentResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [recentResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *collection = obj;
        if ([collection isKindOfClass:[PHAssetCollection class]] && collection.estimatedAssetCount > 0) {
            if ([self isCameraRollAlbum:collection]) {
                assetCollection = collection;
                result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                *stop = YES;
            }
        }
    }];
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.mediaType == PHAssetMediaTypeImage) {
            [imageDataSource addObject:obj];
        }
    }];
    
    if (complete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(imageDataSource, assetCollection.localizedTitle);
        });
    }
}


/// 获取指定相册数据
/// @param result 相册数据
/// @param collection 相册
/// @param handler 回调照片数组
- (void)getAlbumWithResult:(PHFetchResult *)result Collection:(PHAssetCollection *)collection andHandler:(recentlyAlbumComplete)handler {
    __block recentlyAlbumComplete complete = handler;
    if (![self checkAlbumAuthorization]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self getAlbumWithResult:result Collection:collection andHandler:complete];
            }
        }];
        return;
    }
    __block NSMutableArray *imageDataSource = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.mediaType == PHAssetMediaTypeImage) {
            [imageDataSource addObject:obj];
        }
    }];
    
    if (complete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(imageDataSource, collection.localizedTitle);
        });
    }
}

- (void)getThumbnailWithAsset:(PHAsset *)asset andSize:(CGSize)size thumbnailComplete:(imageCatchingComplete)handler {
    __block imageCatchingComplete complete = handler;
    PHImageRequestOptions *requestOption = [[PHImageRequestOptions alloc] init];
    requestOption.resizeMode = PHImageRequestOptionsResizeModeExact;
    [self.cachingImageManager requestImageForAsset:asset
                             targetSize:size
                            contentMode:PHImageContentModeAspectFill
                                options:requestOption
                          resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            complete(result);
        });
    }];
    
}

- (void)getOriginalImageWithAsset:(PHAsset *)asset andSize:(CGSize)size thumbnailComplete:(imageCatchingComplete)handler {
    __block imageCatchingComplete complete = handler;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    [self.cachingImageManager requestImageForAsset:asset
                             targetSize:size
                            contentMode:PHImageContentModeAspectFill
                                options:option
                          resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            complete(result);
        
    }];
}

- (BOOL)isCameraRollAlbum:(PHAssetCollection *)metadata {
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    } else if (versionStr.length <= 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    // IOS 8.0.0 ~ 8.0.2系统，拍照后的图片会保存在最近添加中
    if (version >= 800 && version <= 802) {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded;
    } else {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
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

- (PHCachingImageManager *)cachingImageManager {
    if (!_cachingImageManager) {
        _cachingImageManager = [[PHCachingImageManager alloc] init];
    }
    return _cachingImageManager;
}
@end
