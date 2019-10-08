//
//  TableViewController.swift
//  UITableViewSectionAtTheBottom
//
//  Created by Max Rozdobudko on 10/8/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: Enable placing Last Section at the Bottom

    var shouldPlaceLastSectionAtTheBottom: Bool = true

    // MARK: Required TableView Height

    var isCalculatingRequiredContentHeight: Bool = false

    var requiredContentHeight: CGFloat {
        defer {
            isCalculatingRequiredContentHeight = false
        }
        isCalculatingRequiredContentHeight = true

        var result: CGFloat = 0.0

        if let header = tableView.tableHeaderView {
            result += header.frame.height
        }

        for section in 0..<tableView.numberOfSections {
            result += tableView.delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? tableView.sectionHeaderHeight
            for row in 0..<tableView.numberOfRows(inSection: section) {
                result += tableView.delegate?.tableView?(tableView, heightForRowAt: IndexPath(row: row, section: section)) ?? tableView.rowHeight
            }
            result += tableView.delegate?.tableView?(tableView, heightForFooterInSection: section) ?? tableView.sectionFooterHeight
        }

        if let footer = tableView.tableFooterView {
            result += footer.frame.height
        }

        return result
    }

    var availableContentHeight: CGFloat {
        return tableView.bounds.height - (tableView.adjustedContentInset.top + tableView.adjustedContentInset.bottom)
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - UITableViewDelegate

extension TableViewController {

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard shouldPlaceLastSectionAtTheBottom else {
            return tableView.sectionHeaderHeight
        }

        guard isCalculatingRequiredContentHeight == false else {
            return tableView.sectionHeaderHeight
        }

        return max(tableView.sectionHeaderHeight, tableView.sectionHeaderHeight + (availableContentHeight - requiredContentHeight))
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }

}
