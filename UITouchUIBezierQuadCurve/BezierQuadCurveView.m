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
//    [self setupGestureRecognizers];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = (UITouch *)touches.anyObject;
    CGPoint circle_location = CGPointMake([touch locationInView:touch.view].x, [touch locationInView:touch.view].y);
    
    //    (CGRectContainsPoint(CGPathGetBoundingBox(startcontrol_point_path.CGPath), circle_location)) ?
    //    ^{ start = circle_location; }() : (CGRectContainsPoint(CGPathGetBoundingBox(endcontrol_point_path.CGPath), circle_location)) ?
    //    ^{ end = circle_location; }() : ^{ intermediate = circle_location; }();
    
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

//- (void)setupGestureRecognizers
//{
//    [self setUserInteractionEnabled:TRUE];
//    [self setMultipleTouchEnabled:TRUE];
//    [self setExclusiveTouch:TRUE];
//
//    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//    self.tapGestureRecognizer.delegate = self;
//    [self addGestureRecognizer:self.tapGestureRecognizer];
//
//    self.gestureRecognizers = @[self.tapGestureRecognizer];
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

//- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = (UITouch *)touches.anyObject;
    CGPoint circle_location = CGPointMake([touch locationInView:touch.view].x, [touch locationInView:touch.view].y);
    
    change = (CGRectContainsPoint(CGPathGetBoundingBox(startcontrol_point_path_layer.path), circle_location)) ? 0 :
    (CGRectContainsPoint(CGPathGetBoundingBox(endcontrol_point_path_layer.path), circle_location)) ? 1 : 2;
    //(change < 2) ? change + 1 : 0;
    //    (change == 1) ?
    //    ^{ start = [sender locationOfTouch:0 inView:self]; printf("start\n"); }() :
    //    (change == 2) ?
    //    ^{ end = [sender locationOfTouch:0 inView:self]; printf("end\n"); }() :
    //    (change == 0) ?
    //    ^{ intermediate = [sender locationOfTouch:0 inView:self]; printf("intermediate\n"); }() : ^{ printf("change == %d\n", change); }();
    //
    
    if ((CGRectContainsPoint(CGPathGetBoundingBox(startcontrol_point_path_layer.path), circle_location)) || (CGRectContainsPoint(CGPathGetBoundingBox(endcontrol_point_path_layer.path), circle_location)) || (CGRectContainsPoint(CGPathGetBoundingBox(intermediatecontrol_point_path_layer.path), circle_location))) {
        
        [self point:start layer:startcontrol_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(startcontrol_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
        
        [self point:end layer:endcontrol_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(endcontrol_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
        
        [self point:intermediate layer:intermediatecontrol_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(intermediatecontrol_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor]];
    }
    //    UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPath];
    //    [bezier_quad_curve moveToPoint:[sender locationOfTouch:0 inView:self]];
    //    [bezier_quad_curve addQuadCurveToPoint:end controlPoint:intermediate];
    //    [(CAShapeLayer *)self.layer setLineWidth:1.0];
    //    [(CAShapeLayer *)self.layer setStrokeColor:[UIColor blueColor].CGColor];
    //    [(CAShapeLayer *)self.layer setPath:bezier_quad_curve.CGPath];
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

//- (void)renderQuadCurveUsingTouchPoint:(CGPoint)point setHandles:(BOOL)shouldSetHandles {
//    [self path:startcontrol_point_path point:start layer:startcontrol_point_path_layer color:[UIColor systemYellowColor]];
//    [self path:endcontrol_point_path point:end layer:endcontrol_point_path_layer color:[UIColor systemYellowColor]];
//    [self path:intermediatecontrol_point_path point:intermediate layer:intermediatecontrol_point_path_layer color:[UIColor systemYellowColor]];
//
//        if (CGRectContainsPoint(CGPathGetBoundingBox(startcontrol_point_path.CGPath), point)) {
//            [self path:startcontrol_point_path point:start layer:startcontrol_point_path_layer color:[UIColor systemRedColor]];
//        } else if (CGRectContainsPoint(CGPathGetBoundingBox(endcontrol_point_path.CGPath), point)) {
//            [self path:endcontrol_point_path point:end layer:endcontrol_point_path_layer color:[UIColor systemRedColor]];
//        } else if (CGRectContainsPoint(CGPathGetBoundingBox(intermediatecontrol_point_path.CGPath), point)) {
//            [self path:intermediatecontrol_point_path point:intermediate layer:intermediatecontrol_point_path_layer color:[UIColor systemRedColor]];
//        }
//
//
//
////    quad_curve = [UIBezierPath bezierPath];
////    handle = [UIBezierPath bezierPath];
////    //    if (shouldSetHandles) {
////    if (CGRectContainsPoint(start_rect, point) || change == 1) {
////        start = point;
////        [handle moveToPoint:start];
////        [handle addArcWithCenter:start radius:20.0 startAngle:0 endAngle:M_PI_2 clockwise:TRUE];
////        [handle addArcWithCenter:start radius:20.0 startAngle:M_PI_2 endAngle:M_PI_4 clockwise:TRUE];
////
////        start_rect = CGRectMake(start.x - 10.0, start.y - 10.0, 40.0, 40.0);
////
////    } else if (CGRectContainsPoint(end_rect, point) || change == 0) {
////        end = point;
////        [handle moveToPoint:end];
////        [handle addArcWithCenter:end radius:20.0 startAngle:0 endAngle:M_PI_2 clockwise:TRUE];
////        [handle addArcWithCenter:end radius:20.0 startAngle:M_PI_2 endAngle:M_PI_4 clockwise:TRUE];
////
////        end_rect = CGRectMake(end.x - 10.0, end.y - 10.0, 40.0, 40.0);
////
////    } else if (CGRectContainsPoint(intermediate_rect, point) || change == 2) {
////        intermediate = point;
////        [handle moveToPoint:intermediate];
////        [handle addArcWithCenter:intermediate radius:20.0 startAngle:0 endAngle:M_PI_2 clockwise:TRUE];
////        [handle addArcWithCenter:intermediate radius:20.0 startAngle:M_PI_2 endAngle:M_PI_4 clockwise:TRUE];
////
////        intermediate_rect = CGRectMake(intermediate.x - 10.0, intermediate.y - 10.0, 40.0, 40.0);
////    }
////    [(CAShapeLayer *)self.layer setLineWidth:1.0];
////    [(CAShapeLayer *)self.layer setStrokeColor:[UIColor redColor].CGColor];
////    [(CAShapeLayer *)self.layer setPath:handle.CGPath];
////    //    }
////    [quad_curve moveToPoint:start];
////    [quad_curve addQuadCurveToPoint:end controlPoint:intermediate];
////
////    [(CAShapeLayer *)curve_layer setLineWidth:1.0];
////    [(CAShapeLayer *)curve_layer setStrokeColor:[UIColor blueColor].CGColor];
////    [(CAShapeLayer *)curve_layer setPath:quad_curve.CGPath];
//}

@end
