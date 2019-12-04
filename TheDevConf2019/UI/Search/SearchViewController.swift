//
//  SearchViewController.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 23/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    private let INFINITE_SCROLL_THRESHOLD = 5
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Pesquisar..."
        
        return controller
    }()
    
    private lazy var lastSearchCriteria: String? = self.searchController.searchBar.text
    private var topScrollInset: CGFloat?
    
    var viewModel: SearchViewModelContract!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TED Talks"
        
        self.viewModel = viewModel ?? SearchViewModel(delegate: self)
        
        setupTableView()
        self.navigationItem.searchController = searchController
        print("INITIAL INSET: \(self.tableView.adjustedContentInset)")
        self.loadMore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavbar()
    }
    
    func setupNavbar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(ItemTableViewCell.nib, forCellReuseIdentifier: ItemTableViewCell.identifier)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if searchController.searchBar.isFirstResponder {
            searchController.searchBar.resignFirstResponder()
        }
    }
    
    private func loadMore(){
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            self.viewModel.loadMore(searchCriteria: nil)
            return
        }
        
        guard text.count >= 3 else { return }
        
        self.viewModel.loadMore(searchCriteria: text)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier) as! ItemTableViewCell
        
        guard let item = self.viewModel.item(at: indexPath.row) else {
            fatalError("App apresenta estado inconsistente, item solicitado não existe.")
        }
        
        cell.configure(title: item.snippet.title, description: item.snippet.description, thumbnailUrl: item.snippet.thumbnails.default.url)
        
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected: \(indexPath)")
        
        if let item = viewModel.item(at: indexPath.row) {
            let viewModel = DetailViewModel(item: item)
            let vc = DetailViewController.instantiate(viewModel: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.numberOfItems() - indexPath.row == INFINITE_SCROLL_THRESHOLD {
            self.loadMore()
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = searchController.searchBar.text
        
        guard lastSearchCriteria != searchBarText else {
            return
        }
        
        lastSearchCriteria = searchBarText
        
        guard let text = searchBarText, !text.isEmpty else {
            self.viewModel.loadMore(searchCriteria: nil)
            return
        }
        
        guard text.count >= 3 else { return }
        
        self.loadMore()
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func didUpdateItems() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didAddMoreItens(numberOfItens: Int) {
        let beginIndex = self.viewModel.numberOfItems() - numberOfItens
        let endIndex = self.viewModel.numberOfItems() - 1
        let indexPaths = (beginIndex...endIndex).map { IndexPath(item: $0, section: 0) }
        
        DispatchQueue.main.async {
            self.tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}
