import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpSearchController()
    }
    
    func setUpSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search VC"
        self.navigationItem.searchController?.searchBar.placeholder = "검색어를 입력해주세요."
    }
}
