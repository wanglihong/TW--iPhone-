//
//  RecentViewController.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-12-12.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "RecentViewController.h"
#import "UITableView+Animates.h"
#import "ProfileViewController.h"
#import "FeedTableViewCell.h"

@interface RecentViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RecentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentPage = 0;
    _pageLimit = 10;
    _theEnd = NO;
    _localDocs = [NSMutableArray array];
    
    [self setTitle:@"All"];
    [self.recentTableView setBackgroundColor:[UIColor whiteColor]];
    [self.recentTableView setSeparatorColor:[UIColor colorWithWhite:0.9 alpha:0.6]];
    
    NSManagedObjectContext *context = [StoreManager instance].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchOffset:_currentPage * _pageLimit];
    [fetchRequest setFetchLimit:_pageLimit];
    NSError *error;
    NSArray *fetchedResult = [context executeFetchRequest:fetchRequest error:&error];

    [_localDocs addObjectsFromArray:fetchedResult];
    [self.recentTableView reloadData];
    
//    [self performSelector:@selector(loadRecentDocuments) withObject:nil afterDelay:1.0];
}

- (void)loadRecentDocuments {
    
    if ([self canLoadRequest]) {
        
        [[AppAPIClient sharedClient] getPath:@"/api/v1/documents"
                                  parameters:[self baseDictionary]
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {

                                         [JsonAnalyzer analyzeDocument:JSON inBrand:nil];
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         
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
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         
                                     }];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.recentTableView indexPathForSelectedRow];
    ProfileViewController *profileViewController = (ProfileViewController *)[segue destinationViewController];
    profileViewController.document = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
//    return [sectionInfo numberOfObjects];
    return [_localDocs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    Document *document = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Document *document = [_localDocs objectAtIndex:indexPath.row];
    FeedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FeedTableViewCell"];
    
    cell.nameLabel.text = document.name;
    cell.updateLabel.text = document.describe;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ ago", document.convertedUpdateTime];
    cell.likeCountLabel.text = [NSString stringWithFormat:@"type %@", document.fileType];
    cell.commentCountLabel.text = [NSString stringWithFormat:@"size %@", document.convertedFileSize];
    
    [cell.profileImageView setImageWithURL:[NSURL URLWithString:document.iconUrl]];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBackgroundView.backgroundColor = THEME_COLOR_DARK;
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *lastIndexPath = [[self.recentTableView indexPathsForVisibleRows] lastObject];
    if (lastIndexPath.row == [self tableView:self.recentTableView numberOfRowsInSection:0] - 1) {
        _currentPage++;
        
        NSManagedObjectContext *context = [StoreManager instance].managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchOffset:_currentPage * _pageLimit];
        [fetchRequest setFetchLimit:_pageLimit];
        NSError *error;
        NSArray *fetchedResult = [context executeFetchRequest:fetchRequest error:&error];
        [_localDocs addObjectsFromArray:fetchedResult];
        [self.recentTableView reloadData];
    }
}

#pragma mark
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *context = [StoreManager instance].managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchOffset:_currentPage * _pageLimit];
    [fetchRequest setFetchLimit:_pageLimit];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand.cId LIKE[cd] %@", self.brand.cId];
//    [fetchRequest setPredicate:predicate];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


#pragma mark
#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    [self.recentTableView reloadData:YES];
    [self.recentTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
