//
//  MetalFuncs.metal
//  MetalTemplate
//
//  Created by Yongjian Feng on 4/3/22.
//

#include <metal_stdlib>
#include "SharedTypes.h"

using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float4 color;
};

vertex RasterizerData
vert_func(uint vertexID [[vertex_id]],
         constant MTLVertex *vertices [[buffer(VertexInputIndex)]],
         constant vector_uint2 *viewportSizePointer [[buffer(ViewPortSize)]]){
    RasterizerData out;

    // Index into the array of positions to get the current vertex.
    // The positions are specified in pixel dimensions (i.e. a value of 100
    // is 100 pixels from the origin).
    float2 pixelSpacePosition = vertices[vertexID].position.xy;

    // Get the viewport size and cast to float.
    vector_float2 viewportSize = vector_float2(*viewportSizePointer);
    

    // To convert from positions in pixel space to positions in clip-space,
    //  divide the pixel coordinates by half the size of the viewport.
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);

    // Pass the input color directly to the rasterizer.
    out.color = vertices[vertexID].color;

    return out;
}

fragment float4 frag_func(RasterizerData in [[stage_in]]){
    return in.color;
}


