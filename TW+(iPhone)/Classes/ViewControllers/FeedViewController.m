//
//  FeedViewController.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-21.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "FeedViewController.h"

#import "ProfileViewController.h"

#import "FeedTableViewCell.h"

#import "UITableView+Animates.h"




@interface FeedViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end




@implementation FeedViewController

@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize brand = _brand;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self styleNavigationBarButtonItemWithImage:@"back.png" action:@selector(back:) isLeft:YES];
    [self.feedTableView setBackgroundColor:[UIColor whiteColor]];
    [self.feedTableView setSeparatorColor:[UIColor colorWithWhite:0.9 alpha:0.6]];
    [self setTitle:self.brand.name];
    [self updateDocuments];
    
    if ([self.brand.numsUpdate integerValue] != 0 || [self.brand hasUpdate]) {
        [self performSelector:@selector(loadDocumentsOfBrand:) withObject:_brand afterDelay:1.0];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)updateDocuments {
    
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        self.feedTableView.alpha = 0;
        
        UILabel *nothingLabel = (UILabel *)[self.view viewWithTag:NO_RESULTS_LABEL_TAG];
        if (!nothingLabel) {
            nothingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            nothingLabel.textColor = THEME_COLOR_TRANSLUCENT;
            nothingLabel.tag = NO_RESULTS_LABEL_TAG;
            nothingLabel.center = self.view.center;
            nothingLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:nothingLabel];
            
            NSString *description = [NSString stringWithFormat:@"%@ %@ %@",  NSLocalizedString(@"Now nothing about", nil), self.brand.name, NSLocalizedString(@"Related docs", nil)];
            nothingLabel.text = description;
        }
    } else {
        
        self.feedTableView.alpha = 1;
        UILabel *nothingLabel = (UILabel *)[self.view viewWithTag:NO_RESULTS_LABEL_TAG];
        if (nothingLabel) {
            [nothingLabel removeFromSuperview];
        }
    }
}

- (BOOL)isPush
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        return YES;
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        return NO;
    }
    return YES;
}

- (void)loadDocumentsOfBrand:(Brand *)brand {
    
    if ([self canLoadRequest]) {
        
        [[AppAPIClient sharedClient] getPath:@"/api/v1/documents"
                                  parameters:[self paramsWithBrand:brand]
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                         
                                         [JsonAnalyzer analyzeDocument:JSON inBrand:brand];
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

- (NSDictionary *)paramsWithBrand:(Brand *)brand {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self baseDictionary]];
    [dic setValue:brand.cId forKey:@"category_ids"];
    return dic;
}

- (void)back:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.feedTableView indexPathForSelectedRow];
    ProfileViewController *profileViewController = (ProfileViewController *)[segue destinationViewController];
    profileViewController.document = [self.fetchedResultsController objectAtIndexPath:indexPath];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand.cId LIKE[cd] %@", self.brand.cId];
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.feedTableView reloadData:YES];
    [self updateDocuments];
}

@end
