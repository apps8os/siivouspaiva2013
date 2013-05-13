//
//  DetailViewController.m
//  Siivouspaiva
//
//  Created by Fabian on 26.03.13.
//  Copyright (c) 2013 Fabian Häusler. All rights reserved.
//

#import "DetailViewController.h"
#import "WebLinkViewController.h"
#import "eventSpot.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel3;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel4;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel5;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel6;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel7;

@property (weak, nonatomic) IBOutlet UIImageView *cat0pic;
@property (weak, nonatomic) IBOutlet UIImageView *cat1pic;
@property (weak, nonatomic) IBOutlet UIImageView *cat2pic;
@property (weak, nonatomic) IBOutlet UIImageView *cat3pic;
@property (weak, nonatomic) IBOutlet UIImageView *cat4pic;
@property (weak, nonatomic) IBOutlet UIImageView *cat5pic;
@property (weak, nonatomic) IBOutlet UIImageView *cat6pic;
@property (weak, nonatomic) IBOutlet UIImageView *cat7pic;
@property (weak, nonatomic) IBOutlet UIImageView *cat8pic;
@property (weak, nonatomic) IBOutlet UIImageView *cat9pic;
@property (weak, nonatomic) IBOutlet UIImageView *catNpic;

@property (weak, nonatomic) IBOutlet UILabel *catText;

@property (weak, nonatomic) IBOutlet UILabel *cat0text;
@property (weak, nonatomic) IBOutlet UILabel *cat1text;
@property (weak, nonatomic) IBOutlet UILabel *cat2text;
@property (weak, nonatomic) IBOutlet UILabel *cat3text;
@property (weak, nonatomic) IBOutlet UILabel *cat4text;
@property (weak, nonatomic) IBOutlet UILabel *cat5text;
@property (weak, nonatomic) IBOutlet UILabel *cat6text;
@property (weak, nonatomic) IBOutlet UILabel *cat7text;
@property (weak, nonatomic) IBOutlet UILabel *cat8text;
@property (weak, nonatomic) IBOutlet UILabel *cat9text;
@property (weak, nonatomic) IBOutlet UILabel *catNtext;


@end

