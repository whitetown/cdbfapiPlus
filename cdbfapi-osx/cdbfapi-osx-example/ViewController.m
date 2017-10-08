//
//  ViewController.m
//  cdbfapi-osx-example
//
//  Created by Sergey Chehuta on 17/09/2017.
//  Copyright © 2017 WhiteTown. All rights reserved.
//

#import "ViewController.h"
#import <cdbfapi/cdbfapi.h>

@interface ViewController() <NSTabViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableViewS;
@property (weak) IBOutlet NSTableView *tableViewD;

@property (strong) cdbfapi *dbf;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)openTap:(id)sender
{
    while(self.tableViewS.numberOfColumns)
    [self.tableViewS removeTableColumn:[self.tableViewS.tableColumns firstObject]];

    while(self.tableViewD.numberOfColumns)
    [self.tableViewD removeTableColumn:[self.tableViewD.tableColumns firstObject]];

    NSString *filename =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"example.dbf"];

    self.dbf = [cdbfapi new];

    self.dbf = [cdbfapi new];

    if ([self.dbf openDBFfile:filename])
    {
        [self.dbf setDateFormat:@"dmy"];

        NSTableColumn *tc = [NSTableColumn new];
        tc.title = @"Fields";
        [self.tableViewS addTableColumn:tc];

        for(NSInteger field = 0; field < [self.dbf fieldCount]; field++)
        {
            NSTableColumn *tc = [NSTableColumn new];
            tc.title = [self.dbf fieldName:field];
            [self.tableViewD addTableColumn:tc];
        }
    }

    [self.tableViewS reloadData];
    [self.tableViewD reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (!self.dbf) return 0;

    if ([tableView isEqual:self.tableViewS])
        return [self.dbf fieldCount];

    if ([tableView isEqual:self.tableViewD])
        return [self.dbf recCount];

    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *text = @"";

    if ([tableView isEqual:self.tableViewS])
    {
        text = [NSString stringWithFormat:@"%@ %c(%ld.%ld)",
                [self.dbf fieldName:row],
                [self.dbf fieldType:row],
                [self.dbf fieldLength:row],
                [self.dbf fieldDecimal:row]
                ];
    }

    if ([tableView isEqual:self.tableViewD])
    {
        [self.dbf getRecord:row];

        NSInteger field = [self.tableViewD.tableColumns indexOfObject:tableColumn];
        text = [self.dbf getString:field];
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

    NSCell *cell = [[NSCell alloc] initTextCell:text];
    return cell;
}


@end
