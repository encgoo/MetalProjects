//
//  AppDelegate.m
//  MetalTemplate
//
//  Created by Yongjian Feng on 4/3/22.
//

#import "AppDelegate.h"
#import "MTKViewController.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property (strong) MTKViewController *_controller;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self._controller = [[MTKViewController alloc] initWithNibName:@"MTKViewController" bundle:nil];
    // Add the MTK view to window
    [self.window.contentView addSubview:self._controller.view];
    self._controller.view.frame = ((NSView* ) self.window.contentView).bounds;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
