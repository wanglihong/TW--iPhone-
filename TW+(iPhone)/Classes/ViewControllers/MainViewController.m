//
//  MainViewController.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-20.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "MainViewController.h"

#import "LoadViewController.h"

#import "LoginViewController.h"

#import "FeedViewController.h"

#import "MainCollectionViewCell.h"

#import "FavoriteViewController.h"

#import "EGORefreshTableHeaderView.h"




@interface MainViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end




@interface MainViewController () <EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end




@interface MainViewController ()
{
    int _lastPosition;
    BOOL _dragging;
    CGFloat lastOffsetY;
    IBOutlet UIBarButtonItem *_leftBarButtonItem;
}

@property (nonatomic, strong) UINavigationController *childViewController;
@property (nonatomic, strong) LoadViewController *loadViewController;

@end




@implementation MainViewController

@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize childViewController = _childViewController;
@synthesize loadViewController = _loadViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setTitle:@"TW+"];
    
    [self wait];
    [self addEGORefreshTableHeaderView];
//    if (!__IOS_0_7_)
        [self styleNavigationBarWithFontName:@"Avenir-Black"];
    [self styleNavigationBarButtonItemWithImage:@"favorite.png" action:@selector(favorites) isLeft:NO];
//    [self styleNavigationBarButtonItemWithImage:@"docs_all" action:@selector(allDocs) isLeft:YES];
//    self.navigationItem.leftBarButtonItem = _leftBarButtonItem;
    
//    [self.collectionView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.6]];
    [self.collectionView setBackgroundColor:THEME_COLOR_FULL];
    [self.view setBackgroundColor:THEME_COLOR_FULL];
    
    if ([self isIOS7]) {
        // xcode4.6 需要注释掉下面这行代码
        self.layout.sectionInset = UIEdgeInsetsMake(64.5, 0, 0.5, 0);
    }
    _lastPosition = self.collectionView.contentOffset.y;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadBrandsFromeRemoteHost)
                                                 name:@"LoadBrandsFromeRemoteHost"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.collectionView reloadData];
}

- (void)wait
{
    _loadViewController = [[LoadViewController alloc] init];
    [self.navigationController.view addSubview:_loadViewController.view];
}

- (void)addEGORefreshTableHeaderView
{
    if (_refreshHeaderView == nil) {
        // xcode 5 使用上面这行代码
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.collectionView.bounds.size.height  + ([self isIOS7] ? 64 : 0), self.view.frame.size.width, self.collectionView.bounds.size.height)];
        // xcode 4 使用下面这行代码
//        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.collectionView.bounds.size.height, self.view.frame.size.width, self.collectionView.bounds.size.height)];
		view.delegate = self;
        view.backgroundColor = THEME_COLOR_FULL;
		[self.collectionView addSubview:view];
		_refreshHeaderView = view;
	}
	[_refreshHeaderView refreshLastUpdatedDate];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)loadBrandsFromeRemoteHost {
    
    if ([self canLoadRequest]) {
        [self.collectionView setContentOffset:CGPointMake(0, -75) animated:YES];
        [_refreshHeaderView performSelector:@selector(egoRefreshScrollViewDidScroll:) withObject:self.collectionView afterDelay:0.4];
        [_refreshHeaderView performSelector:@selector(egoRefreshScrollViewDidEndDragging:) withObject:self.collectionView afterDelay:0.4];
    }
}

- (void)favorites
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FavoriteStoryboard" bundle:nil];
    FavoriteViewController *favoriteViewController = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:favoriteViewController animated:YES];
}

- (void)allDocs
{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowRecent"]) {
        
    } else if ([segue.identifier isEqualToString:@"showFeedViewController"]) {
        FeedViewController *feedViewController = (FeedViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        feedViewController.brand = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
}

- (CGRect)screenCoordinateRect:(UICollectionViewCell *)cell
{
    return CGRectMake(cell.frame.origin.x,
                      cell.frame.origin.y - self.collectionView.contentOffset.y,
                      cell.frame.size.width,
                      cell.frame.size.height);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark - LoginViewControllerDelegate

- (void)loginSuccessed
{
    [self.collectionView setContentOffset:CGPointMake(0, -75) animated:YES];
    [_refreshHeaderView performSelector:@selector(egoRefreshScrollViewDidScroll:) withObject:self.collectionView afterDelay:0.4];
    [_refreshHeaderView performSelector:@selector(egoRefreshScrollViewDidEndDragging:) withObject:self.collectionView afterDelay:0.4];
}


#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainCollectionViewCell *cell = (MainCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Brand *b = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell.logoView setImageWithURL:[NSURL URLWithString:b.iconUrl]];
    [cell.titleLabel setText:b.name];
    [cell.numberLabel setText:b.numsUpdate];
    [cell setNumber:b.numsUpdate.intValue];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        
        if (![cell viewWithTag:7]) {
            UIView *topLine = [[UIView alloc] init];
            topLine.frame = CGRectMake(cell.bottomLine.frame.origin.x, 0, cell.bottomLine.frame.size.width, cell.bottomLine.frame.size.height);
            topLine.tag = 7;
            topLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
            [cell.bgView addSubview:topLine];
        }
        
    } else {
        
        if ([cell viewWithTag:7]) {
            [[cell viewWithTag:7] removeFromSuperview];
        }
    }
    
    return cell;
}


#pragma mark -
#pragma mark - UICollectionViewDelegate

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = THEME_COLOR_DARK;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = nil;
//}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = THEME_COLOR_DARK;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	_reloading = YES;
    
    [[AppAPIClient sharedClient] getPath:@"/api/v1/categories"
                              parameters:[self baseDictionary]
                                 success:^(AFHTTPRequestOperation *operation, id JSON) {
                                     
                                     [JsonAnalyzer analyzeBrand:JSON];
                                     [self doneLoadingTableViewData];
                                     
                                 }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                     SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"错误"
                                                                                      andMessage:[error message]];
                                     [alertView addButtonWithTitle:@"Ok"
                                                              type:SIAlertViewButtonTypeDefault
                                                           handler:^(SIAlertView *alertView) {
                                                               NSLog(@"Ok Button Clicked");
                                                           }];
                                     [alertView show];
                                     [self doneLoadingTableViewData];
                                     
                                 }];
}

- (void)doneLoadingTableViewData {
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    int currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - _lastPosition > 1 && currentPostion > 0) {
        
        if (_dragging) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    else if (_lastPosition - currentPostion > 1) {
        
        if (_dragging) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
    
    _lastPosition = currentPostion;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _dragging = NO;
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}


#pragma mark -
#pragma mark - FeedViewController's navigationController

- (UINavigationController *)childViewController {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
    _childViewController = [storyboard instantiateInitialViewController];
    
    return _childViewController;
}


#pragma mark -
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *context = [StoreManager instance].managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brand" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastUpdate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Root"];
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


#pragma mark -
#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    [self.collectionView performBatchUpdates:^{
//        [self.collectionView reloadData];
//    } completion:^(BOOL finished) {}];
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
}

@end
