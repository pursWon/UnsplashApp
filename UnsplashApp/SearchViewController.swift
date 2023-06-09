import UIKit
import Alamofire
import Then
import Kingfisher

class SearchViewController: UIViewController {
    let searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        return collectionView
    }()
    
    let searchBar: UISearchBar = UISearchBar().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .search, state: .normal)
        $0.placeholder = "검색어를 입력하세요"
        $0.searchBarStyle = .minimal
        
        if let textField = $0.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .lightGray
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])
            textField.textColor = .systemGray6
            
            if let leftView = textField.leftView as? UIImageView {
                leftView.tintColor = .orange
            }
        }
    }
    
    let searchButton: UIButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(image, for: .normal)
        $0.tintColor = .orange
    }
    
    let emptyLabel: UILabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: 21)
    }
    
    var isFiltered: Bool {
        let searchController = self.navigationItem.searchController
        
        if let isActive = searchController?.isActive, let isSearchTextEmpty = searchController?.searchBar.text?.isEmpty {
            return isActive && !isSearchTextEmpty
        }
        
        return false
    }
    
    var searchData: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        configure()
        setConstraints()
    }
    
    func setView() {
        view.backgroundColor = .white
        let views = [searchCollectionView, searchBar, searchButton, emptyLabel]
        
        views.forEach {
            view.addSubview($0)
        }
    }
    
    func configure() {
        setUpDelegates()
        searchbuttonAction()
        setHidden()
        registerCollectionView()
        setCollectionViewBorder()
    }
    
    func searchbuttonAction() {
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }
    
    func setHidden() {
        searchCollectionView.isHidden = true
        emptyLabel.isHidden = true
    }
    
    func setCollectionViewBorder() {
        searchCollectionView.layer.borderWidth = 2.0
        searchCollectionView.layer.borderColor = UIColor.black.cgColor
    }
    
    func setConstraints() {
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40),
            searchCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            searchCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            searchBar.bottomAnchor.constraint(equalTo: searchCollectionView.topAnchor),
            searchBar.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor),
            
            searchButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 0),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            searchButton.topAnchor.constraint(equalTo: searchBar.topAnchor),
            searchButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func registerCollectionView() {
        searchCollectionView.register(SearchCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "searchCell")
    }
    
    func setUpDelegates() {
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.backgroundColor = .lightGray
    }
    
    func searchImageData(query: String) {
        var components = URLComponents(string: "https://api.unsplash.com/search/photos")
        let client_id = URLQueryItem(name: "client_id", value: "4f_kJPCZalKnH_vkUEZM9Fktk0KlPar9YwLaFq-KyM0")
        let page = URLQueryItem(name: "page", value: "1")
        let per_page = URLQueryItem(name: "per_page", value: "20")
        let query = URLQueryItem(name: "query", value: query)
        
        components?.queryItems = [client_id, page, per_page, query]
        
        guard let url = components?.url else { return }
        
        AF.request(url, method: .get).responseDecodable(of: Search.self) { response in
            guard response.error == nil else {
                print(response.error?.localizedDescription)
                
                return
            }
            
            guard let data = response.value else { return }
            
            self.searchData = data.results
            
            guard query.value != "" else {
                self.emptyLabel.text = "검색어를 입력하지 않았습니다"
                self.emptyLabel.isHidden = false
                self.searchCollectionView.isHidden = true
                self.searchCollectionView.reloadData()
                
                return
            }
            
            if self.searchData.isEmpty {
                self.emptyLabel.text = "검색 결과가 존재하지 않습니다"
                self.searchCollectionView.isHidden = true
                self.emptyLabel.isHidden = false
            } else {
                self.searchCollectionView.isHidden = false
                self.emptyLabel.isHidden = true
            }
            
            self.searchCollectionView.reloadData()
        }
    }
    
    @objc func searchButtonClicked() {
        guard let searchText = searchBar.text else { return }
        
        searchImageData(query: searchText)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        guard let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        cell.descriptionLabel.text = searchData[indexPath.row].description ?? "설명 없음"
        cell.descriptionLabel.backgroundColor = .orange
        cell.searchImageView.kf.setImage(with: URL(string: searchData[indexPath.row].urls.thumb))
        
        return cell
    }
}
