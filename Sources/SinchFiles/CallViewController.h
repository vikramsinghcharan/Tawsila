#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>

// #import "AppDelegate.h"
 #import "SINUIViewController.h"

typedef enum {
  kButtonsAnswerDecline,
  kButtonsHangup,
} EButtonsBar;

@interface CallViewController : SINUIViewController

@property (weak, nonatomic) IBOutlet UILabel *remoteUsername;
@property (weak, nonatomic) IBOutlet UILabel *callStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UIButton *endCallButton;
@property (weak, nonatomic) IBOutlet UIView *remoteVideoView;
@property (weak, nonatomic) IBOutlet UIView *localVideoView;

@property (nonatomic, readwrite, strong) NSTimer *durationTimer;

@property (nonatomic, readwrite, strong) id<SINCall> call;

@property (strong, nonatomic) id<SINClient> client;

@property (nonatomic,readwrite) NSInteger tagType;

@property (nonatomic,strong) NSString *lang;

- (IBAction)accept:(id)sender;
- (IBAction)decline:(id)sender;
- (IBAction)hangup:(id)sender;



@end
