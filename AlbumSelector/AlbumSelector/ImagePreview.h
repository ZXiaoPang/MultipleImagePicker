//
//  ImageScrollPreview.h
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/29.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagePreview : UIView
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) CGRect imageFrame;
- (void)showImagePreview;
@end

NS_ASSUME_NONNULL_END
