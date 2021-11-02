//
//  BezierQuadCurveView.m
//  UITouchUIBezierQuadCurve
//
//  Created by Xcode Developer on 11/1/21.
//

#import "BezierQuadCurveView.h"
#import "ChangeState.h"

@implementation BezierQuadCurveView {
    
    CGPoint start;
    CGPoint end;
    CGPoint intermediate;
    
    CGRect start_rect;
    CGRect end_rect;
    CGRect intermediate_rect;
    
    //    UIBezierPath * quad_curve;
    
    //    UIBezierPath * startcontrol_point_path;
    //    UIBezierPath * endcontrol_point_path;
    //    UIBezierPath * intermediatecontrol_point_path;
    
    CAShapeLayer * startcontrol_point_path_layer;
    CAShapeLayer * endcontrol_point_path_layer;
    CAShapeLayer * intermediatecontrol_point_path_layer;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

// To-Do: Draw handles for all three control points in blue; change to red when selected

- (void)awakeFromNib {
    [super awakeFromNib];
    
    startcontrol_point_path_layer = [CAShapeLayer new];
    endcontrol_point_path_layer = [CAShapeLayer new];
    intermediatecontrol_point_path_layer = [CAShapeLayer new];
    [self.layer addSublayer:startcontrol_point_path_layer];
    [self.layer addSublayer:endcontrol_point_path_layer];
    [self.layer addSublayer:intermediatecontrol_point_path_layer];
    [startcontrol_point_path_layer setBackgroundColor:[UIColor clearColor].CGColor];
    [endcontrol_point_path_layer setBackgroundColor:[UIColor clearColor].CGColor];
    [intermediatecontrol_point_path_layer setBackgroundColor:[UIColor clearColor].CGColor];
    
    [startcontrol_point_path_layer setBorderWidth:1.0];
    [endcontrol_point_path_layer setBorderWidth:1.0];
    [intermediatecontrol_point_path_layer setBorderWidth:1.0];
    
    [startcontrol_point_path_layer setBorderColor:[UIColor systemYellowColor].CGColor];
    [endcontrol_point_path_layer setBorderColor:[UIColor systemYellowColor].CGColor];
    [intermediatecontrol_point_path_layer setBorderColor:[UIColor systemYellowColor].CGColor];
    
    
    change = 0;
    
    start = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame));
    end = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame));
    intermediate = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self point:start layer:startcontrol_point_path_layer color:[UIColor systemYellowColor]];
    
    [self point:end layer:endcontrol_point_path_layer color:[UIColor systemYellowColor]];
    
    [self point:intermediate layer:intermediatecontrol_point_path_layer color:[UIColor systemYellowColor]];
    
    UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPath];
    [bezier_quad_curve moveToPoint:start];
    [bezier_quad_curve addQuadCurveToPoint:end controlPoint:intermediate];
    [(CAShapeLayer *)self.layer setLineWidth:1.0];
    [(CAShapeLayer *)self.layer setStrokeColor:[UIColor blueColor].CGColor];
    [(CAShapeLayer *)self.layer setPath:bezier_quad_curve.CGPath];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = (UITouch *)touches.anyObject;
    CGPoint circle_location = CGPointMake([touch locationInView:touch.view].x, [touch locationInView:touch.view].y);

    (change == 0) ?
    ^{ start = circle_location; printf("start\n"); }() :
    (change == 1) ?
    ^{ end = circle_location; printf("end\n"); }() :
    ^{ intermediate = circle_location; printf("intermediate\n"); }();
    
    [self point:start layer:startcontrol_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(startcontrol_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
    
    [self point:end layer:endcontrol_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(endcontrol_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
    
    [self point:intermediate layer:intermediatecontrol_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(intermediatecontrol_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
    
    UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPath];
    [bezier_quad_curve moveToPoint:start];
    [bezier_quad_curve addQuadCurveToPoint:end controlPoint:intermediate];
    [(CAShapeLayer *)self.layer setLineWidth:1.0];
    [(CAShapeLayer *)self.layer setStrokeColor:[UIColor blueColor].CGColor];
    [(CAShapeLayer *)self.layer setPath:bezier_quad_curve.CGPath];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = (UITouch *)touches.anyObject;
    CGPoint circle_location = CGPointMake([touch locationInView:touch.view].x, [touch locationInView:touch.view].y);
    
    change = (CGRectContainsPoint(CGPathGetBoundingBox(startcontrol_point_path_layer.path), circle_location)) ? 0 :
    (CGRectContainsPoint(CGPathGetBoundingBox(endcontrol_point_path_layer.path), circle_location)) ? 1 : 2;
    
    if ((CGRectContainsPoint(CGPathGetBoundingBox(startcontrol_point_path_layer.path), circle_location)) || (CGRectContainsPoint(CGPathGetBoundingBox(endcontrol_point_path_layer.path), circle_location)) || (CGRectContainsPoint(CGPathGetBoundingBox(intermediatecontrol_point_path_layer.path), circle_location))) {
        
        [self point:start layer:startcontrol_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(startcontrol_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
        
        [self point:end layer:endcontrol_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(endcontrol_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
        
        [self point:intermediate layer:intermediatecontrol_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(intermediatecontrol_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
    }
}

- (void)point:(CGPoint)point layer:(CAShapeLayer *)layer color:(UIColor *)color {
    [layer setPath:nil];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(point.x, point.y) radius:20.0 startAngle:0 endAngle:M_PI_2 clockwise:TRUE];
    [path addArcWithCenter:CGPointMake(point.x, point.y) radius:20.0 startAngle:M_PI_2 endAngle:M_PI_4 clockwise:TRUE];
    [(CAShapeLayer *)layer setLineWidth:1.0];
    [(CAShapeLayer *)layer setStrokeColor:color.CGColor];
    CGMutablePathRef path_ref = path.CGPath;
    const CGRect rects[] = { CGPathGetBoundingBox(path_ref), CGPathGetPathBoundingBox(path_ref) };
    NSUInteger count = sizeof(rects) / sizeof(CGRect);
    CGPathAddRects(path_ref, NULL, rects, count);
    [(CAShapeLayer *)layer setPath:path.CGPath];
}

@end
