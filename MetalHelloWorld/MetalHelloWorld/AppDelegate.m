//
//  AppDelegate.m
//  MetalHelloWorld
//
//  Created by Yongjian Feng on 4/2/22.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.m_controller = [[MetalViewController alloc] initWithNibName:@"MetalViewController" bundle:nil];
    
    [self.window.contentView addSubview:self.m_controller.view];
    self.m_controller.view.frame = ((NSView*) self.window.contentView).bounds;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
