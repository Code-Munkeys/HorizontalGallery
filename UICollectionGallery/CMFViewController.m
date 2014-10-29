/*
 CMFViewController.m
 HorizontalGallery
 
 Developed by Franz Ayestaran on 29/10/14.
 Copyright (c) 2014 Zonk Technology. All rights reserved.
 
 You may use this code in your own projects and upon doing so, you the programmer are solely
 responsible for determining it's worthiness for any given application or task. Here clearly
 states that the code is for learning purposes only and is not guaranteed to conform to any
 programming style, standard, or be an adequate answer for any given problem.
*/

#import "CMFViewController.h"
#import "CMFGalleryCell.h"

@interface CMFViewController ()
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic) int currentIndex;
@property (strong, nonatomic) IBOutlet UILabel *lblPhotosToUpload;

- (IBAction)btnDone:(id)sender;
- (IBAction)btnBack:(id)sender;
- (IBAction)btnTrash:(id)sender;

@property (strong, nonatomic) IBOutlet UIPageControl *pgeScrollLeftRight;
- (IBAction)pgeScrollLeftRight:(id)sender;

@end

@implementation CMFViewController

@synthesize pgeScrollLeftRight;
long pgeScrollLeftRightIndex = 0;
long pgeDeletePoint = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)Initialise
{
    [self loadImages];
    [self setupCollectionView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self Initialise];
}

- (BOOL)prefersStatusBarHidden {
        return YES;
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionView methods

-(void)setupCollectionView {
    [self.collectionView registerClass:[CMFGalleryCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMFGalleryCell *cell = (CMFGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    NSString *imageName = [self.dataArray objectAtIndex:indexPath.row];
    [cell setImageName:imageName];
    [cell updateCell];
    
    pgeScrollLeftRightIndex = indexPath.item;
    pgeScrollLeftRight.currentPage = pgeScrollLeftRightIndex;
    
    NSLog(@"Image Index: %ld",indexPath.item);
    NSLog(@"%Image Asset: %@",[self.dataArray objectAtIndex:pgeScrollLeftRightIndex]);
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

#pragma mark -
#pragma mark Data methods
-(void)loadImages {
    
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    self.dataArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:NULL];
    NSLog(@"Image List:\n%@",self.dataArray);
    pgeScrollLeftRight.numberOfPages = [self.dataArray count];
    //pageControl.currentPage = 0;
}

#pragma mark -
#pragma mark Rotation handling methods

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
(NSTimeInterval)duration {

    // Fade the collectionView out
    [self.collectionView setAlpha:0.0f];
    
    // Suppress the layout errors by invalidating the layout
    [self.collectionView.collectionViewLayout invalidateLayout];
  
    // Calculate the index of the item that the collectionView is currently displaying
    CGPoint currentOffset = [self.collectionView contentOffset];    
    self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  
    // Force realignment of cell being displayed
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    // Fade the collectionView back in
    [UIView animateWithDuration:0.125f animations:^{
        [self.collectionView setAlpha:1.0f];
    }];
    
}

- (IBAction)btnDone:(id)sender
{
}

- (IBAction)btnBack:(id)sender
{
}

- (IBAction)btnTrash:(id)sender
{
    //[self.dataArray removeObjectAtIndex:pgeScrollLeftRightIndex];
    pgeDeletePoint = pgeScrollLeftRightIndex;
    [self setupCollectionView];
    [self.collectionView reloadData];
}

- (IBAction)pgeScrollLeftRight:(id)sender
{
}

@end
