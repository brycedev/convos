#import "BDSettingsManager.h"

@implementation BDSettingsManager

+ (instancetype)sharedManager {

    static dispatch_once_t p = 0;
    __strong static id _sharedSelf = nil;
    dispatch_once(&p, ^{
        _sharedSelf = [[self alloc] init];
    });

    return _sharedSelf;

}

void prefsChanged(CFNotificationCenterRef center, void * observer, CFStringRef name, const void * object, CFDictionaryRef userInfo) {

    [[BDSettingsManager sharedManager] updateSettings];

}

- (id)init {

    if (self = [super init]) {

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, prefsChanged, CFSTR("com.brycedev.convos/prefsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        [self updateSettings];

    }

    return self;
}

- (void)updateSettings {

    self.settings = nil;

    CFPreferencesAppSynchronize(CFSTR("com.brycedev.convos"));
    CFStringRef appID = CFSTR("com.brycedev.convos");
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID , kCFPreferencesCurrentUser, kCFPreferencesAnyHost) ?: CFArrayCreate(NULL, NULL, 0, NULL);
    self.settings = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID , kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFRelease(keyList);

}

- (BOOL)isEnabled {

    return self.settings[@"kEnabled"] ? [self.settings[@"kEnabled"] boolValue] : YES;

}

- (BOOL)shouldPinConvos {

    return self.settings[@"kPinConvos"] ? [self.settings[@"kPinConvos"] boolValue] : YES;

}

- (BOOL)useCustomPinnedText {

    return self.settings[@"kUseCustomPinnedText"] ? [self.settings[@"kUseCustomPinnedText"] boolValue] : NO;

}

- (NSString *)customPinText {

    return self.settings[@"kCustomPinnedText"] ? self.settings[@"kCustomPinnedText"] : @"PINNED";

}

- (BOOL)shouldMarkMessages {

    return self.settings[@"kMarkMessages"] ? [self.settings[@"kMarkMessages"] boolValue] : YES;

}

- (BOOL)shouldShowPreciseTimestamps {

    return self.settings[@"kShowPreciseTimestamps"] ? [self.settings[@"kShowPreciseTimestamps"] boolValue] : NO;

}

- (BOOL)shouldHideSeparatorLines {

    return self.settings[@"kHideSeparatorLines"] ? [self.settings[@"kHideSeparatorLines"] boolValue] : NO;

}

- (BOOL)shouldHideTapSelection {

    return self.settings[@"kHideTapSelection"] ? [self.settings[@"kHideTapSelection"] boolValue] : NO;

}

- (BOOL)shouldRemoveLinkUnderline {

    return self.settings[@"kRemoveLinkUnderline"] ? [self.settings[@"kRemoveLinkUnderline"] boolValue] : NO;

}

- (BOOL)shouldMaskNames {

    return self.settings[@"kMaskNames"] ? [self.settings[@"kMaskNames"] boolValue] : NO;

}

- (BOOL)shouldRemoveChevron {

    return self.settings[@"kRemoveChevron"] ? [self.settings[@"kRemoveChevron"] boolValue] : NO;

}

- (BOOL)shouldLoadMoreMessages {

    return self.settings[@"kLoadMoreMessages"] ? [self.settings[@"kLoadMoreMessages"] boolValue] : NO;

}

- (BOOL)shouldSortConvosAlphabetically {

    return self.settings[@"kSortConvosAlphabetically"] ? [self.settings[@"kSortConvosAlphabetically"] boolValue] : NO;

}

- (BOOL)useCustomTableColor {

    return self.settings[@"kUseCustomTableColor"] ? [self.settings[@"kUseCustomTableColor"] boolValue] : NO;

}

- (BOOL)useCustomSenderColor {

    return self.settings[@"kUseCustomSenderColor"] ? [self.settings[@"kUseCustomSenderColor"] boolValue] : NO;

}

- (BOOL)useCustomSummaryColor {

    return self.settings[@"kUseCustomSummaryColor"] ? [self.settings[@"kUseCustomSummaryColor"] boolValue] : NO;

}

- (BOOL)useCustomDateColor {

    return self.settings[@"kUseCustomDateColor"] ? [self.settings[@"kUseCustomDateColor"] boolValue] : NO;

}

- (BOOL)useCustomUnreadColor {

    return self.settings[@"kUseCustomUnreadColor"] ? [self.settings[@"kUseCustomUnreadColor"] boolValue] : NO;

}

- (BOOL)useCustomCellSpacing {

    return self.settings[@"kUseCustomCellSpacing"] ? [self.settings[@"kUseCustomCellSpacing"] boolValue] : NO;

}

- (NSString *)tableBackgroundColor {

    return self.settings[@"kTableBackgroundColor"] ? self.settings[@"kTableBackgroundColor"] : @"#1e1e1e";

}

- (NSString *)senderLabelColor {

    return self.settings[@"kSenderLabelColor"] ? self.settings[@"kSenderLabelColor"] : @"#fff";

}

- (NSString *)summaryLabelColor {

    return self.settings[@"kSummaryLabelColor"] ? self.settings[@"kSummaryLabelColor"] : @"#fff";

}

- (NSString *)dateLabelColor {

    return self.settings[@"kDateLabelColor"] ? self.settings[@"kDateLabelColor"] : @"#fff";

}

- (NSString *)unreadImageColor {

    return self.settings[@"kUnreadImageColor"] ? self.settings[@"kUnreadImageColor"] : @"#fff";

}

- (NSInteger)separationHeight {

    return self.settings[@"kSeparationHeight"] ? [self.settings[@"kSeparationHeight"] integerValue] : 0;

}

@end
