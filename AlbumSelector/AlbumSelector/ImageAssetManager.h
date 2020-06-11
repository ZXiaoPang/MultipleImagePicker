//
//  ImageAssetManager.h
//  AlbumSelector
//
//  Created by hadlinks on 2020/6/11.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

#define ImageManager [ImageAssetManager defaultManager]
typedef void(^allAlbumsPickerComplete)(NSMutableArray *albums, NSMutableArray *results);
typedef void(^recentlyAlbumComplete)(NSMutableArray *images, NSString *albumName);
typedef void(^imageCatchingComplete)(UIImage *image);

@interface ImageAssetManager : NSObject
+(instancetype)defaultManager;
- (void)requestCollectionWithHandler:(allAlbumsPickerComplete)handler;
- (void)getRecentlyAlbumWithHandler:(recentlyAlbumComplete)handler;
- (void)getAlbumWithResult:(PHFetchResult *)result Collection:(PHAssetCollection *)collection andHandler:(recentlyAlbumComplete)handler;
- (void)getThumbnailWithAsset:(PHAsset *)asset andSize:(CGSize)size thumbnailComplete:(imageCatchingComplete)handler;
- (void)getOriginalImageWithAsset:(PHAsset *)asset andSize:(CGSize)size thumbnailComplete:(imageCatchingComplete)handler;
@end

NS_ASSUME_NONNULL_END
