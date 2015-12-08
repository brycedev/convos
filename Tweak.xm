#import "Headers.h"
#import <libcolorpicker.h>
#import "BDSettingsManager.h"
#import "HexColors/HexColors.h"
#import "Toast/UIView+Toast.h"

//PREFERENCES

static BOOL enabled;

static BOOL pinnedConvos;
static BOOL messageMarking;
static BOOL preciseTimestamps;
static BOOL hideSeparatorLines;
static BOOL hideTapSelection;
static BOOL removeLinkUnderline;
static BOOL nameMaskingMode;
static BOOL removeChevron;
static BOOL loadMoreMessages;
static BOOL sortConvosAlphabetically;

static BOOL useCustomTableColor;
static BOOL useCustomSenderColor;
static BOOL useCustomSummaryColor;
static BOOL useCustomDateColor;
static BOOL useCustomUnreadColor;
static BOOL useCustomPinnedText;
static BOOL useCustomCellSpacing;

static NSString *tableBackgroundColor;
static NSString *senderLabelColor;
static NSString *summaryLabelColor;
static NSString *dateLabelColor;
static NSString *unreadImageColor;

static NSString *customPinnedText;
static NSInteger separationHeight;

//DECLARATIONS

NSArray *pinnedArray;
NSMutableArray *finalConvoArray;
NSArray *unreadArray;
UITableView *table;

//IMPLEMENTATION

%hook CKNavigationController

- (void)viewWillAppear:(BOOL)arg1 {

    %orig;

    if(useCustomTableColor && enabled)
        [self.view setBackgroundColor: [UIColor colorWithHexString: tableBackgroundColor]];

}

%end

%hook CKUIBehavior

- (id)chevronImage {

    UIImage *image = (UIImage *)%orig;

    if(enabled && removeChevron){

        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
        CGContextSetAlpha(ctx, 0);
        CGContextDrawImage(ctx, area, image.CGImage);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return newImage;

    } else {

        return %orig;

    }

}
- (unsigned int)defaultConversationViewingMessageCount {

    if(loadMoreMessages && enabled){

        return 300;

    } else {

        return %orig;

    }

}

- (id)conversationListGroupCountColor {

    if(enabled && useCustomSenderColor)
        return [UIColor colorWithHexString: senderLabelColor];
    else
        return %orig;

}

%end

%hook CKConversationListController

- (void)viewWillAppear:(BOOL)arg1 {

    object_getInstanceVariable(self, "_table", (void **)&table);

    //[[UIApplication sharedApplication] _setBackgroundStyle:3];

    if(hideSeparatorLines && enabled){

        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    }

    if(enabled && useCustomTableColor){

        [table setBackgroundColor: [UIColor colorWithHexString: tableBackgroundColor]];


        for(UIView *view in [table subviews]){

            [view setBackgroundColor: [UIColor colorWithHexString: tableBackgroundColor]];

        }

    }

    %orig;

}

