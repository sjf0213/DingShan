//
//  ArrayDataSource.h
//  objc.io example project (issue #1)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);


@interface ArrayDataSource : NSObject <UITableViewDataSource>

@property (atomic, readonly) NSMutableArray *items;

- (id)initWithcellIdentifier:(NSString *)aCellIdentifier
      withFirstRowIdentifier:(NSString *)firstRowIdentifier
          configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)initWithcellIdentifier:(NSString *)aCellIdentifier
    configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)appendWithItems:(NSArray *)anItems;

- (void)removeAllItems;

@end
