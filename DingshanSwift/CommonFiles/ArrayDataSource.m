//
//  ArrayDataSource.h
//  objc.io example project (issue #1)
//

#import "ArrayDataSource.h"


@interface ArrayDataSource ()

@property (atomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *firstRowIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end


@implementation ArrayDataSource

- (id)init
{
    return nil;
}

- (id)initWithcellIdentifier:(NSString *)aCellIdentifier
      withFirstRowIdentifier:(NSString *)firstRowIdentifier
          configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray new];
        self.cellIdentifier = aCellIdentifier;
        self.firstRowIdentifier = firstRowIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)initWithcellIdentifier:(NSString *)aCellIdentifier
          configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray new];
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.items.count) {
        return self.items[(NSUInteger) indexPath.row];
    }else{
        return nil;
    }
}

- (void)appendWithItems:(NSArray *)anItems
{
    if (anItems != nil) {
       [self.items addObjectsFromArray:anItems];
    }
    
}

- (void)removeAllItems
{
    [self.items removeAllObjects];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //DLog(@"\n--------*---23-----numberOfRowsInSection:%d", self.items.count);
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DLog(@"\n--------*--------cellForRowAtIndexPath:%d", indexPath.row);
    UITableViewCell *cell = nil;
    if (indexPath.row == 0 && [self.firstRowIdentifier isKindOfClass:[NSString class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:self.firstRowIdentifier
                                               forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                               forIndexPath:indexPath];
    }
    if (indexPath.row < self.items.count) {
        id item = [self itemAtIndexPath:indexPath];
        self.configureCellBlock(cell, item);
    }
    return cell;
}

@end
