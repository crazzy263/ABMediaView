//
//  ABViewController.m
//  ABMediaView
//
//  Created by Andrew Boryk on 01/04/2017.
//  Copyright (c) 2017 Andrew Boryk. All rights reserved.
//

#import "ABViewController.h"

@interface ABViewController ()

@end

@implementation ABViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Sets functionality for this demonstration, visit the function to see different functionality
    [self initializeSettingsForMediaView:self.mediaView];
    
    // Setting which determines whether mediaView should pop up and display in full screen mode
    [self.mediaView setShouldDisplayFullscreen: YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    /// Set the url for the image that will be shown in the mediaView, it will download it and set it to the view
    [self.mediaView setImageURL:@"http://camendesign.com/code/video_for_everybody/poster.jpg" withCompletion:^(UIImage *image, NSError *error) {
        
    }];
    
    /// Set the url for the video that will be shown in the mediaView
    [self.mediaView setVideoURL:@"http://clips.vorwaerts-gmbh.de/VfE_html5.mp4"];
    
    /// Rect that specifies where the mediaView's frame will originate from when presenting, and needs to be converted into its position in the mainWindow
    self.mediaView.originRect = self.mediaView.frame;
    
}

- (void) mediaViewDidPlayVideo: (ABMediaView *) mediaView {
    mediaView.image = nil;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Executes before and after rotation, that way any ABMediaViews can adjust their frames for the new size. Is especially helpful when users are watching landscape videos and rotate their devices between portrait and landscape.
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        
        // Notifies the ABMediaView that the device is about to rotate
        [[NSNotificationCenter defaultCenter] postNotificationName:ABMediaViewWillRotateNotification object:nil];
        
    } completion:^(id  _Nonnull context) {
        
        // Notifies the ABMediaView that the device just finished rotating
        [[NSNotificationCenter defaultCenter] postNotificationName:ABMediaViewDidRotateNotification object:nil];
    }];
}

- (IBAction)showMediaViewAction:(id)sender {
    
    ABMediaView *mediaView = [[ABMediaView alloc] initWithFrame:self.view.frame];

    // Sets functionality for this demonstration, visit the function to see different functionality
    [self initializeSettingsForMediaView:mediaView];
    
    /// Adjust the size ratio for the minimized view of the fullscreen popup. By default, the minimized view is ABMediaViewRatioPresetLandscape
    mediaView.minimizedRatio = ABMediaViewRatioPresetSquare;
    
    // Add space to the bottom of the mediaView when it is minimized. By default, there is 12px of space. More can be added if it is desired to reserve space on the bottom for a UITabbar, UIToolbar, or other content.
    [mediaView setBottomBuffer:8.0f];
    
    // Set the url for the image that will be shown in the mediaView, it will download it and set it to the view
    [mediaView setImageURL:@"http://camendesign.com/code/video_for_everybody/poster.jpg" withCompletion:^(UIImage *image, NSError *error) {
        
    }];
    
    // Set the url for the video that will be shown in the mediaView
    [mediaView setVideoURL:@"http://clips.vorwaerts-gmbh.de/VfE_html5.mp4"];
    
    if ([[[ABMediaView sharedManager] mediaViewQueue] count]) {
        [[ABMediaView sharedManager] queueMediaView:mediaView];
        
        [[ABMediaView sharedManager] showNextMediaView];
    }
    else {
        [[ABMediaView sharedManager] queueMediaView:mediaView];
    }
    
}

- (void) initializeSettingsForMediaView: (ABMediaView *) mediaView {
//    mediaView.delegate = self;
    
    mediaView.backgroundColor = [UIColor blackColor];
    
    // Changing the theme color changes the color of the play indicator as well as the progress track
    [mediaView setThemeColor:[UIColor redColor]];
    
    // Enable progress track to show at the bottom of the view
    [mediaView setShowTrack:YES];
    
    // Allow video to loop once reaching the end
    [mediaView setAllowLooping:YES];
    
    // Allows toggling for funtionality which would show remaining time instead of total time on the right label on the track
    [mediaView setShowRemainingTime:YES];
    
    // Allows toggling for functionality which would allow the mediaView to be swiped away to the bottom right corner, and allows the user to interact with the underlying interface while the mediaView sits there. Video continues to play if already playing, and the user can swipe right to dismiss the minimized view.
    [mediaView setCanMinimize: YES];
    
    /// Change the font for the labels on the track
    [mediaView setTrackFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:12.0f]];
    
    // Setting the contentMode to aspectFit will set the videoGravity to aspect as well
    mediaView.contentMode = UIViewContentModeScaleAspectFit;
    
    // If you desire to have the image to fill the view, however you would like the videoGravity to be aspect fit, then you can implement this functionality
    //    self.mediaView.contentMode = UIViewContentModeScaleAspectFill;
    //    [self.mediaView changeVideoToAspectFit: YES];
    
    // If the imageview is not in a reusable cell, and you wish that the image not disappear for a split second when reloaded, then you can enable this functionality
    mediaView.imageViewNotReused = YES;
}
@end
