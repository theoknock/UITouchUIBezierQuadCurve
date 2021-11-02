//
//  BezierQuadCurveView.h
//  UITouchUIBezierQuadCurve
//
//  Created by Xcode Developer on 11/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BezierQuadCurveView : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIGestureRecognizer *tapGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
