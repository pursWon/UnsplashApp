import UIKit
import Alamofire
import Kingfisher

class MainViewController: UIViewController {
    let customCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        return cv
    }()
    
    let url = "https://api.unsplash.com/photos?client_id=4f_kJPCZalKnH_vkUEZM9Fktk0KlPar9YwLaFq-KyM0&page=1&per_page=20"
    
    var unsplashList: [Unsplash] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        configureCollectionView()
        registerCollectionView()
        collectionViewDelegate()
        getImageData(url: url)
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
        customCollectionView.register(ColleciontViewCell.classForCoder(), forCellWithReuseIdentifier: "mainCell")
    }
    
    func collectionViewDelegate() {
        customCollectionView.delegate = self
        customCollectionView.dataSource = self
        customCollectionView.backgroundColor = .lightGray
    }
    
    func getImageData(url: String) {
        AF.request(url, method: .get).responseDecodable(of: [Unsplash].self) { response in
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        guard let cell = customCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as? ColleciontViewCell else { return UICollectionViewCell() }
        
        let unsplash = unsplashList[indexPath.row]
        
        cell.imageView.kf.setImage(with: URL(string: unsplash.urls.regular))
        cell.titleLabel.text = unsplash.alt_description ?? "설명 없음"
        cell.backgroundColor = .red
        
        return cell
    }
}
