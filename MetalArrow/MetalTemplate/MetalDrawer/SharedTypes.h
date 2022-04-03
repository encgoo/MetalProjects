//
//  SharedTypes.h
//  MetalTemplate
//
//  Created by Yongjian Feng on 4/3/22.
//

#ifndef SharedTypes_h
#define SharedTypes_h

typedef struct{
    vector_float2 position;
    vector_float4 color;
} MTLVertex;

enum {
    VertexInputIndex = 0,
    ViewPortSize = 1,
};

#endif /* SharedTypes_h */
