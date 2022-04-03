//
//  MKTViewDrawer.h
//  MetalHelloWorld
//
//  Created by Yongjian Feng on 4/2/22.
//

#import <Foundation/Foundation.h>
@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

@interface MKTViewDrawer : NSObject<MTKViewDelegate>
- (MKTViewDrawer*) setMTKView:(nonnull MTKView*) mtkView;
@end

NS_ASSUME_NONNULL_END
