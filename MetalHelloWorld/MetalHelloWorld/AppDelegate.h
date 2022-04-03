//
//  AppDelegate.h
//  MetalHelloWorld
//
//  Created by Yongjian Feng on 4/2/22.
//

#import <Cocoa/Cocoa.h>
#import "MetalViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) IBOutlet MetalViewController *m_controller;

@end