@implementation DetailViewController
@synthesize tableView = _tableView;
@synthesize headerView;
@synthesize mapView = _mapView;
@synthesize infoContainer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [headerView removeFromSuperview];
    self.tableView.tableHeaderView = headerView;
    
    self.mapView.delegate = self;
    
    //infoContainer.height = descriptionLabel.y+descriptionLabel.height+20;
    //headerView.frame.size.height = infoContainer.frame.origin.y+infoContainer.frame.size.height;
    
    
    // star Button
    UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *starButtonImage = [UIImage imageNamed:@"icon-star-line"];
    UIImage *starButtonImagePressed = [UIImage imageNamed:@"icon-star-line-active"];
    [starButton setBackgroundImage:starButtonImage forState:UIControlStateNormal];
    [starButton setBackgroundImage:starButtonImagePressed forState:UIControlStateHighlighted];
    [starButton addTarget:self action:@selector(starringAction) forControlEvents:UIControlEventTouchUpInside]; // add staring function!
    starButton.frame = CGRectMake(0, 0, 45, 44);
    UIView *starButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
    starButtonView.bounds = CGRectOffset(starButtonView.bounds, -5, 0);
    [starButtonView addSubview:starButton];
    UIBarButtonItem *starButtonItem = [[UIBarButtonItem alloc] initWithCustomView:starButtonView];
    self.navigationItem.rightBarButtonItem = starButtonItem;
     
    self.catText.font = [UIFont fontWithName:@"colaborate-bold" size:15];
    self.cat0text.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    self.cat1text.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    self.cat2text.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    self.cat3text.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    self.cat4text.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    self.cat5text.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    self.cat6text.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    self.cat7text.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    self.cat8text.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    self.cat9text.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    self.catNtext.font = [UIFont fontWithName:@"colaborate-regular" size:15];
    
    if (self.detailEvent) {
        // Navigation Controller Title 
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 32)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        titleLabel.text = self.detailEvent.eventName;
        titleLabel.font = [UIFont fontWithName:@"colaborate-bold" size:20];
        titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.navigationItem.titleView = titleLabel;
        
        
        // title text fields
        titleText.text = self.detailEvent.eventName;
        titleText.font = [UIFont fontWithName:@"colaborate-bold" size:18];
        NSString *addressString = self.detailEvent.eventAddress;
        addressString = [addressString stringByReplacingOccurrencesOfString:@", Suomi"
                                                                 withString:@""];
        addressString = [addressString stringByReplacingOccurrencesOfString:@", Finland"
                                                                 withString:@""];
        addressText.text = addressString;
        addressText.font = [UIFont fontWithName:@"colaborate-regular" size:15];
        
        
        // Event Discription
        eventDescriptionField.text = self.detailEvent.description;
        eventDescriptionField.font = [UIFont fontWithName:@"colaborate-regular" size:15];
        eventDescriptionField.numberOfLines = 0;
        [eventDescriptionField sizeToFit];
               
        
        // Tags setting
        CGRect frameMT = self.catText.frame;
        frameMT.origin.y = eventDescriptionField.frame.size.height+100;
        self.catText.frame = frameMT;
        int numberOfTags = 0;
        
        CGRect frameText = self.cat1text.frame;
        frameText.origin.y = eventDescriptionField.frame.size.height+100;
        CGRect framePic = self.cat1pic.frame;
        framePic.origin.y = eventDescriptionField.frame.size.height+103;
        if ([self.detailEvent.tags rangeOfString:@"0"].location != NSNotFound) {
            numberOfTags += 1;
            self.cat0pic.hidden = NO;
            self.cat0text.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.cat0text.frame = frameText;
            self.cat0pic.frame = framePic;
        }
        if ([self.detailEvent.tags rangeOfString:@"1"].location != NSNotFound) {
            numberOfTags += 1;
            self.cat1pic.hidden = NO;
            self.cat1text.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.cat1text.frame = frameText;
            self.cat1pic.frame = framePic;
        }
        if ([self.detailEvent.tags rangeOfString:@"2"].location != NSNotFound) {
            numberOfTags += 1;
            self.cat2pic.hidden = NO;
            self.cat2text.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.cat2text.frame = frameText;
            self.cat2pic.frame = framePic;
        }
        if ([self.detailEvent.tags rangeOfString:@"3"].location != NSNotFound) {
            numberOfTags += 1;
            self.cat3pic.hidden = NO;
            self.cat3text.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.cat3text.frame = frameText;
            self.cat3pic.frame = framePic;
        }
        if ([self.detailEvent.tags rangeOfString:@"4"].location != NSNotFound) {
            numberOfTags += 1;
            self.cat4pic.hidden = NO;
            self.cat4text.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.cat4text.frame = frameText;
            self.cat4pic.frame = framePic;
        }
        if ([self.detailEvent.tags rangeOfString:@"5"].location != NSNotFound) {
            numberOfTags += 1;
            self.cat5pic.hidden = NO;
            self.cat5text.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.cat5text.frame = frameText;
            self.cat5pic.frame = framePic;
        }
        if ([self.detailEvent.tags rangeOfString:@"6"].location != NSNotFound) {
            numberOfTags += 1;
            self.cat6pic.hidden = NO;
            self.cat6text.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.cat6text.frame = frameText;
            self.cat6pic.frame = framePic;
        }
        if ([self.detailEvent.tags rangeOfString:@"7"].location != NSNotFound) {
            numberOfTags += 1;
            self.cat7pic.hidden = NO;
            self.cat7text.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.cat7text.frame = frameText;
            self.cat7pic.frame = framePic;
        }
        if ([self.detailEvent.tags rangeOfString:@"8"].location != NSNotFound) {
            numberOfTags += 1;
            self.cat8pic.hidden = NO;
            self.cat8text.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.cat8text.frame = frameText;
            self.cat8pic.frame = framePic;
        }
        if ([self.detailEvent.tags rangeOfString:@"9"].location != NSNotFound) {
            numberOfTags += 1;
            self.cat9pic.hidden = NO;
            self.cat9text.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.cat9text.frame = frameText;
            self.cat9pic.frame = framePic;
        }
        if ([self.detailEvent.tags isEqualToString:@""] || ([self.detailEvent.tags rangeOfString:@"n"].location != NSNotFound)) {
            numberOfTags += 1;
            self.catNpic.hidden = NO;
            self.catNtext.hidden = NO;
            frameText.origin.y += 23;
            framePic.origin.y += 23;
            self.catNtext.frame = frameText;
            self.catNpic.frame = framePic;
        }
        
        
        // link setting
        if ([self.detailEvent.link.absoluteString isEqual: @""]) {
            [buttonLinkToEvent setEnabled:NO];
        } else {
            [buttonLinkToEvent setEnabled:YES];
        }
        //UIFont* font3 = [UIFont fontWithName:@"colaborate-bold" size:20];
        //UIFont* font4 = [UIFont fontWithName:@"colaborate-regular" size:20];
        //NSLog(@"Timeslider.y + height: %f, %f", eventDescriptionField.frame.origin.y, eventDescriptionField.frame.size.height);
        //NSLog(@"NewView.y + height: %f, %f", self.timeInfoView.frame.origin.y, self.timeInfoView.frame.size.height);
        NSLog(@"orginalPos: %f", self.timeInfoView.frame.origin.y);
        CGRect frameIV = self.timeInfoView.frame;
        frameIV.origin.y += eventDescriptionField.frame.size.height+numberOfTags*23;
        self.timeInfoView.frame = frameIV;
        
        NSLog(@"endPos: %f", self.timeInfoView.frame.origin.y);
        
        CGFloat const inMin = 800.0;
        CGFloat const inMax = 2000.0;
        CGFloat const outMin1 = 16.0;
        CGFloat const outMax1 = 304.0;
        CGFloat const outMin2 = 17.0;
        CGFloat const outMax2 = 305.0;
        
        CGFloat inStart = ([self.detailEvent.beginHour floatValue]*100)+
                           [self.detailEvent.beginMinute floatValue];
        CGFloat inEnd = ([self.detailEvent.endHour floatValue]*100)+
                         [self.detailEvent.endMinute floatValue];
        CGFloat newStart = outMin1 + (outMax1 - outMin1) * (inStart - inMin) / (inMax - inMin);
        CGFloat newWidth = (outMin2 + (outMax2 - outMin2) * (inEnd - inMin) / (inMax - inMin))-newStart;
        
        timeSlider.frame = CGRectMake(  newStart, timeSlider.frame.origin.y,
                                        newWidth, timeSlider.frame.size.height);
        
        
        self.timeLabel1.font = [UIFont fontWithName:@"colaborate-regular" size:15];
        self.timeLabel2.font = [UIFont fontWithName:@"colaborate-regular" size:15];
        self.timeLabel3.font = [UIFont fontWithName:@"colaborate-regular" size:15];
        self.timeLabel4.font = [UIFont fontWithName:@"colaborate-regular" size:15];
        self.timeLabel5.font = [UIFont fontWithName:@"colaborate-regular" size:15];
        self.timeLabel6.font = [UIFont fontWithName:@"colaborate-regular" size:15];
        self.timeLabel7.font = [UIFont fontWithName:@"colaborate-regular" size:15];
        
        // Center Map to Event-Location
        CLLocationCoordinate2D eventLocation = CLLocationCoordinate2DMake([self.detailEvent.latitude doubleValue], [self.detailEvent.longitude doubleValue]);
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(eventLocation, 400, 400);
        [self.mapView setRegion:viewRegion animated:NO];
        
        // Add Event Annotation
        eventSpot *annotation = [[eventSpot alloc] initWithName:self.detailEvent.eventName address:nil coordinate:eventLocation identifier:nil];
        [self.mapView addAnnotation:annotation];
        
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"icon-back.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    UIImage *backBtnActiveImage = [UIImage imageNamed:@"icon-back-active.png"]  ;
    [backBtn setBackgroundImage:backBtnActiveImage forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 40, 44);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)starringAction
{
    NSLog(@"Element starred");
    //add Element to strred list
    // chnage icon image
}



