//
//  MetalDrawer.h
//  MetalTemplate
//
//  Created by Yongjian Feng on 4/3/22.
//

#import <Foundation/Foundation.h>

// Need to import this
@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

// Need to respect MTKViewDelegate interface
@interface MetalDrawer : NSObject<MTKViewDelegate>
// Init
- (MetalDrawer *) initWithView: (nonnull MTKView*) view;
- (void) redraw;
@end

NS_ASSUME_NONNULL_END
