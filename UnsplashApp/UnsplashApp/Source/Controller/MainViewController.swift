import UIKit
import Alamofire
import Kingfisher

class MainViewController: UIViewController {
    let url = "https://api.unsplash.com/photos?client_id=4f_kJPCZalKnH_vkUEZM9Fktk0KlPar9YwLaFq-KyM0&page=1&per_page=20"
    var photoList: [Photos] = []
    var imageURLs: [String] = []
    var descriptions: [String] = []
    
    let customCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        configureCollectionView()
        registerCollectionView()
        collectionViewDelegate()
        getImageData(url: url)
    }
    
    func configureCollectionView() {
        customCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customCollectionView)
        customCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        customCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        customCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        customCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        customCollectionView.backgroundColor = .lightGray
    }
    
    func registerCollectionView() {
        customCollectionView.register(ColleciontViewCell.classForCoder(), forCellWithReuseIdentifier: "mainCell")
    }
    
    func collectionViewDelegate() {
        customCollectionView.delegate = self
        customCollectionView.dataSource = self
    }
    
    func getImageData(url: String) {
        AF.request(url, method: .get).responseDecodable(of: [Photos].self) { response in
            guard response.error == nil else {
                print(response.error!)
                return
            }
            
            guard let data = response.value else { return }
            self.photoList = data
            
            self.photoList.forEach {
                self.imageURLs.append($0.urls.regular)
                self.descriptions.append($0.alt_description ?? "")
            }
            
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
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = customCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! ColleciontViewCell
        let imageURL = URL(string: imageURLs[indexPath.row])
        
        cell.imageView.kf.setImage(with: imageURL)
        cell.titleLabel.text = descriptions[indexPath.row]
        cell.backgroundColor = .red
        
        return cell
    }
}
