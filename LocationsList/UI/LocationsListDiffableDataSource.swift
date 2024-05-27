//
//  LocationsListDiffableDataSource.swift
//  LocationsList
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import LocationsCoreModels
import UIKit

final class LocationsListDiffableDataSource: UITableViewDiffableDataSource<LocationsListSection, Location> {
    // MARK: - Initializer
    
    convenience init(tableView: UITableView) {
        self.init(tableView: tableView) { (tableView, indexPath, location) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LocationCell.reuseIdentifier,
                for: indexPath
            ) as? LocationCell else {
                return nil
            }
            cell.configure(with: location)
            return cell
        }
    }
}
