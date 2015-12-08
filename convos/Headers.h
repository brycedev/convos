#import "Preferences/PSListController.h"
#import "Preferences/PSSpecifier.h"
#import <Twitter/TWTweetComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>

#define FILE_PATH @"/var/mobile/Library/Convos"
#define PINNED_PATH @"/var/mobile/Library/Convos/pinned.txt"
#define PREF_PATH @"/var/mobile/Library/Preferences/com.brycedev.convos.plist"

@interface PSTableCell : UITableViewCell
@end

@interface PSTableCell (Convos)
    @property (nonatomic, retain) UIView *backgroundView;
    - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier;
    - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end

@interface ConvosHeaderCell : PSTableCell
@end

@interface PSListController (Convos)
    - (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
    - (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
    - (UINavigationController*)navigationController;
    - (void)viewWillAppear:(BOOL)animated;
@end

@interface ConvosListController: PSListController <MFMailComposeViewControllerDelegate>
    - (void)openSupportMail;
    - (void)openSupportTwitter;
    - (void)openDonateBitcoin;
    - (void)openDonatePayPal;
@end

@interface ConvosInterfaceController : PSListController
@end

@interface ConvosSettingsController : PSListController
@end
