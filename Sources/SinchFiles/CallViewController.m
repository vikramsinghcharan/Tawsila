#import "CallViewController.h"
#import "CallViewController+UI.h"
#import <Sinch/SINUIView+Fullscreen.h>
#import "UIImage+animatedGIF.h"

// Usage of gesture recognizers to toggle between front- and back-camera and fullscreen.
//
// * Double tap the local preview view to switch between front- and back-camera.
// * Single tap the local video stream view to make it go full screen.
//     Tap again to go back to normal size.
// * Single tap the remote video stream view to make it go full screen.
//     Tap again to go back to normal size.

@interface CallViewController () <SINCallDelegate>
{
    UIImageView *imgGIF;
}
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *remoteVideoFullscreenGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *localVideoFullscreenGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *switchCameraGestureRecognizer;
@end

@implementation CallViewController

- (id<SINAudioController>)audioController
{
    return [_client audioController];
}

- (id<SINVideoController>)videoController
{
    return [_client videoController];
}

- (void)setCall:(id<SINCall>)call
{
    _call = call;
    _call.delegate = self;
}

#pragma mark - UIViewController Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.call direction] == SINCallDirectionIncoming)
    {
        [self setCallStatusText:@""];
        [self showButtons:kButtonsAnswerDecline];
        [[self audioController] startPlayingSoundFile:[self pathForSound:@"incoming.wav"] loop:YES];
    }
    else
    {
        [self setCallStatusText:@"calling..."];
        [self showButtons:kButtonsHangup];
    }
    
    if ([self.call.details isVideoOffered])
    {
        [self.localVideoView addSubview:[[self videoController] localView]];
        
        [self.localVideoFullscreenGestureRecognizer requireGestureRecognizerToFail:self.switchCameraGestureRecognizer];
       // [[[self videoController] localView] addGestureRecognizer:self.localVideoFullscreenGestureRecognizer];
         [[[self videoController] remoteView] addGestureRecognizer:self.remoteVideoFullscreenGestureRecognizer];
        
        
    }
    
    _call.delegate = self;
    // _client.callClient.delegate = self;
    
    if (_tagType == 1) {
        
        self.localVideoView.hidden = YES;
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"driver_call_icon" withExtension:@"gif"];
        
        imgGIF = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.remoteVideoView.frame.size.width, self.remoteVideoView.frame.size.height)];
        
        [_remoteVideoView addSubview:imgGIF];
       
        UIImage* mygif = [UIImage animatedImageWithAnimatedGIFURL:url];
        imgGIF.image = mygif;
        
        if ([self.lang isEqualToString:@"ar"]) {
            
            CGRect frm = self.answerButton.frame;
            self.answerButton.frame = self.declineButton.frame;
            self.declineButton.frame = frm;
        }
    }
    
    // [self performSelector:@selector(ringStart) withObject:nil afterDelay:2];\
    
    
}

-(void)ringStart
{
    [self setCallStatusText:@"ringing..."];
    [[self audioController] startPlayingSoundFile:[self pathForSound:@"ringback.wav"] loop:YES];
    
}

-(void)method
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"driver_call" withExtension:@"gif"];
    UIImage* mygif = [UIImage animatedImageWithAnimatedGIFURL:url];
    imgGIF.image = mygif;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.remoteUsername.text = [self.call remoteUserId];
    [[self audioController] enableSpeaker];
}

#pragma mark - Call Actions

- (IBAction)accept:(id)sender
{
    [[self audioController] stopPlayingSoundFile];
    [self.call answer];
}

- (IBAction)decline:(id)sender {
    [self.call hangup];
    [self dismiss];
}

- (IBAction)hangup:(id)sender {
    [self.call hangup];
    [self dismiss];
}

- (IBAction)onSwitchCameraTapped:(id)sender
{
    AVCaptureDevicePosition current = self.videoController.captureDevicePosition;
    self.videoController.captureDevicePosition = SINToggleCaptureDevicePosition(current);
}

- (IBAction)onFullScreenTapped:(id)sender {
   
    UIView *view = [sender view];
    if ([view sin_isFullscreen]) {
        view.contentMode = UIViewContentModeScaleAspectFit;
        [view sin_disableFullscreen:YES];
    } else {
        view.contentMode = UIViewContentModeScaleAspectFill;
        [view sin_enableFullscreen:YES];
    }
}

- (void)onDurationTimer:(NSTimer *)unused
{
    NSInteger duration = [[NSDate date] timeIntervalSinceDate:[[self.call details] establishedTime]];
    [self setDuration:duration];
}

#pragma mark - SINCallDelegate

- (void)callDidProgress:(id<SINCall>)call
{
    [self setCallStatusText:@"ringing..."];
    [[self audioController] startPlayingSoundFile:[self pathForSound:@"ringback.wav"] loop:YES];
}

- (void)callDidEstablish:(id<SINCall>)call
{
    [self startCallDurationTimerWithSelector:@selector(onDurationTimer:)];
    [self showButtons:kButtonsHangup];
    [[self audioController] stopPlayingSoundFile];
}

- (void)callDidEnd:(id<SINCall>)call
{
    [self dismiss];
    [[self audioController] stopPlayingSoundFile];
    [self stopCallDurationTimer];
    [[[self videoController] remoteView] removeFromSuperview];
    [[self audioController] disableSpeaker];
}

- (void)callDidAddVideoTrack:(id<SINCall>)call
{
    // [self performSelector:@selector(addVideo) withObject:nil afterDelay:2];
    // UIView *vvv = [[self videoController] remoteView];

    if (_tagType == 1)
    {
        [self performSelectorInBackground:@selector(method) withObject:nil];
       // [self performSelector:@selector(method) withObject:nil afterDelay:1];
    }
    else
    {
        [self.remoteVideoView addSubview:[[self videoController] remoteView]];
    }
}

#pragma mark - Sounds

- (NSString *)pathForSound:(NSString *)soundName
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundName];
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
