#import "Headers.h"
#import <libcolorpicker.h>

@implementation ConvosListController

- (id)specifiers {

	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Convos" target:self] retain];
	}
	return _specifiers;

}

- (void)openSupportMail {

    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    [mailer setSubject:@"Tweak Support - Convos"];
    [mailer setToRecipients:[NSArray arrayWithObjects:@"bryce@brycedev.com", nil]];
    [self.navigationController presentViewController:mailer animated:YES completion:nil];
    mailer.mailComposeDelegate = self;
    [mailer release];

}

- (void)openSupportTwitter {

    NSString *user = @"thebryc3isright";

    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];

    else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];

}

- (void)openDonateBitcoin {

    UIPasteboard *appPasteBoard = [UIPasteboard generalPasteboard];
    appPasteBoard.persistent = YES;
    [appPasteBoard setString: @"1PiVT3TfzvtLpQmmFyxHtdMVzyDGhE1sN"];

    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"bitcoin:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"bitcoin:"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://coinbase.com"]];
}

- (void)openDonatePayPal {

    UIPasteboard *appPasteBoard = [UIPasteboard generalPasteboard];
    appPasteBoard.persistent = YES;
    [appPasteBoard setString: @"bryce@brycedev.com"];

    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"paypal:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"paypal:"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.com"]];

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {

    [self dismissViewControllerAnimated: YES completion: nil];

}

@end

@implementation ConvosInterfaceController

- (void)viewWillAppear:(BOOL)animated
{
    //[self clearCache];
      //[self reload];
     [super viewWillAppear:animated];
}

- (id)specifiers {

    if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Interface" target:self] retain];
	}
	return _specifiers;

}

@end

@implementation ConvosSettingsController

- (id)specifiers {

	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Settings" target:self] retain];
	}
	return _specifiers;

}


@end

@implementation ConvosHeaderCell

- (id)initWithSpecifier:(PSSpecifier *)specifier {

    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];

        if (self) {

            int width = [[UIScreen mainScreen] bounds].size.width;

            UILabel *tweakName = [[UILabel alloc] initWithFrame: CGRectMake(0, -25, width, 70)];
            [tweakName setNumberOfLines:1];
            tweakName.font = [UIFont fontWithName:@"HelveticaNeue-Ultralight" size:50];
            [tweakName setText:@"Convos"];
            [tweakName setBackgroundColor: [UIColor clearColor]];
            tweakName.textColor = [UIColor colorWithRed:1 green:0.235 blue:0.349 alpha:1];
            tweakName.textAlignment = NSTextAlignmentCenter;

            UILabel *subTitle = [[UILabel alloc] initWithFrame: CGRectMake(0, 45, width, 30)];
            [subTitle setNumberOfLines:1];
            subTitle.font = [UIFont fontWithName:@"HelveticaNeue-Ultralight" size:20];
            [subTitle setText:@"iMessage Enhancer"];
            [subTitle setBackgroundColor: [UIColor clearColor]];
            subTitle.textColor = [UIColor colorWithRed:1 green:0.235 blue:0.349 alpha:1];
            subTitle.textAlignment = NSTextAlignmentCenter;

            [self setBackgroundColor: [UIColor clearColor]];
            [self addSubview:tweakName];
            [self addSubview:subTitle];

        }

    return self;

}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {

    return 75.0f;

}

@end
