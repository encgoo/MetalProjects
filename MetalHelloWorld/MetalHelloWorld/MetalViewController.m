//
//  MetalViewController.m
//  MetalHelloWorld
//
//  Created by Yongjian Feng on 4/2/22.
//

// Need to add the view controller
#import "MetalViewController.h"
// Need a drawer, which is a MTKViewDelegate
#import "MKTViewDrawer.h"
@interface MetalViewController ()

@end

@implementation MetalViewController
{
    MTKView             *_view;
    MKTViewDrawer       *_drawer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _view = (MTKView *) self.view;
    _view.device = MTLCreateSystemDefaultDevice();
    
    
    // Make sure a device can be created
    NSAssert(_view.device, @"Metal is not supported on this device");
    
    _drawer = [[MKTViewDrawer alloc] setMTKView:_view];
    [_drawer mtkView:_view drawableSizeWillChange:_view.drawableSize];
    _view.delegate = _drawer;
}

@end
