@interface BDSettingsManager : NSObject

@property (nonatomic, copy) NSDictionary *settings;

@property (nonatomic, readonly, getter=isEnabled) BOOL enabled;
@property (nonatomic, readonly, getter=shouldPinConvos) BOOL pinnedConvos;
@property (nonatomic, readonly, getter=useCustomPinnedText) BOOL customPinnedText;
@property (nonatomic, readonly, getter=customPinText) NSString * customPinText;
@property (nonatomic, readonly, getter=shouldMarkMessages) BOOL messageMarking;
@property (nonatomic, readonly, getter=shouldShowPreciseTimestamps) BOOL preciseTimestamps;
@property (nonatomic, readonly, getter=shouldHideSeparatorLines) BOOL hideSeparatorLines;
@property (nonatomic, readonly, getter=shouldHideTapSelection) BOOL hideTapSelection;
@property (nonatomic, readonly, getter=shouldRemoveLinkUnderline) BOOL removeLinkUnderline;
@property (nonatomic, readonly, getter=shouldMaskNames) BOOL nameMaskingMode;
@property (nonatomic, readonly, getter=shouldRemoveChevron) BOOL removeChevron;
@property (nonatomic, readonly, getter=shouldLoadMoreMessages) BOOL loadMoreMessages;
@property (nonatomic, readonly, getter=shouldSortConvosAlphabetically) BOOL sortConvosAlphabetically;
@property (nonatomic, readonly, getter=useCustomCellSpacing) BOOL customCellSpacing;
@property (nonatomic, readonly, getter=useCustomTableColor) BOOL customTableColor;
@property (nonatomic, readonly, getter=useCustomSenderColor) BOOL customSenderColor;
@property (nonatomic, readonly, getter=useCustomSummaryColor) BOOL customSummaryColor;
@property (nonatomic, readonly, getter=useCustomDateColor) BOOL customDateColor;
@property (nonatomic, readonly, getter=useCustomUnreadColor) BOOL customUnreadColor;
@property (nonatomic, readonly, getter=tableBackgroundColor) NSString * tableBackgroundColor;
@property (nonatomic, readonly, getter=senderLabelColor) NSString * senderLabelColor;
@property (nonatomic, readonly, getter=summaryLabelColor) NSString * summaryLabelColor;
@property (nonatomic, readonly, getter=dateLabelColor) NSString * dateLabelColor;
@property (nonatomic, readonly, getter=unreadImageColor) NSString * unreadImageColor;
@property (nonatomic, readonly, getter=separationHeight)NSInteger separationHeight;

+ (instancetype)sharedManager;
- (void)updateSettings;

@end