// set custom annotation image
- (MKAnnotationView *)mapView:(MKMapView *)newMapView viewForAnnotation:(id )newAnnotation {
    MKAnnotationView *a = [ [ MKAnnotationView alloc ] initWithAnnotation:newAnnotation reuseIdentifier:@"currentloc"];
    if ( a == nil )
        a = [ [ MKAnnotationView alloc ] initWithAnnotation:newAnnotation reuseIdentifier: @"currentloc" ];
    a.image = [ UIImage imageNamed:@"map-marker.png" ];
    return a;
}

// share sheet
- (IBAction)sendPost:(id)sender
{
    NSArray *activityItems;
    NSString *shareText = [NSString stringWithFormat:@"Join the Siivouspäivä event: %@ in %@", self.detailEvent.eventName, self.detailEvent.eventAddress];
    UIImage *shareImage = [UIImage imageNamed:@"siivouspaiva-logo.png"];
    activityItems = @[shareText, shareImage];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        CGFloat mapViewBaselineY = -(self.mapView.frame.size.height-150)/2+500;
        CGFloat y = mapViewBaselineY + scrollView.contentOffset.y/2;
        self.mapView.frame = CGRectMake(0, y, self.mapView.frame.size.width, self.mapView.frame.size.height);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ([self tableView:tableView titleForHeaderInSection:section] != nil) ? 20 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    
    return header;
}


 

#pragma mark - Seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToWebView"]) {
        ((WebLinkViewController*)segue.destinationViewController).eventWithLink = self.detailEvent;
    }
}


@end
