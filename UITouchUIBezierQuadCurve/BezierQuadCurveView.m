//
//  BezierQuadCurveView.m
//  UITouchUIBezierQuadCurve
//
//  Created by Xcode Developer on 11/1/21.
//

#import "BezierQuadCurveView.h"
#import "ChangeState.h"

static NSArray<NSString *> * const CaptureDeviceConfigurationControlPropertyImageKeys = @[@"CaptureDeviceConfigurationControlPropertyTorchLevel",
                                                                                          @"CaptureDeviceConfigurationControlPropertyLensPosition",
                                                                                          @"CaptureDeviceConfigurationControlPropertyExposureDuration",
                                                                                          @"CaptureDeviceConfigurationControlPropertyISO",
                                                                                          @"CaptureDeviceConfigurationControlPropertyZoomFactor"];


static NSArray<NSArray<NSString *> *> * const CaptureDeviceConfigurationControlPropertyImageValues = @[@[@"bolt.circle",
                                                                                                         @"viewfinder.circle",
                                                                                                         @"timer",
                                                                                                         @"camera.aperture",
                                                                                                         @"magnifyingglass.circle"],@[@"bolt.circle.fill",
                                                                                                                                      @"viewfinder.circle.fill",
                                                                                                                                      @"timer",
                                                                                                                                      @"camera.aperture",
                                                                                                                                      @"magnifyingglass.circle.fill"]];

typedef enum : NSUInteger {
    CaptureDeviceConfigurationControlPropertyTorchLevel,
    CaptureDeviceConfigurationControlPropertyLensPosition,
    CaptureDeviceConfigurationControlPropertyExposureDuration,
    CaptureDeviceConfigurationControlPropertyISO,
    CaptureDeviceConfigurationControlPropertyZoomFactor
} CaptureDeviceConfigurationControlProperty;

typedef enum : NSUInteger {
    CaptureDeviceConfigurationControlStateDeselected,
    CaptureDeviceConfigurationControlStateSelected
} CaptureDeviceConfigurationControlState;

static UIImageSymbolConfiguration * (^CaptureDeviceConfigurationControlPropertySymbolImageConfiguration)(CaptureDeviceConfigurationControlState) = ^ UIImageSymbolConfiguration * (CaptureDeviceConfigurationControlState state) {
    switch (state) {
        case CaptureDeviceConfigurationControlStateDeselected: {
            UIImageSymbolConfiguration * symbol_palette_colors = [UIImageSymbolConfiguration configurationWithHierarchicalColor:[UIColor systemBlueColor]];
            UIImageSymbolConfiguration * symbol_font_weight    = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightThin];
            UIImageSymbolConfiguration * symbol_font_size      = [UIImageSymbolConfiguration configurationWithPointSize:42.0 weight:UIImageSymbolWeightUltraLight];
            UIImageSymbolConfiguration * symbol_configuration  = [symbol_font_size configurationByApplyingConfiguration:[symbol_palette_colors configurationByApplyingConfiguration:symbol_font_weight]];
            return symbol_configuration;
        }
            break;
            
        case CaptureDeviceConfigurationControlStateSelected: {
            UIImageSymbolConfiguration * symbol_palette_colors_selected = [UIImageSymbolConfiguration configurationWithHierarchicalColor:[UIColor systemYellowColor]];// configurationWithPaletteColors:@[[UIColor systemYellowColor], [UIColor clearColor], [UIColor systemYellowColor]]];
            UIImageSymbolConfiguration * symbol_font_weight_selected    = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightRegular];
            UIImageSymbolConfiguration * symbol_font_size_selected      = [UIImageSymbolConfiguration configurationWithPointSize:42.0 weight:UIImageSymbolWeightThin];
            UIImageSymbolConfiguration * symbol_configuration_selected  = [symbol_font_size_selected configurationByApplyingConfiguration:[symbol_palette_colors_selected configurationByApplyingConfiguration:symbol_font_weight_selected]];
            
            return symbol_configuration_selected;
        }
            break;
        default:
            return nil;
            break;
    }
};
static NSString * (^CaptureDeviceConfigurationControlPropertySymbol)(CaptureDeviceConfigurationControlProperty, CaptureDeviceConfigurationControlState) = ^ NSString * (CaptureDeviceConfigurationControlProperty property, CaptureDeviceConfigurationControlState state) {
    return CaptureDeviceConfigurationControlPropertyImageValues[state][property];
};

static NSString * (^CaptureDeviceConfigurationControlPropertyString)(CaptureDeviceConfigurationControlProperty) = ^ NSString * (CaptureDeviceConfigurationControlProperty property) {
    return CaptureDeviceConfigurationControlPropertyImageKeys[property];
};

