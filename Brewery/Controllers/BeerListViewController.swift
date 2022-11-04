//
//  BeerListViewController.swift
//  Brewery
//
//  Created by juyeong koh on 2022/11/04.
//

import UIKit

class BeerListViewController: UITableViewController {
    
    var beerList = [Beer]()
    // 한 번 불러온 페이지는 다시 불러오지 않도록 테스크 조정
    var dataTasks = [URLSessionTask]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UINavigationBar
        title = "브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // UITableView 레지스터
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        
        tableView.prefetchDataSource = self
        
        fetchBeer(of: currentPage)
    }
}


// MARK: - UITableView DataSource, Delegate

extension BeerListViewController: UITableViewDataSourcePrefetching {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Rows: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as! BeerListCell
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            guard currentPage != 1 else { return }
            
        indexPaths.forEach {
            if ($0.row + 1)/25 + 1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }
    }
}


// MARK: - Data Fetching
private extension BeerListViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
              dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                print("Error : URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
        
            switch response.statusCode {
            case (200...299):
                self.beerList += beers
                self.currentPage += 1

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499): // 클라이언트 에러
                print("""
ERROR: Client error \(response.statusCode)
Response: \(response)
""")
            case (500...599): // 서버 에러
                print("""
ERROR: Server error \(response.statusCode)
Response: \(response)
""")
            default:
                print("""
ERROR: \(response.statusCode)
Response: \(response)
""")
            }
        }
        dataTask.resume()
        dataTasks.append(dataTask)
    }
}


