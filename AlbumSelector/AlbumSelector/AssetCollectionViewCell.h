//
//  AssetCollectionViewCell.h
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/26.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^didSelectedImage)(UIImage *image);

@interface AssetCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy) didSelectedImage selectImageHandler;
@property (nonatomic, strong) NSString *representedAssetIdentifier;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic, strong) UIImage *livePhotoBadgeImage;
@property (nonatomic,assign) BOOL isChooseed;
@end

NS_ASSUME_NONNULL_END
