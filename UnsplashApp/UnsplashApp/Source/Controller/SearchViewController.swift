import UIKit
import Alamofire
import Then

class SearchViewController: UIViewController, UISearchControllerDelegate {
    let searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        return cv
    }()
    
    let searchBar: UISearchBar = UISearchBar().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let searchButton: UIButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(image, for: .normal)
        $0.tintColor = .red
    }
    
    var isFiltered: Bool {
        let searchController = self.navigationItem.searchController
        
        if let isActive = searchController?.isActive, let isSearchTextEmpty = searchController?.searchBar.text?.isEmpty {
            return isActive && !isSearchTextEmpty
        }
        
        return false
    }
    
    var url: String = "https://api.unsplash.com/search/photos?client_id=4f_kJPCZalKnH_vkUEZM9Fktk0KlPar9YwLaFq-KyM0&page=1&query="
    var searchData: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        configure()
        setConstraints()
    }
    
    func setView() {
        view.backgroundColor = .white
        let views = [searchCollectionView, searchBar, searchButton]
        
        views.forEach {
            view.addSubview($0)
        }
    }
    
    func configure() {
        setUpDelegates()
        searchbuttonAction()
        registerCollectionView()
    }
    
    func searchbuttonAction() {
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }
    
    func setConstraints() {
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        searchCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        searchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
        searchCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        searchCollectionView.backgroundColor = .lightGray
        
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: searchCollectionView.topAnchor).isActive = true
        searchBar.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor).isActive = true
        
        searchButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 10).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        searchButton.topAnchor.constraint(equalTo: searchBar.topAnchor).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
    }
    
    func registerCollectionView() {
        searchCollectionView.register(ColleciontViewCell.classForCoder(), forCellWithReuseIdentifier: "searchCell")
    }
    
    func setUpDelegates() {
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchBar.delegate = self
    }
    
    func searchImageData(url: String) {
        AF.request(url, method: .get).responseDecodable(of: Search.self) { response in
            guard response.error == nil else {
                print(response.error?.localizedDescription)
                
                return
            }
            
            guard let data = response.value else { return }
            
            self.searchData = data.results
            
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
        }
    }
    
    @objc func searchButtonClicked() {
        guard let text = searchBar.text else { return }
        
        searchImageData(url: url + text)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftAndRightPaddings: CGFloat = 20
        let numberOfItemsPerRow: CGFloat = 2
        let width = (collectionView.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as? ColleciontViewCell else { return UICollectionViewCell() }
        
        guard let imageURL = URL(string: searchData[indexPath.row].urls.thumb) else { return UICollectionViewCell() }
        
        cell.titleLabel.text = searchData[indexPath.row].description ?? "설명 없음"
        cell.titleLabel.backgroundColor = .white
        
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
}

