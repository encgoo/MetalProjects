//
//  MKTViewDrawer.m
//  MetalHelloWorld
//
//  Created by Yongjian Feng on 4/2/22.
//

#import "MKTViewDrawer.h"
#import "SharedTypes.h"

@implementation MKTViewDrawer
{
    // Create 'private' properties like this
    vector_uint2                        _viewSize;
    id<MTLDevice>                       _device;
    id<MTLRenderPipelineState>          _pipelineState;
    id<MTLCommandQueue>                 _commandQ;
}

// MKTViewDelegate required method
- (void)drawInMTKView:(nonnull MTKView *)view {
    // import method to draw
    static const AAPLVertex triangleVertices[] =
    {
        // 2D positions,    RGBA colors
        { {  100,  -100 }, { 0, 0, 1, 1 } },
        { { -100,  -100 }, { 0, 1, 0, 1 } },
        { {    0,   100 }, { 1, 0, 0, 1 } },
    };
    
    id<MTLCommandBuffer> cmdBuf = [_commandQ commandBuffer];
    cmdBuf.label = @"drawCmd";
    
    MTLRenderPassDescriptor *renderPassDes = view.currentRenderPassDescriptor;
    
    if (renderPassDes != nil){
        id<MTLRenderCommandEncoder> renderEncoder = [cmdBuf renderCommandEncoderWithDescriptor:renderPassDes];
        renderEncoder.label = @"drawRenderEncoder";
        
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewSize.x, _viewSize.y, 0.0, 1.0}];
        [renderEncoder setRenderPipelineState:_pipelineState];
        [renderEncoder setVertexBytes:triangleVertices length:sizeof(triangleVertices)
                              atIndex:AAPLVertexInputIndexVertices];
        
        // What is this?
        [renderEncoder setVertexBytes:&_viewSize length:sizeof(_viewSize)
                              atIndex:AAPLVertexInputIndexViewportSize];
        
        // Draw the triangle.
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:3];

        [renderEncoder endEncoding];

        // Schedule a present once the framebuffer is complete using the current drawable.
        [cmdBuf presentDrawable:view.currentDrawable];
        
    }
    // Finalize rendering here & push the command buffer to the GPU.
    [cmdBuf commit];
    
}

// MKTViewDelegate required method
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    // Store the latest drawable size
    _viewSize.x = size.width;
    _viewSize.y = size.height;
}

// Other methods
- (MKTViewDrawer*) setMTKView:(MTKView *)mtkView{
    // Store the device
    _device = mtkView.device;
    
    // load vertexFunction and fragmentFunction from MetalFuncs
    id<MTLLibrary> defLib = [_device newDefaultLibrary];
    id<MTLFunction> vert_func = [defLib newFunctionWithName:@"vert_func"];
    id<MTLFunction> frag_func = [defLib newFunctionWithName:@"frag_func"];
    
    // config pipeline
    MTLRenderPipelineDescriptor *pipelineDesr = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDesr.label = @"Draw Triangle";
    pipelineDesr.vertexFunction = vert_func;
    pipelineDesr.fragmentFunction = frag_func;
    pipelineDesr.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    
    NSError *error;
    _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDesr error:&error];
    
    // Create the command queue
    _commandQ = [_device newCommandQueue];
    
    return self;
}
@end
