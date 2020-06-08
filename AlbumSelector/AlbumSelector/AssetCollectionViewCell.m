//
//  AssetCollectionViewCell.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/26.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "AssetCollectionViewCell.h"
@interface AssetCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *livePhotoBadgeImageView;
@property (nonatomic, strong) UIButton *chooseImageBtn;
@end

@implementation AssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    _livePhotoBadgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28.f, 28.f)];
    [self.contentView addSubview:_livePhotoBadgeImageView];
    
    CGFloat itemW = self.frame.size.width;
    _chooseImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(itemW - 38, 10, 28, 28)];
    [_chooseImageBtn setBackgroundImage:[UIImage imageNamed:@"unselected_48"] forState:UIControlStateNormal];
    [_chooseImageBtn addTarget:self action:@selector(didChooseImage) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_chooseImageBtn];
}

- (void)didChooseImage {
    self.selectImageHandler(_image);
}

- (void)setIsChooseed:(BOOL)isChooseed {
    _isChooseed = isChooseed;
    [_chooseImageBtn setBackgroundImage:[UIImage imageNamed:_isChooseed ? @"selected_48" : @"unselected_48"] forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)setLivePhotoBadgeImage:(UIImage *)livePhotoBadgeImage{
    _livePhotoBadgeImage = livePhotoBadgeImage;
    _livePhotoBadgeImageView.image = livePhotoBadgeImage;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    _imageView.image = nil;
    _livePhotoBadgeImageView.image = nil;
}

@end
