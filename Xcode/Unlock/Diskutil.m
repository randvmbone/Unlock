//
//  Diskutil.m
//  Unlock
//
//  Created by Justin Ridgewell on 8/6/11.
//

#import "Diskutil.h"

@implementation Diskutil

+ (void) unlockVolume: (NSString*) uuid WithPassphrase: (NSString*) passphrase {
	NSMutableArray* args = [NSMutableArray array];
	[args addObject: (NSString*) @"coreStorage"];
	[args addObject: (NSString*) @"unlockVolume"];
	[args addObject: (NSString*) uuid];
	[args addObject: (NSString*) @"-passphrase"];
	[args addObject: passphrase];

	NSLog(@"Unlock %@", uuid);
    [[NSTask launchedTaskWithLaunchPath:@"/usr/sbin/diskutil" arguments:args] waitUntilExit];
}

@end
