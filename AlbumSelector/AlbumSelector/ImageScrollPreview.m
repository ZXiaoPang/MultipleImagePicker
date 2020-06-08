//
//  ImageScrollPreview.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/29.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "ImageScrollPreview.h"
@interface ImageScrollPreview()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) CGRect rect;
@end
@implementation ImageScrollPreview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initImageView];
        self.maximumZoomScale = .5;
        self.maximumZoomScale = 2;
        self.rect = frame;
    }
    return self;
}

- (void)initImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePreview)];
    [self addGestureRecognizer:tapGes];
}

- (void)removePreview {
    [UIView animateWithDuration:.3 animations:^{
        self.frame = self.rect;
        self.imageView.frame = self.bounds;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = _image;
}

- (void)showImagePreview {
    [UIView animateWithDuration:.3 animations:^{
        self.frame = [UIScreen mainScreen].bounds;
        self.imageView.frame = [UIScreen mainScreen].bounds;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