static UIImage * (^CaptureDeviceConfigurationControlPropertySymbolImage)(CaptureDeviceConfigurationControlProperty, CaptureDeviceConfigurationControlState) = ^ UIImage * (CaptureDeviceConfigurationControlProperty property, CaptureDeviceConfigurationControlState state) {
    return [UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertySymbol(property, state) withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(state)];
};

@implementation BezierQuadCurveView {
    
    CGPoint start_point;
    CGPoint end_point;
    CGPoint intermediate_point;
    
    CAShapeLayer * start_control_point_path_layer;
    CAShapeLayer * end_control_point_path_layer;
    CAShapeLayer * intermediate_control_point_path_layer;
    
    CGPoint (^BezierQuadCurvePointForTime)(CGFloat);
    
    __block NSMutableArray<UIButton *> * buttons;
    
    UIView * handles_view;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)displayBezierQuadCurve {
    [self point:[self start_point] layer:start_control_point_path_layer color:[UIColor systemYellowColor] position:0.0];
    
    [self point:[self end_point] layer:end_control_point_path_layer color:[UIColor systemYellowColor] position: 1.0];
    
    [self point:[self intermediate_point] layer:intermediate_control_point_path_layer color:[UIColor systemYellowColor] position:0.5];
    
    UIBezierPath * bezier_quad_curve = [UIBezierPath bezierPath];
    [bezier_quad_curve moveToPoint:[self start_point]];
    [bezier_quad_curve addQuadCurveToPoint:[self end_point] controlPoint:[self intermediate_point]];
    [(CAShapeLayer *)self.layer setLineWidth:1.0];
    [(CAShapeLayer *)self.layer setStrokeColor:[UIColor blueColor].CGColor];
    [(CAShapeLayer *)self.layer setFillColor:[UIColor clearColor].CGColor];
    [(CAShapeLayer *)self.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [(CAShapeLayer *)self.layer setPath:bezier_quad_curve.CGPath];
}

// To-Do: Draw handles for all three control points in blue; change to red when selected

- (CGPoint)start_point {
    start_point =        CGPointMake(start_point.x,        fminf(fmaxf(0.0, start_point.y),          CGRectGetMaxY(self.bounds)));
    return start_point;
}

- (CGPoint)end_point {
    end_point =          CGPointMake(end_point.x,          fminf(fmaxf(0.0, end_point.y),          CGRectGetMaxY(self.bounds)));
    return end_point;
}

- (CGPoint)intermediate_point {
    intermediate_point = CGPointMake(intermediate_point.x, fminf(fmaxf(0.0, intermediate_point.y), CGRectGetMaxY(self.bounds)));
    return intermediate_point;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self setBounds:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetMaxX(self.frame) - CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame) - CGRectGetMinY(self.frame))];
