//
//  DetailViewController.m
//  Demo
//
//  Created by Karol Moluszys on 04.04.2016.
//  Copyright © 2016 Karol Moluszys. All rights reserved.
//

#import "DetailViewController.h"
#import "DataManager.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

@implementation DetailViewController

// ----------------------------------------------------------------------------------------------------------------
# pragma mark - Actions -
// ----------------------------------------------------------------------------------------------------------------


- (IBAction)mergeClicked:(id)sender {
    [self mergeExample];
}

- (IBAction)zipClicked:(id)sender {
    [self zipExample];
}

- (IBAction)deferOKClicked:(id)sender {
    [self deferExampleOK];
}

- (IBAction)deferNOTOKClicked:(id)sender {
    [self deferExampleNOTOK];
}

- (IBAction)catchClickedOK:(id)sender {
    [self catchExampleOK];
}

- (IBAction)catchClickedNOTOK:(id)sender {
    [self catchExampleNOTOK];
}

// ----------------------------------------------------------------------------------------------------------------
# pragma mark - Helpers -
// ----------------------------------------------------------------------------------------------------------------


- (void)mergeExample {
    __block NSUInteger counter = 0;
    self.detailDescriptionLabel.text = @"";
    [[DataManager MERGEgetPeopleWithDetails] subscribeNext:^(id x) {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"%@\nSubscribe next count: %@", self.detailDescriptionLabel.text, @(counter++)];
    } error:^(NSError *error) {
        self.detailDescriptionLabel.text = error.localizedDescription;
    }];
}

- (void)zipExample {
    __block NSUInteger counter = 0;
    self.detailDescriptionLabel.text = @"";
    [[DataManager ZIPgetPeopleWithDetails] subscribeNext:^(id x) {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"%@\nSubscribe next count: %@", self.detailDescriptionLabel.text, @(counter++)];
    } error:^(NSError *error) {
        self.detailDescriptionLabel.text = error.localizedDescription;
    }];
}

- (void)deferExampleOK {
    [[DataManager DEFERexampleOK] subscribeNext:^(RACTuple *x) {
        self.detailDescriptionLabel.text = [x description];
    } error:^(NSError *error) {
        self.detailDescriptionLabel.text = error.localizedDescription;
    }];
}

- (void)deferExampleNOTOK {
    [[DataManager DEFERexampleNOTOK] subscribeNext:^(RACTuple *x) {
        self.detailDescriptionLabel.text = [x description];
    } error:^(NSError *error) {
        self.detailDescriptionLabel.text = error.localizedDescription;
    }];
}

- (void)catchExampleOK {
    [[DataManager CATCHgetPersonWithDetailOK] subscribeNext:^(id x) {
        self.detailDescriptionLabel.text = x;
    } error:^(NSError *error) {
        self.detailDescriptionLabel.text = error.localizedDescription;
    }];
}

- (void)catchExampleNOTOK {
    [[DataManager CATCHgetPersonWithDetailNOTOK] subscribeNext:^(id x) {
        self.detailDescriptionLabel.text = x;
    } error:^(NSError *error) {
        self.detailDescriptionLabel.text = error.localizedDescription;
    }];
}

@end
