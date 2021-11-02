//
//  BezierQuadCurveView.m
//  UITouchUIBezierQuadCurve
//
//  Created by Xcode Developer on 11/1/21.
//

#import "BezierQuadCurveView.h"
#import "ChangeState.h"

@implementation BezierQuadCurveView {
    
    CGPoint start_point;
    CGPoint end_point;
    CGPoint intermediate_point;
    
    CAShapeLayer * start_control_point_path_layer;
    CAShapeLayer * end_control_point_path_layer;
    CAShapeLayer * intermediate_control_point_path_layer;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

// To-Do: Draw handles for all three control points in blue; change to red when selected

- (void)awakeFromNib {
    [super awakeFromNib];
    
    start_control_point_path_layer = [CAShapeLayer new];
    end_control_point_path_layer = [CAShapeLayer new];
    intermediate_control_point_path_layer = [CAShapeLayer new];
    [self.layer addSublayer:start_control_point_path_layer];
    [self.layer addSublayer:end_control_point_path_layer];
    [self.layer addSublayer:intermediate_control_point_path_layer];
    [start_control_point_path_layer setBackgroundColor:[UIColor clearColor].CGColor];
    [end_control_point_path_layer setBackgroundColor:[UIColor clearColor].CGColor];
    [intermediate_control_point_path_layer setBackgroundColor:[UIColor clearColor].CGColor];
    
    [start_control_point_path_layer setBorderWidth:1.0];
    [end_control_point_path_layer setBorderWidth:1.0];
    [intermediate_control_point_path_layer setBorderWidth:1.0];
    
    [start_control_point_path_layer setBorderColor:[UIColor systemYellowColor].CGColor];
    [end_control_point_path_layer setBorderColor:[UIColor systemYellowColor].CGColor];
    [intermediate_control_point_path_layer setBorderColor:[UIColor systemYellowColor].CGColor];
    
    
    change = 0;
    
    start_point = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame));
    end_point = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame));
    intermediate_point = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self point:start_point layer:start_control_point_path_layer color:[UIColor systemYellowColor]];
    
    [self point:end_point layer:end_control_point_path_layer color:[UIColor systemYellowColor]];
    
    [self point:intermediate_point layer:intermediate_control_point_path_layer color:[UIColor systemYellowColor]];
    
    UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPath];
    [bezier_quad_curve moveToPoint:start_point];
    [bezier_quad_curve addQuadCurveToPoint:end_point controlPoint:intermediate_point];
    [(CAShapeLayer *)self.layer setLineWidth:1.0];
    [(CAShapeLayer *)self.layer setStrokeColor:[UIColor blueColor].CGColor];
    [(CAShapeLayer *)self.layer setPath:bezier_quad_curve.CGPath];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = (UITouch *)touches.anyObject;
    CGPoint circle_location = CGPointMake([touch locationInView:touch.view].x, [touch locationInView:touch.view].y);

    (change == 0) ?
    ^{ start_point = circle_location; }() :
    (change == 1) ?
    ^{ end_point = circle_location; }() :
    ^{ intermediate_point = circle_location; }();
    
    [self point:start_point layer:start_control_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(start_control_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
    
    [self point:end_point layer:end_control_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(end_control_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
    
    [self point:intermediate_point layer:intermediate_control_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(intermediate_control_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
    
    UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPath];
    [bezier_quad_curve moveToPoint:start_point];
    [bezier_quad_curve addQuadCurveToPoint:end_point controlPoint:intermediate_point];
    [(CAShapeLayer *)self.layer setLineWidth:1.0];
    [(CAShapeLayer *)self.layer setStrokeColor:[UIColor blueColor].CGColor];
    [(CAShapeLayer *)self.layer setPath:bezier_quad_curve.CGPath];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = (UITouch *)touches.anyObject;
    CGPoint circle_location = CGPointMake([touch locationInView:touch.view].x, [touch locationInView:touch.view].y);
    
    change = (CGRectContainsPoint(CGPathGetBoundingBox(start_control_point_path_layer.path), circle_location)) ? 0 :
    (CGRectContainsPoint(CGPathGetBoundingBox(end_control_point_path_layer.path), circle_location)) ? 1 : 2;
    
    if ((CGRectContainsPoint(CGPathGetBoundingBox(start_control_point_path_layer.path), circle_location)) || (CGRectContainsPoint(CGPathGetBoundingBox(end_control_point_path_layer.path), circle_location)) || (CGRectContainsPoint(CGPathGetBoundingBox(intermediate_control_point_path_layer.path), circle_location))) {
        
        [self point:start_point layer:start_control_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(start_control_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
        
        [self point:end_point layer:end_control_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(end_control_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
        
        [self point:intermediate_point layer:intermediate_control_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(intermediate_control_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
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
