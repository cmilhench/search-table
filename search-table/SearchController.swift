//
//  SearchController.swift
//  search-table
//
//  Created by Colin Milhench on 25/07/2019.
//  Copyright © 2019 Colin Milhench. All rights reserved.
//

import UIKit

class SearchCollectionViewController: UICollectionViewController {
    private var searchController: UISearchController!
    private var resultController: SearchResultsTableViewController!

    private let data = ["candy crush", "legendary: game of heroes", "one", "only", "onix", "two", "twelve", "twenty", "tone", "ton", "the"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        resultController = (self.storyboard?
            .instantiateViewController(
                withIdentifier: "searchResultsTableViewController")
            as! SearchResultsTableViewController)
        resultController.allItems = data

        searchController = UISearchController(searchResultsController: resultController)
        searchController.searchResultsUpdater = resultController
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }

    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {}
}

// MARK: - Collection View Delegates -

extension SearchCollectionViewController: UISearchControllerDelegate {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension SearchCollectionViewController/*: UICollectionViewDataSource*/ {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = SearchCollectionViewCell.reuseIdentifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SearchCollectionViewCell else {
            fatalError("failed to dequeue cell with identifier\(identifier)")
        }
        cell.itemButton.setTitle(data[indexPath.row], for: .normal)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = SearchCollectionViewHeader.reuseIdentifier
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? SearchCollectionViewHeader else {
            fatalError("failed to dequeue cell with identifier\(identifier)")
        }
        cell.titleLabel.text = "Trending"
        return cell
    }
}

extension SearchCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.bounds.width > 600 {
            return CGSize(width: collectionView.bounds.width/2, height: 44)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 44)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44)
    }
}

// MARK: - Header Cell -

class SearchCollectionViewHeader: UICollectionReusableView {
    static var reuseIdentifier: String { return String(describing: self) }
    @IBOutlet var titleLabel: UILabel!
}

// MARK: - Item Cell -

class SearchCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier: String { return String(describing: self) }
    @IBOutlet var itemButton: UIButton!
}

// MARK: - Search Results -

class SearchResultsTableViewController: UITableViewController {
    var allItems: [String]!
    var filtered = [String]()

    var searchText: String? {
        didSet {
            guard let searchText = searchText else { return }
            if searchText.count == 0 { return }
            filtered = allItems.filter { (item) -> Bool in
                return item.range(of: searchText, options: .caseInsensitive) != nil
            }
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func reloadData() {
        // cancel any previous load and reload
        NSObject.cancelPreviousPerformRequests(
            withTarget: tableView!,
            selector: #selector(tableView!.reloadData),
            object: nil)
        self.tableView!.perform(
            #selector(tableView!.reloadData),
            with: nil,
            afterDelay: 0.3)
    }
}

extension SearchResultsTableViewController/*: UITableViewDelegate*/ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension SearchResultsTableViewController/*: UITableViewDataSource*/ {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = filtered[indexPath.row]
        return cell
    }
}

extension SearchResultsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        let controller = searchController.searchResultsController as! SearchResultsTableViewController
        controller.searchText = text
    }
}
