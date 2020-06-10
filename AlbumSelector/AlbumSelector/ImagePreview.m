//
//  ImageScrollPreview.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/29.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "ImagePreview.h"
@interface ImagePreview()
@property (nonatomic,strong) UIImageView *imageView;
@end
@implementation ImagePreview

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePreview)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)removePreview {
    [UIView animateWithDuration:.3 animations:^{
        self.imageView.frame = self.imageFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = _image;
}

- (void)showImagePreview {
    [UIView animateWithDuration:.3 animations:^{
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.frame = [UIScreen mainScreen].bounds;
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (void)setImageFrame:(CGRect)imageFrame {
    _imageFrame = imageFrame;
    self.imageView.frame = imageFrame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
