//
//  ViewController.m
//  cdbfapi-ios-example
//
//  Created by Sergey Chehuta on 17/09/2017.
//  Copyright © 2017 WhiteTown. All rights reserved.
//

#import "ViewController.h"
#import <cdbfapi/cdbfapi.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewS;
@property (weak, nonatomic) IBOutlet UITableView *tableViewD;

@property (strong, nonatomic) cdbfapi *dbf;

@end

@implementation ViewController

#define cellID @"Cell"

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableViewD registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.tableViewS registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (IBAction)openDBF:(id)sender
{
    NSString *filename = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"example.dbf"];

    self.dbf = [cdbfapi new];
    [self.dbf openDBFfile:filename];

    [self.dbf setDateFormat:@"dmy"];

    [self.tableViewS reloadData];
    [self.tableViewD reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.dbf) return 0;

    if ([tableView isEqual:self.tableViewS])
        return [self.dbf fieldCount];

    if ([tableView isEqual:self.tableViewD])
        return [self.dbf recCount];

    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if ([tableView isEqual:self.tableViewS])
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %c(%ld.%ld)",
                              [self.dbf fieldName:indexPath.row],
                              [self.dbf fieldType:indexPath.row],
                              (long)[self.dbf fieldLength:indexPath.row],
                              (long)[self.dbf fieldDecimal:indexPath.row]
                              ];
    }

    if ([tableView isEqual:self.tableViewD])
    {
        NSMutableArray *data = [NSMutableArray new];

        [self.dbf getRecord:indexPath.row];

        for(NSInteger field = 0; field < [self.dbf fieldCount]; field++)
        {
            [data addObject: [[self.dbf getString:field] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ? : @""];
            /*
            if ([self.dbf fieldType:field] == 'D')
            {
                NSDate *date = [self.dbf getDateTime:field];
                NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                                      dateStyle:NSDateFormatterShortStyle
                                                                      timeStyle:NSDateFormatterFullStyle];
                NSLog(@"%@",dateString);
            }
             */
        }
        cell.textLabel.text = [data componentsJoinedByString:@", "];
    }

    return cell;
}

@end
