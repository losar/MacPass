//
//  MPAttachmentTableViewDelegate.m
//  MacPass
//
//  Created by Michael Starke on 17.07.13.
//  Copyright (c) 2013 HicknHack Software GmbH. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "MPAttachmentTableViewDelegate.h"

#import "MPDocument.h"
#import "MPEntryInspectorViewController.h"
#import "MPSelectedAttachmentTableCellView.h"

#import "KPKEntry.h"
#import "KPKBinary.h"

#import "HNHTableRowView.h"

@implementation MPAttachmentTableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  NSTableView *tableView = [notification object];
  MPDocument *document = [[[tableView window] windowController] document];
  NSIndexSet *allColumns = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[tableView tableColumns] count])];
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [document.selectedEntry.binaries count] )];
  [tableView reloadDataForRowIndexes:indexSet columnIndexes:allColumns];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  /* Decide what view to use */
  MPDocument *document = [[[tableView window] windowController] document];
  NSIndexSet *selectedIndexes = [tableView selectedRowIndexes];
  NSTableCellView *view;
  if([selectedIndexes containsIndex:row]) {
    MPSelectedAttachmentTableCellView *cellView  = [tableView makeViewWithIdentifier:@"SelectedCell" owner:tableView];
    [cellView.saveButton setTag:row];
    [cellView.saveButton setAction:@selector(saveAttachment:)];
    [cellView.saveButton setTarget:self.viewController];
    [cellView.removeButton setTag:row];
    [cellView.removeButton setAction:@selector(removeAttachment:)];
    [cellView.removeButton setTarget:nil];
    [cellView.removeButton setTarget:self.viewController];
    view = cellView;
  }
  else {
    view = [tableView makeViewWithIdentifier:@"NormalCell" owner:tableView];
  }
  /* Bind view */
  KPKEntry *entry = document.selectedEntry;
  NSAssert([entry.binaries count] > row, @"Indes needs to be valid for binaries");
  KPKBinary *binary = entry.binaries[row];
  [[view textField] bind:NSValueBinding toObject:binary withKeyPath:@"name" options:nil];
  [[view imageView] setImage:[[NSWorkspace sharedWorkspace] iconForFileType:[binary.name pathExtension]]];
  return view;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
  HNHTableRowView *view = nil;
  view = [[HNHTableRowView alloc] init];
  view.selectionCornerRadius = 7;
  return view;
}

@end
