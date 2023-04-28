//
//  MainViewController.swift
//  ReignMobileTest
//
//  Created by Sebastian Villahermosa on 26/11/2022.
//

import UIKit
import SafariServices

class MainViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: String(describing: NewsViewCell.self), bundle: nil)
        newsTableView.register(cellNib, forCellReuseIdentifier: "NewsViewCell")
        newsTableView.addSubview(viewModel.refreshControl)
        viewModel.delegate = self
        viewModel.getNews()
    }
    
    func openPage(row: Int) {
        guard let storyURL = viewModel.hits[row].story_url,
              let url = URL(string: storyURL) else {return}
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell") as? NewsViewCell else {
            return UITableViewCell()
        }
        cell.setData(news: viewModel.hits[indexPath.row])
        
        if indexPath.row == viewModel.hits.count - 1 { // last cell
            print("Last row \(indexPath.row) array count \(viewModel.hits.count)")
            viewModel.incrementPages()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openPage(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteNews(index: indexPath)
            newsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension MainViewController: ViewModelDelegate {
    func reloadNews() {
        newsTableView.reloadData()
    }
}
