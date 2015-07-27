//
//  UIView+Tools.m
//  PMP
//
//

#import "UIView+Tools.h"
#import <QuartzCore/QuartzCore.h>

CGPoint RoundPoint(CGPoint p) {
    return CGPointMake(roundf(p.x), roundf(p.y));
}

CGSize RoundSize(CGSize s) {
    return CGSizeMake(roundf(s.width), roundf(s.height));
}

CGRect RoundRect(CGRect r) {
    return CGRectMake(roundf(r.origin.x), roundf(r.origin.y), roundf(r.size.width), roundf(r.size.height));
}


#pragma mark -
#pragma mark UIView (Attributes)
@implementation UIView (Tools)

- (void)setTop:(CGFloat)t {
	self.frame = CGRectMake(self.left, t, self.width, self.height);
}
- (CGFloat)top {
	return self.frame.origin.y;
}
- (void)setBottom:(CGFloat)b {
	self.frame = CGRectMake(self.left,b-self.height,self.width,self.height);
}
- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}
- (void)setLeft:(CGFloat)l {
	self.frame = CGRectMake(l,self.top,self.width,self.height);
}
- (CGFloat)left {
	return self.frame.origin.x;
}
- (void)setRight:(CGFloat)r {
	self.frame = CGRectMake(r-self.width,self.top,self.width,self.height);
}
- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}
- (void)setMiddleX:(CGFloat)middleX {
    self.frame = (CGRectMake(middleX - self.width / 2, self.top, self.width, self.height));
}
- (CGFloat)middleX {
    return self.frame.origin.x + roundf(self.frame.size.width / 2);
}
- (void)setMiddleY:(CGFloat)middleY {
    self.frame = (CGRectMake(self.left, middleY - self.height / 2, self.width, self.height));
}
- (CGFloat)middleY {
    return self.frame.origin.y + roundf(self.frame.size.height / 2);
}
- (void)setWidth:(CGFloat)w {
	self.frame = (CGRectMake(self.left, self.top, w, self.height));
}
- (CGFloat)width {
	return self.frame.size.width;
}
- (void)setHeight:(CGFloat)h {
	self.frame = CGRectMake(self.left, self.top, self.width, h);
}
- (CGFloat)height {
	return self.frame.size.height;
}


- (CGPoint)boundsCenter {
    return CGPointMake(roundf(self.width / 2.0), roundf(self.height / 2.0));
}
- (void)setLeftTopPoint:(CGPoint)leftTopPoint {
    self.frame = CGRectMake(leftTopPoint.x, leftTopPoint.y, self.width, self.height);
}
- (CGPoint)leftTopPoint {
    return CGPointMake(self.frame.origin.x, self.frame.origin.y);
}

- (BOOL)isOnWindow {
    return nil != [self window];
}

- (void)removeAllSubviews {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}

- (void)normalize {
    self.layer.cornerRadius = 0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0;
}

- (void)circlize {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.width / 2;
}

- (void)addTestBorderLine {
    [self addTestBorderLineWithColor:[UIColor whiteColor]];
}

- (void)addTestBorderLineWithColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 2;
}

- (void)pass {
    
}


@end




#pragma mark -
#pragma mark UIView (ViewHiarachy)
@implementation UIView (TViewHiarachy)
- (UIViewController*)viewController {
	for (UIView* next = [self superview]; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)nextResponder;
		}
	}
	return nil;
}

@end


#pragma mark -
#pragma mark UIView (Touch)
@implementation UIView (TTouch)

- (void)addTarget:(id)target tapAction:(SEL)action {
    self.userInteractionEnabled = YES;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:gesture];
}


@end

@implementation UIView(TAutoresizing)

+ (UIViewAutoresizing)fullfillAutoresizing {
    return UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)fullfillPrarentView {
    self.autoresizingMask = [UIView fullfillAutoresizing];
}

@end

@implementation UIView(UIView)

- (void)addMaskLayerWithImageName:(NSString *)imageName {
    [self addMaskLayerWithImage:[UIImage imageNamed:imageName]];
}

- (void)addMaskLayerWithImage:(UIImage *)image {
    CALayer *maskLayer = [[CALayer alloc] init];
    maskLayer.contents = (id)image.CGImage;
    maskLayer.frame = (CGRect){CGPointMake(0, 0), image.size};
    self.layer.mask = maskLayer;
}

- (void)addMaskImageViewWithImageName:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:imageName];
    [imageView fullfillPrarentView];
    [self addSubview:imageView];
}


@end