- (void)tableView:(id)arg1 didSelectRowAtIndexPath:(NSIndexPath *)arg2 {

    CKConversation *convo = [finalConvoArray objectAtIndex: arg2.row];
    [convo markAllMessagesAsRead];

    NSString *identifier = [convo chat].chatIdentifier;

    NSArray *unreadList = [[NSString stringWithContentsOfFile: UNREAD_PATH encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
    NSMutableArray *unreadListMutable = [unreadList mutableCopy];

    for(NSString *string in unreadList){

        if([string isEqual:@""]){

            [unreadListMutable removeObject: string];

        }

        if([string isEqual: identifier]){

            [unreadListMutable removeObject: string];
            NSString *unreadListToString = [unreadListMutable componentsJoinedByString: @"\n"];
            [unreadListToString writeToFile: UNREAD_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];

        }

    }

    %orig;

}

- (CKConversationListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(enabled){

        CKConversationListCell * cell = %orig;

        //Long press recognizer for pinning conversations

        if(pinnedConvos){

            UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            lpgr.minimumPressDuration = 1.0;
            [cell addGestureRecognizer: lpgr];

        }

        //Swipe gesture recognizer for marking unread

        if(messageMarking){

            UISwipeGestureRecognizer *rsgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
            [rsgr setDirection:(UISwipeGestureRecognizerDirectionRight)];
            [cell addGestureRecognizer: rsgr];

        }

        [cell setTag: indexPath.row];

        [cell setBackgroundColor: [UIColor clearColor]];

        return cell;

    } else {

        return %orig;

    }

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(enabled && pinnedConvos){

        if (indexPath.row < [pinnedArray count]){

            return UITableViewCellEditingStyleNone;

        } else {

            return UITableViewCellEditingStyleDelete;

        }

    } else {

        return %orig;

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(enabled && useCustomCellSpacing)
        return %orig + separationHeight;
    else
        return %orig;

}

%new
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {

    if(recognizer.state == UIGestureRecognizerStateBegan  && pinnedConvos && enabled){

        CKConversation *convo = [finalConvoArray objectAtIndex: recognizer.view.tag];
        IMChat *chat = [convo chat];
        NSLog(@"the guid : %@", chat.guid);
        NSString *identifier = chat.chatIdentifier;

        BOOL adding = YES;

        NSArray *pinList = [[NSString stringWithContentsOfFile: PINNED_PATH encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
        NSMutableArray *pinListMutable = [pinList mutableCopy];

        for(NSString *string in pinList){

            if([string isEqual:@""]){

                [pinListMutable removeObject: string];

            }

            if([string isEqual: identifier]){

                [pinListMutable removeObject: string];
                NSString *pinListToString = [pinListMutable componentsJoinedByString: @"\n"];
                [pinListToString writeToFile: PINNED_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];

                adding = NO;

            }

        }

        if(adding){

            [self.view.superview makeToast: [NSString stringWithFormat:@"Pinned conversation with %@", convo.name] duration:3.0 position: CSToastPositionBottom];

            [pinListMutable addObject: identifier];
            NSString *pinListToString = [pinListMutable componentsJoinedByString: @"\n"];
            [pinListToString writeToFile: PINNED_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];

        } else {

            [self.view.superview makeToast: [NSString stringWithFormat:@"Unpinned conversation with %@", convo.name] duration:3.0 position: CSToastPositionBottom];
        }

        [table reloadData];

    }

}

%new
- (void)handleRightSwipe:(UISwipeGestureRecognizer *)recognizer {

    if(enabled && messageMarking){

        CKConversation *convo = [finalConvoArray objectAtIndex: recognizer.view.tag];
        BOOL reallyHadUnread = NO;

        if([convo hasUnreadMessages]){
            [convo markAllMessagesAsRead];
            reallyHadUnread = YES;
        }

        IMChat *chat = [convo chat];
        NSString *identifier = chat.chatIdentifier;

        BOOL adding = YES;

        NSArray *unreadList = [[NSString stringWithContentsOfFile: UNREAD_PATH encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
        NSMutableArray *unreadListMutable = [unreadList mutableCopy];

        for(NSString *string in unreadList){

            if([string isEqual:@""]){

                [unreadListMutable removeObject: string];

            }

            if([string isEqual: identifier]){

                [unreadListMutable removeObject: string];
                NSString *unreadListToString = [unreadListMutable componentsJoinedByString: @"\n"];
                [unreadListToString writeToFile: UNREAD_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];

                adding = NO;

            }

        }

        if(adding && !reallyHadUnread){

            [self.view.superview makeToast: [NSString stringWithFormat:@"Marking conversation with %@ unread", convo.name] duration:3.0 position: CSToastPositionBottom];

            [unreadListMutable addObject: identifier];
            NSString *unreadListToString = [unreadListMutable componentsJoinedByString: @"\n"];
            [unreadListToString writeToFile: UNREAD_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];

        } else {

            [self.view.superview makeToast: [NSString stringWithFormat:@"Marking conversation with %@ read", convo.name] duration:3.0 position: CSToastPositionBottom];
        }

        [table reloadData];

    }

}

%end

%hook CKConversationList

- (NSArray *)conversations {

    if(enabled){

        pinnedArray = [[NSString stringWithContentsOfFile: PINNED_PATH encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];

        NSMutableArray *tempArray = [pinnedArray mutableCopy];

        for(NSString *string in pinnedArray){

            if([string isEqual: @""]){

                [tempArray removeObject: string];

            }
        }

        pinnedArray = [[NSArray alloc] initWithArray: tempArray];

        finalConvoArray = [[NSMutableArray alloc] init];

        NSArray * origConvos = %orig;
        NSMutableArray *convoCopy = [%orig mutableCopy];
        NSMutableArray *pinConvos = [[NSMutableArray alloc] init];

        for(id obj in origConvos){

            IMChat *chat = [obj chat];
            NSString *identifier = chat.chatIdentifier;

            for(id pin in pinnedArray){

                if([identifier isEqual: pin]){

                    [convoCopy removeObject: obj];
                    [pinConvos addObject: obj];

                }

            }

        }

        if(pinnedConvos && !sortConvosAlphabetically){

            [pinConvos addObjectsFromArray: convoCopy];
            finalConvoArray = [[NSMutableArray alloc] initWithArray: pinConvos];

        }

        if(!pinnedConvos && !sortConvosAlphabetically){

            finalConvoArray = [%orig mutableCopy];
        }

        if(!pinnedConvos && sortConvosAlphabetically){

            [finalConvoArray addObjectsFromArray: [self sortAlphabetically: [%orig mutableCopy]]];

        }

        if(pinnedConvos && sortConvosAlphabetically){

            [pinConvos addObjectsFromArray: [self sortAlphabetically: convoCopy]];

            finalConvoArray = [[NSMutableArray alloc] initWithArray: pinConvos];

        }

        NSArray *theFinalArray = [[NSArray alloc] initWithArray: finalConvoArray];

        return theFinalArray;

    } else {

        return %orig;

    }

}
%new
- (NSArray *)sortAlphabetically:(NSMutableArray*)array {

    NSArray *permConvos = [[NSArray alloc] initWithArray: array];
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    NSMutableArray *convosSorted = [[NSMutableArray alloc] init];

    for(CKConversation * convo in permConvos){

        NSString *name = convo.name;
        [nameArray addObject: name];

    }

    NSArray *sortedNames = [nameArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

    for(NSString *sortedName in sortedNames){

        for(CKConversation *convo in permConvos){

            NSString *name = convo.name;

            if([sortedName isEqual: name]){

                [convosSorted addObject: convo];

            }

        }

    }

    NSArray *alphaSort = [[NSArray alloc] initWithArray: convosSorted];

    return alphaSort;

}

%end

%hook UIDateLabel

- (id)timeDesignator {

    if(preciseTimestamps && enabled)
        return nil;
    else
        return %orig;

}

%end

%hook CKConversationListCell

-(void)layoutSubviews {

    %orig;

    // Declarations

    UIImageView *chevronView;
    object_getInstanceVariable(self, "_chevronImageView ", (void **)&chevronView);
    UIImageView *unreadImageView;
    object_getInstanceVariable(self, "_unreadIndicatorImageView", (void **)&unreadImageView);
    UIDateLabel* dateLabel;
    object_getInstanceVariable(self, "_dateLabel", (void **)&dateLabel);
    UILabel *senderLabel;
    object_getInstanceVariable(self, "_fromLabel", (void **)&senderLabel);
    UILabel *summaryLabel;
    object_getInstanceVariable(self, "_summaryLabel", (void **)&summaryLabel);
    CKSummaryLabel* backupSummaryLabel;
    object_getInstanceVariable(self, "_backupSummaryLabel", (void **)&backupSummaryLabel);

    // Manipulate Unread Indicator

    if(enabled && useCustomUnreadColor){

        unreadImageView.image = nil;
        unreadImageView.backgroundColor = [UIColor colorWithHexString: unreadImageColor];
        unreadImageView.layer.cornerRadius = unreadImageView.frame.size.width / 2;
        unreadImageView.layer.masksToBounds = YES;

    }

    // Manipulate Sender Label

    if(enabled){

        if(useCustomSenderColor){

            [senderLabel setTextColor: [UIColor colorWithHexString: senderLabelColor]];

        }

    }

    // Manipulate Summary Label

    if(enabled){

        if(useCustomSummaryColor){

            [summaryLabel setTextColor: [UIColor colorWithHexString: summaryLabelColor]];

        }

    }

    // Manipulate Date Label

    if(enabled){

        if(preciseTimestamps){

            [dateLabel setText: [self timeSince: [dateLabel date]]];
            [dateLabel _didUpdateDate];

        }

        if(useCustomDateColor){

            [dateLabel setTextColor: [UIColor colorWithHexString: dateLabelColor]];

        }
    }

    // If name masking mode
    if(nameMaskingMode && enabled){

        senderLabel.text = @"#########";

    }

    // Add pinned label if necessary

    UILabel *pinLabel = (UILabel *)[self.contentView viewWithTag: 900];

    if(pinLabel != nil){

       [pinLabel removeFromSuperview];

    }

    UIFont *smallerSizeFont = [UIFont fontWithName: senderLabel.font.fontName size: (senderLabel.font.pointSize - 8)];
    CGRect rFrame = senderLabel.frame;
    CGSize maxSize = CGSizeMake( CGFLOAT_MAX, CGRectGetWidth([self.contentView bounds]) );
    CGRect textRect = [[senderLabel text] boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:senderLabel.font} context:nil];
    CGSize stringSize = textRect.size;

    if([self tag] < [pinnedArray count] && pinnedConvos && enabled){

        NSString *pinnedNotifier;

        if(useCustomPinnedText)
            pinnedNotifier = customPinnedText;
        else
            pinnedNotifier = @"PINNED";

        CGFloat x = stringSize.width + rFrame.origin.x + 5.0;
        CGFloat y = rFrame.origin.y - 5.0;
        CGFloat width = 200;
        CGFloat height = rFrame.size.height;

        UILabel *pinnedLabel = [[UILabel alloc] initWithFrame: CGRectMake(x, y, width, height)];
        pinnedLabel.font = smallerSizeFont;
        pinnedLabel.textColor = senderLabel.textColor;
        pinnedLabel.text = pinnedNotifier;
        pinnedLabel.tag = 900;
        [self.contentView addSubview: pinnedLabel];

    }

    // Manipulate Backup Summary Label

    if(backupSummaryLabel != nil && enabled){

        backupSummaryLabel.textColor = [UIColor colorWithHexString: summaryLabelColor];

    }

    // Manipulate Tap Selection

    if(enabled && hideTapSelection){

        UIView *selectionView = [[UIView alloc]init];
        selectionView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = selectionView;

    }

}

%new
- (NSString*)timeSince:(NSDate *)date {

    NSTimeInterval timeSince = [date timeIntervalSinceNow];
    NSString *timeAgo;

    if (timeSince > -60) {
        timeAgo = [NSString stringWithFormat:@"%.0f seconds ago", -timeSince];
    }
    else if (timeSince <= -60 && timeSince > -3600){
        if(-timeSince/60 < 1.5){
            timeAgo = [NSString stringWithFormat:@"%.0f minute ago", -timeSince/60];
        }else{
            timeAgo = [NSString stringWithFormat:@"%.0f minutes ago", -timeSince/60];
        }
    }
    else if (timeSince <= -3600 && timeSince > -86400){
        if(-timeSince/60/60 < 1.5){
            timeAgo = [NSString stringWithFormat:@"%.0f hour ago", -timeSince/60/60];
        }else{
            timeAgo = [NSString stringWithFormat:@"%.0f hours ago", -timeSince/60/60];
        }
    }
    else if (timeSince <= -86400 && timeSince > -604800){
        if(-timeSince/24/60/60 < 1.5){
            timeAgo = [NSString stringWithFormat:@"%.0f day ago", -timeSince/24/60/60];
        }else{
             timeAgo = [NSString stringWithFormat:@"%.0f days ago", -timeSince/24/60/60];
        }
    }
    else if (timeSince <= -604800 && timeSince > -2592000){
        if(-timeSince/7/24/60/60 < 1.5){
            timeAgo = [NSString stringWithFormat:@"%.0f week ago", -timeSince/7/24/60/60];
        }else{
            timeAgo = [NSString stringWithFormat:@"%.0f weeks ago", -timeSince/7/24/60/60];
        }
    }
    else if (timeSince <= -2592000 && timeSince > -31536000){
        if(-timeSince/30/24/60/60 < 1.5){
            timeAgo = [NSString stringWithFormat:@"%.0f month ago", -timeSince/30/24/60/60];
        }else{
            timeAgo = [NSString stringWithFormat:@"%.0f months ago", -timeSince/30/24/60/60];
        }
    }
    else {
        if(-timeSince/365/24/60/60 < 1.5){
            timeAgo = [NSString stringWithFormat:@"%.1f year ago", -timeSince/365/24/60/60];
        }else{
            timeAgo = [NSString stringWithFormat:@"%.1f years ago", -timeSince/365/24/60/60];
        }
    }

    return timeAgo;

}

%end

%hook CKHyperlinkBalloonView

-(void)setAttributedText:(id)arg1 {

    if(removeLinkUnderline && enabled){

        NSMutableAttributedString *newString = [[NSMutableAttributedString alloc] initWithAttributedString: arg1];

        [newString removeAttribute:@"NSUnderline" range:(NSRange){0,[newString length]}];

        NSConcreteAttributedString *str = [[NSConcreteAttributedString alloc]initWithAttributedString: newString];

        %orig(str);

    } else {

        %orig;

    }

}

%end

%hook CKConversation

- (BOOL)hasUnreadMessages {

    unreadArray = [[NSString stringWithContentsOfFile: UNREAD_PATH encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];

    NSMutableArray *tempArray = [unreadArray mutableCopy];

    for(NSString *string in unreadArray){

        if([string isEqual: @""]){

            [tempArray removeObject: string];

        }
    }

    BOOL isOnList = NO;

    unreadArray = [[NSArray alloc] initWithArray: tempArray];

    IMChat *chat = [self chat];
    NSString *identifier = chat.chatIdentifier;

    for(id unread in unreadArray){

        if([identifier isEqual: unread]){

            isOnList = YES;

        }

    }

    if(isOnList && messageMarking){

        return YES;

    }else {

        return %orig;

    }

}

%end

static void loadPrefs(){

    enabled = [[BDSettingsManager sharedManager] isEnabled];
    pinnedConvos = [[BDSettingsManager sharedManager] shouldPinConvos];
    messageMarking = [[BDSettingsManager sharedManager] shouldMarkMessages];
    preciseTimestamps = [[BDSettingsManager sharedManager] shouldShowPreciseTimestamps];
    hideSeparatorLines = [[BDSettingsManager sharedManager] shouldHideSeparatorLines];
    hideTapSelection = [[BDSettingsManager sharedManager] shouldHideTapSelection];
    removeLinkUnderline = [[BDSettingsManager sharedManager] shouldRemoveLinkUnderline];
    nameMaskingMode = [[BDSettingsManager sharedManager] shouldMaskNames];
    removeChevron = [[BDSettingsManager sharedManager] shouldRemoveChevron];
    loadMoreMessages = [[BDSettingsManager sharedManager] shouldLoadMoreMessages];
    sortConvosAlphabetically = [[BDSettingsManager sharedManager] shouldSortConvosAlphabetically];

    useCustomTableColor = [[BDSettingsManager sharedManager] useCustomTableColor];
    useCustomSenderColor = [[BDSettingsManager sharedManager] useCustomSenderColor];
    useCustomSummaryColor = [[BDSettingsManager sharedManager] useCustomSummaryColor];
    useCustomDateColor = [[BDSettingsManager sharedManager] useCustomDateColor];
    useCustomUnreadColor = [[BDSettingsManager sharedManager] useCustomUnreadColor];
    useCustomPinnedText = [[BDSettingsManager sharedManager] useCustomPinnedText];
    useCustomCellSpacing = [[BDSettingsManager sharedManager] useCustomCellSpacing];

    tableBackgroundColor = [[BDSettingsManager sharedManager] tableBackgroundColor];
    senderLabelColor = [[BDSettingsManager sharedManager] senderLabelColor];
    summaryLabelColor = [[BDSettingsManager sharedManager] summaryLabelColor];
    dateLabelColor = [[BDSettingsManager sharedManager] dateLabelColor];
    unreadImageColor = [[BDSettingsManager sharedManager] unreadImageColor];
    separationHeight = [[BDSettingsManager sharedManager] separationHeight];
    customPinnedText = [[BDSettingsManager sharedManager] customPinText];

}

static void setupPaths(){

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath: FILE_PATH]){

        [fileManager createDirectoryAtPath: FILE_PATH withIntermediateDirectories:YES attributes:nil error:nil];

    }

    if (![fileManager fileExistsAtPath: PINNED_PATH]){

        [fileManager createFileAtPath: PINNED_PATH contents:nil attributes:nil];

    }

    if (![fileManager fileExistsAtPath: UNREAD_PATH]){

        [fileManager createFileAtPath: UNREAD_PATH contents:nil attributes:nil];

    }

}

%ctor{

    CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterAddObserver(r, NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.brycedev.convos/prefsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    setupPaths();
    [BDSettingsManager sharedManager];
    loadPrefs();

}
