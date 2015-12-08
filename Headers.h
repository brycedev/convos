#define APP_ID @"com.brycedev.convos"
#define FILE_PATH @"/var/mobile/Library/Convos"
#define PINNED_PATH @"/var/mobile/Library/Convos/pinned.txt"
#define UNREAD_PATH @"/var/mobile/Library/Convos/unread.txt"
#define PREF_PATH @"/var/mobile/Library/Preferences/com.brycedev.convos.plist"

@interface SBIcon
- (id)applicationBundleID;
- (void)setBadge:(id)badge;
- (int)badgeValue;
@end
@interface UIApplication (Private)
- (void)_setBackgroundStyle:(long long)style;
@end

@interface CKNavigationController : UINavigationController
@end

@interface CKConversationListController : UIViewController
- (void)viewWillAppear:(BOOL)arg1;
- (id)conversationList;
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer;
@end

@interface CKConversationListCell : UITableViewCell
- (void)layoutSubviews;
- (NSString*)timeSince:(NSDate *)date;
- (void)updateContentsForConversation:(id)arg1;
@end

@interface CKConversationList : NSObject
- (id)conversations;
- (NSArray *)sortAlphabetically:(NSMutableArray*)array;
@end

@interface IMChat : NSObject
@property (nonatomic, readonly) NSString *chatIdentifier;
@property (nonatomic, readonly) NSString *guid;
- (id)chatItems;
@end

@interface CKConversation : NSObject
- (id)name;
- (IMChat *)chat;
- (void)markAllMessagesAsRead;
- (BOOL)hasUnreadMessages;
@end

@interface CKBalloonImageView : UIView
@end

@interface CKBalloonView : CKBalloonImageView
@end

@interface CKColoredBalloonView : CKBalloonView
@end

@interface CKTextBalloonView : CKColoredBalloonView
-(void)setAttributedText:(id)arg1;
@end

@interface CKHyperlinkBalloonView : CKTextBalloonView
@end

@interface NSConcreteAttributedString : NSAttributedString
- (id)initWithAttributedString:(id)arg1;
@end

@interface CKViewController : UIViewController
@end

@interface CKSummaryLabel : UILabel
@end

@interface UIDateLabel : UILabel
- (NSDate *)date;
- (BOOL)forceTimeOnly;
- (id)timeDesignator;
- (void)_didUpdateDate;
@end
