import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpSearchController()
    }
    
    func setUpSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.title = "Search VC"
        navigationItem.searchController?.searchBar.placeholder = "검색어를 입력해주세요."
    }
}
