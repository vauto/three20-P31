//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Three20/TTListDataSource.h"

#import "Three20/TTGlobalCore.h"

#import "Three20/TTTableItem.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTListDataSource

@synthesize items = _items;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithItems:(NSArray*)items {
  if (self = [self init]) {
    _items = [items mutableCopy];
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_items);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TTListDataSource*)dataSourceWithObjects:(id)object,... {
  NSMutableArray* items = [NSMutableArray array];
  va_list ap;
  va_start(ap, object);
  while (object) {
    [items addObject:object];
    object = va_arg(ap, id);
  }
  va_end(ap);

  return [[[self alloc] initWithItems:items] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TTListDataSource*)dataSourceWithItems:(NSArray*)items {
  return [[[self alloc] initWithItems:items] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _items.count;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath {
  if (indexPath.row < _items.count) {
    return [_items objectAtIndex:indexPath.row];
  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object {
  NSUInteger index = [_items indexOfObject:object];
  if (index != NSNotFound) {
    return [NSIndexPath indexPathForRow:index inSection:0];
  }
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*)items {
  if (!_items) {
    _items = [[NSMutableArray alloc] init];
  }
  return _items;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSIndexPath*)indexPathOfItemWithUserInfo:(id)userInfo {
  for (NSInteger i = 0; i < _items.count; ++i) {
    TTTableItem* item = [_items objectAtIndex:i];
    if ([NSObject value: item.userInfo isEqual:userInfo]) {
      return [NSIndexPath indexPathForRow:i inSection:0];
    }
  }
  return nil;
}


@end