//    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetMaxX(self.frame) - CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame) - CGRectGetMinY(self.frame))];
    
    start_point = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame));
    end_point = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame));
    intermediate_point = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    buttons = [[NSMutableArray alloc] initWithCapacity:CaptureDeviceConfigurationControlPropertyImageKeys.count];
    [CaptureDeviceConfigurationControlPropertyImageValues[0] enumerateObjectsUsingBlock:^(NSString * _Nonnull imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        [buttons addObject:^ {
            UIButton * button;
            [button = [UIButton new] setTag:idx];

            [button setBackgroundColor:[UIColor clearColor]];
            [button setShowsTouchWhenHighlighted:TRUE];

            [button setImage:[UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertyImageValues[0][idx] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateDeselected)] forState:UIControlStateNormal];
            [button setImage:[UIImage systemImageNamed:CaptureDeviceConfigurationControlPropertyImageValues[1][idx] withConfiguration:CaptureDeviceConfigurationControlPropertySymbolImageConfiguration(CaptureDeviceConfigurationControlStateSelected)] forState:UIControlStateSelected];

            [button sizeToFit];
            CGSize button_size = [button intrinsicContentSize];
            [button setFrame:CGRectMake(0.0, 0.0,
                                        button_size.width, button_size.height)];
            [self addSubview:button];
            

            return button;
            }()];
    }];
    
    handles_view = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:handles_view];
    
    start_control_point_path_layer = [CAShapeLayer new];
    end_control_point_path_layer = [CAShapeLayer new];
    intermediate_control_point_path_layer = [CAShapeLayer new];
    [handles_view.layer addSublayer:start_control_point_path_layer];
    [handles_view.layer addSublayer:end_control_point_path_layer];
    [handles_view.layer addSublayer:intermediate_control_point_path_layer];
    [start_control_point_path_layer setBackgroundColor:[UIColor clearColor].CGColor];
    [end_control_point_path_layer setBackgroundColor:[UIColor clearColor].CGColor];
    [intermediate_control_point_path_layer setBackgroundColor:[UIColor clearColor].CGColor];
    [start_control_point_path_layer setFillColor:[UIColor clearColor].CGColor];
    [end_control_point_path_layer setFillColor:[UIColor clearColor].CGColor];
    [intermediate_control_point_path_layer setFillColor:[UIColor clearColor].CGColor];
    
    [start_control_point_path_layer setBorderWidth:1.0];
    [end_control_point_path_layer setBorderWidth:1.0];
    [intermediate_control_point_path_layer setBorderWidth:1.0];
    
    [start_control_point_path_layer setBorderColor:[UIColor systemYellowColor].CGColor];
    [end_control_point_path_layer setBorderColor:[UIColor systemYellowColor].CGColor];
    [intermediate_control_point_path_layer setBorderColor:[UIColor systemYellowColor].CGColor];
    
    BezierQuadCurvePointForTime = ^ {
        return ^ CGPoint (CGFloat time) {
            CGFloat x = (1 - time) * (1 - time) * [self start_point].x + 2 * (1 - time) * time * [self intermediate_point].x + time * time * [self end_point].x;
            CGFloat y = (1 - time) * (1 - time) * [self start_point].y + 2 * (1 - time) * time * [self intermediate_point].y + time * time * [self end_point].y;
            
            return CGPointMake(x, fminf(fmaxf(0.0, y), CGRectGetMaxY(self.bounds)));
        };
    }();
    
    change = 0;
    [self displayBezierQuadCurve];
    [self displayButtons];
    // To-Do: Display positioning guides; add a snap-to feature
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = (UITouch *)touches.anyObject;
    CGPoint circle_location = CGPointMake(fmaxf(CGRectGetMinX(touch.view.frame), fminf(CGRectGetMaxX(touch.view.frame), [touch locationInView:touch.view].x)),
                                          fminf(CGRectGetMaxY(touch.view.frame), [touch locationInView:touch.view].y));
    
    (change == 0) ?
    ^{ start_point = circle_location; }() :
    (change == 1) ?
    ^{ end_point = circle_location; }() :
    ^{ intermediate_point = circle_location; }();
    
    [self displayBezierQuadCurve];
    [self displayButtons];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = (UITouch *)touches.anyObject;
    CGPoint circle_location = CGPointMake([touch locationInView:touch.view].x, [touch locationInView:touch.view].y);
    
    change = (CGRectContainsPoint(CGPathGetBoundingBox(start_control_point_path_layer.path), circle_location)) ? 0 :
    (CGRectContainsPoint(CGPathGetBoundingBox(end_control_point_path_layer.path), circle_location)) ? 1 : 2;
    
    if ((CGRectContainsPoint(CGPathGetBoundingBox(start_control_point_path_layer.path), circle_location)) || (CGRectContainsPoint(CGPathGetBoundingBox(end_control_point_path_layer.path), circle_location)) || (CGRectContainsPoint(CGPathGetBoundingBox(intermediate_control_point_path_layer.path), circle_location))) {
        
        [self point:[self start_point] layer:start_control_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(start_control_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor] position:0.0];
        
        [self point:[self end_point] layer:end_control_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(end_control_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor] position:1.0];
        
        [self point:[self intermediate_point] layer:intermediate_control_point_path_layer color:(CGRectContainsPoint(CGPathGetBoundingBox(intermediate_control_point_path_layer.path), circle_location)) ? [UIColor systemRedColor] : [UIColor systemYellowColor] position:0.5];
    }
}



- (void)displayButtons {
    [buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button setCenter:BezierQuadCurvePointForTime((idx == 0) ? 0.125 : (idx == 1) ? 0.3125 : (idx == 2) ? 0.5 : (idx == 3) ? 0.6875 : 0.875)];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self displayBezierQuadCurve];
    [self displayButtons];
}

- (void)point:(CGPoint)point layer:(CAShapeLayer *)layer color:(UIColor *)color position:(CGFloat)position {
    [layer setPath:nil];
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGPoint new_point = BezierQuadCurvePointForTime(position);
    [path addArcWithCenter:CGPointMake(new_point.x, fmaxf(0.0, new_point.y - 44.0)) radius:10.0 startAngle:0 endAngle:M_PI_2 clockwise:TRUE];
    [path addArcWithCenter:CGPointMake(new_point.x, fmaxf(0.0, new_point.y - 44.0)) radius:10.0 startAngle:M_PI_2 endAngle:M_PI_4 clockwise:TRUE];
    [(CAShapeLayer *)layer setLineWidth:1.0];
    [(CAShapeLayer *)layer setStrokeColor:color.CGColor];
    CGMutablePathRef path_ref = path.CGPath;
    const CGRect rects[] = { CGPathGetBoundingBox(path_ref), CGPathGetBoundingBox(path_ref) };
    NSUInteger count = sizeof(rects) / sizeof(CGRect);
    CGPathAddRects(path_ref, NULL, rects, count);
    [(CAShapeLayer *)layer setPath:path.CGPath];
}

@end
