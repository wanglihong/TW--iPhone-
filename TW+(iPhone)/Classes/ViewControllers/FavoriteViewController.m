//
//  FavoriteViewController.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-28.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "FavoriteViewController.h"

#import "ProfileViewController.h"

#import "FeedTableViewCell.h"




@interface FavoriteViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end




@implementation FavoriteViewController

@synthesize fetchedResultsController=_fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self styleNavigationBarButtonItemWithImage:@"back.png" action:@selector(back:) isLeft:YES];
    
    [self.feedTableView setBackgroundColor:[UIColor whiteColor]];
    [self.feedTableView setSeparatorColor:[UIColor colorWithWhite:0.9 alpha:0.6]];
    
    [self setTitle:NSLocalizedString(@"Favorite", nil)];
    [self updateFavorites];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.fetchedResultsController = nil;
    [self.feedTableView reloadData];
    [self updateFavorites];
}

- (void)updateFavorites {
    
    if (![self favortes] || [self favortes].count == 0) {
        self.feedTableView.alpha = 0;
        
        UILabel *nothingLabel = (UILabel *)[self.view viewWithTag:NO_RESULTS_LABEL_TAG];
        if (!nothingLabel) {
            nothingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            nothingLabel.textColor = THEME_COLOR_TRANSLUCENT;
            nothingLabel.text = NSLocalizedString(@"No favorite", nil);
            nothingLabel.tag = NO_RESULTS_LABEL_TAG;
            nothingLabel.center = self.view.center;
            nothingLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:nothingLabel];
        }
    } else {
        
        self.feedTableView.alpha = 1;
        UILabel *nothingLabel = (UILabel *)[self.view viewWithTag:NO_RESULTS_LABEL_TAG];
        if (nothingLabel) {
            [nothingLabel removeFromSuperview];
        }
    }
}

- (void)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.feedTableView indexPathForSelectedRow];
    ProfileViewController *profileViewController = (ProfileViewController *)[segue destinationViewController];
    profileViewController.document = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSMutableArray *)favortes {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [NSMutableArray arrayWithArray:[defaults objectForKey:@"favorite"]];
    return favorites;
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Document *document = [self.fetchedResultsController objectAtIndexPath:indexPath];
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


#pragma mark -
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
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dId in %@", [self favortes]];
    [fetchRequest setPredicate:predicate];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.feedTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.feedTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.feedTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.feedTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
//                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.feedTableView endUpdates];
}

@end
