//
//  main.m
//  Unlock
//
//  Created by Justin Ridgewell on 8/5/11.
//

#import "Keychain.h"
#import "Diskutil.h"

int main (int argc, const char * argv[])
{

	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	Keychain* keychain = [[Keychain alloc] init];
	NSMutableArray* volumesAndPasswords = [keychain volumesAndPasswordsWithService:@"local.corestorage.unlock"];

	for (NSMutableArray* volumeAndPassword in volumesAndPasswords) {
		NSString* uuid = [volumeAndPassword objectAtIndex:0];
		NSString* passphrase = [volumeAndPassword objectAtIndex:1];
		[Diskutil unlockVolume: uuid WithPassphrase: passphrase];
		[passphrase release];
		[volumeAndPassword release];
	}

	[volumesAndPasswords release];
	[keychain release];

	[pool drain];
    return 0;
}
