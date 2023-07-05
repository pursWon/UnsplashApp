import UIKit
import Alamofire
import Kingfisher

class MainViewController: UIViewController {
    let customCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        return collectionView
    }()
    
    let parameters: [String] = [
    "https://api.unsplash.com/photos?",
    "client_id=4f_kJPCZalKnH_vkUEZM9Fktk0KlPar9YwLaFq-KyM0",
    "&page=1",
    "&per_page=20"
    ]
    
    var unsplashList: [Unsplash] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        configureCollectionView()
        registerCollectionView()
        collectionViewDelegate()
        getImageData(url: parameters[0], client_Id: parameters[1], page: parameters[2], perPage: parameters[3])
    }
    
    func setView() {
        view.backgroundColor = .darkGray
        view.addSubview(customCollectionView)
    }
    
    func configureCollectionView() {
        customCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            customCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            customCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            customCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    func registerCollectionView() {
        customCollectionView.register(SearchCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "mainCell")
    }
    
    func collectionViewDelegate() {
        customCollectionView.delegate = self
        customCollectionView.dataSource = self
        customCollectionView.backgroundColor = .lightGray
    }
    
    func getImageData(url: String, client_Id: String, page: String, perPage: String) {
        AF.request(url + client_Id + page + perPage, method: .get).responseDecodable(of: [Unsplash].self) { response in
            
            guard response.error == nil else {
                print(response.error!)
                
                return
            }
            
            guard let data = response.value else { return }
            
            self.unsplashList = data
            
            DispatchQueue.main.async {
                self.customCollectionView.reloadData()
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftAndRightPaddings: CGFloat = 20
        let numberOfItemsPerRow: CGFloat = 2
        let width = (collectionView.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = customCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        let unsplash = unsplashList[indexPath.row]
        
        cell.searchImageView.kf.setImage(with: URL(string: unsplash.urls.regular))
        cell.descriptionLabel.text = unsplash.description ?? "설명 없음"
        
        return cell
    }
}
