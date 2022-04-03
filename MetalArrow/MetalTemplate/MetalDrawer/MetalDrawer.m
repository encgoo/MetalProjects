//
//  MetalDrawer.m
//  MetalTemplate
//
//  Created by Yongjian Feng on 4/3/22.
//

#import "MetalDrawer.h"
#import "SharedTypes.h"
@import QuartzCore;

@implementation MetalDrawer
{
    // Some private member variables
    vector_uint2                        _viewSize;
    id<MTLDevice>                       _device;
    id<MTLRenderPipelineState>          _pipelineState;
    id<MTLCommandQueue>                 _cmdQueue;
    MTKView                             *_view;
    float                               _angle;
    bool                                _firstTime;
}

- (MetalDrawer *) initWithView: (nonnull MTKView*) view{
    // init local private members
    _device = view.device;
    
    // load vertex function and fragment function from .metal
    id<MTLLibrary>  defLib = [_device newDefaultLibrary];
    id<MTLFunction> vert_func = [defLib newFunctionWithName:@"vert_func"];
    id<MTLFunction> frag_func = [defLib newFunctionWithName:@"frag_func"];
    
    // configure pipeline
    MTLRenderPipelineDescriptor *pipelineDesr = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDesr.label = @"Draw Arrow";
    pipelineDesr.vertexFunction = vert_func;
    pipelineDesr.fragmentFunction = frag_func;
    pipelineDesr.colorAttachments[0].pixelFormat = view.colorPixelFormat;
    
    // build pipeline state with pipeline descriptor
    NSError *error;
    _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDesr error:&error];
    _cmdQueue = [_device newCommandQueue];
    _view = view;
    
    _angle = 0;
    _firstTime = true;
    view.enableSetNeedsDisplay = true;
    return self;
}

// MTKViewDelegate
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size{
    // Store th view size
    _viewSize.x = size.width;
    _viewSize.y = size.height;
}

- (vector_float2) rotate:(vector_float2) pos{
    static const float PI = 3.1415;
    double old_angle = 0;
    int sign = 1;
    if (pos[0] != 0){
        old_angle = atan(pos[1]/pos[0]);
        if (pos[0] < 0){
            sign = -1;
        }
    }
    else {
        if (pos[1] > 0){
            old_angle = PI/2;
        }
        else {
            old_angle = -PI/2;
        }
    }
    float len = sqrtf(pos[0]*pos[0] + pos[1]*pos[1]);
    vector_float2 ret;
    ret[0] = sign*len*cosf(_angle + old_angle);
    ret[1] = sign*len*sinf(_angle + old_angle);
    return ret;
}

- (void)drawInMTKView:(nonnull MTKView *)view{
    // method of drawing
    @autoreleasepool {
        

        
        
        
        MTLVertex arrow[] = {
            {{-50, -86}, {1, 0.5, 0.5f, 1}},
            {{ 50, -86}, {0.5, 1, 0.5f, 1}},
            {{  0, 100}, {0.5, 0.5, 1, 1}},
            {{-50, -86}, {0, 0, 0, 1}},
            {{ 50, -86}, {0, 0, 0, 1}},
            {{  0, -10}, {0, 0, 0, 1}}
        };
        
        uint vert_count = 6;
        
        int i = 0;
        for (i = 0; i < vert_count; ++i){
            MTLVertex vertex = arrow[i];
            vector_float2 pos = [self rotate:vertex.position];
            arrow[i].position[0] = pos[0];
            arrow[i].position[1] = pos[1];
        }
        
        id<MTLCommandBuffer> cmdBuf = [_cmdQueue commandBuffer];
        cmdBuf.label = @"drawCmd";
        
        MTLRenderPassDescriptor *renderPassDes = view.currentRenderPassDescriptor;
        
        if (renderPassDes != nil){
            id<MTLRenderCommandEncoder> renderEncoder = [cmdBuf renderCommandEncoderWithDescriptor:renderPassDes];
            renderEncoder.label = @"drawRenderEncoder";
            
            [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewSize.x, _viewSize.y, 0.0, 1.0}];
            [renderEncoder setRenderPipelineState:_pipelineState];
            [renderEncoder setVertexBytes:arrow length:sizeof(arrow) atIndex:VertexInputIndex];
            [renderEncoder setVertexBytes:&_viewSize length:sizeof(_viewSize) atIndex:ViewPortSize];
            
            // Draw the vertex
            [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:vert_count];
            
            [renderEncoder endEncoding];

            [cmdBuf presentDrawable:view.currentDrawable];
        }
        
        [cmdBuf commit];
    }
}

- (void) redraw {
    _angle = _angle + 0.05f;
    // Force refresh of the view
    _view.needsDisplay = true;
}

@end
