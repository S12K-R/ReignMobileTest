//
//  ViewModel.swift
//  ReignMobileTest
//
//  Created by Sebastian Villahermosa on 05/12/2022.
//

import Foundation
import Alamofire
import UIKit

protocol ViewModelDelegate: AnyObject {
    func reloadNews()
}

final class ViewModel {
    
    var hits: [Hits] = []
    var page = 0
    var isLoadingList = true
    let refreshControl = UIRefreshControl()
    weak var delegate: ViewModelDelegate?
    
    var isReachable: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    
    init() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getNews()
    }
    
    func incrementPages() {
        if page < 1000 {
            if !isLoadingList {
                page += 1
                getNews()
            }
        }
    }
    
    func deleteNews(index: IndexPath) {
        let newsRemoved = hits.remove(at: index.row)
        _ = try? UserDefaults.standard.setObject(hits, forKey: "lastNews")
        
        if var currentDeleted = try? UserDefaults.standard.getObject(forKey: "deletedNews", castTo: [Hits].self) {
            currentDeleted.append(newsRemoved)
            _ = try? UserDefaults.standard.setObject(currentDeleted, forKey: "deletedNews")
        } else {
            _ = try? UserDefaults.standard.setObject([newsRemoved], forKey: "deletedNews")
        }
    }
    
    func getNews() {
        guard isReachable else {
            if let savedNews = try? UserDefaults.standard.getObject(forKey: "lastNews", castTo: [Hits].self) {
                hits = savedNews

            }
            return
        }
        
        refreshControl.beginRefreshing()
        isLoadingList = true
        
        let baseUrl = "https://hn.algolia.com/api/v1/search_by_date"
        
        let parameters: Parameters = [
            "query": "mobile",
            "page": page
        ]
        
        AF.request(baseUrl, parameters: parameters).responseDecodable(of: NewsInfo.self) { [weak self] response in
            self?.isLoadingList = false
            self?.refreshControl.endRefreshing()
            
            switch response.result {
            case .success:
                if let data = response.data,
                   let decodedHits = try? JSONDecoder().decode(NewsInfo.self, from: data).hits {
                    
                    if let currentDeleted = try? UserDefaults.standard.getObject(forKey: "deletedNews", castTo: [Hits].self) {
                        
                        let newsToAdd = decodedHits.filter { news in
                            !currentDeleted.contains(news)
                        }
                        
                        newsToAdd.forEach {
                            if self?.hits.contains($0) == false {
                                self?.hits.append($0)
                            }
                        }
                        
                        _ = try? UserDefaults.standard.setObject(self?.hits, forKey: "lastNews")
                    } else {
                        self?.hits = decodedHits
                        _ = try? UserDefaults.standard.setObject(self?.hits, forKey: "lastNews")
                    }
                    self?.delegate?.reloadNews()
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }   
    
}

// patron de diseño decorator
extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        self.set(data, forKey: forKey)
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = self.data(forKey: forKey) else {
            
            throw GeneralError.unknown
        }
        let decoder = JSONDecoder()
        let object = try decoder.decode(type, from: data)
        return object
    }
    
}

enum GeneralError: Error {
    case unknown
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}
