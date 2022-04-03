//
//  MTKViewController.m
//  MetalTemplate
//
//  Created by Yongjian Feng on 4/3/22.
//

#import "MTKViewController.h"
#import "MetalDrawer.h"

@interface MTKViewController ()

@end

@implementation MTKViewController{
    MTKView                     *_view;
    MetalDrawer                 *_drawer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _view = (MTKView *) self.view;
    _view.device = MTLCreateSystemDefaultDevice();
    
    NSAssert(_view.device, @"Metal device is not supported on this device");
    
    _drawer = [[MetalDrawer alloc] initWithView:_view];
    [_drawer mtkView:_view drawableSizeWillChange:_view.drawableSize];
    _view.delegate = _drawer;
    
    
    // Animation
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(redraw) userInfo:nil repeats:YES];
}

-(void) redraw {
    [_drawer redraw];
}


@end
