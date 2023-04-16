import UIKit
import Alamofire

class MainViewController: UIViewController {
    let customCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
        return cv
    }()
    
    let url = "https://api.unsplash.com/photos?%2F&client_id=_U8IXCu_fSzL1Mbg4jGxXjAxhjXPPIiXCrdbMvlmZ4k&page=1&per_page=10"
    var photoList: [Photos]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        configureCollectionView()
        registerCollectionView()
        collectionViewDelegate()
        getImageData(url: url)
        
    }
    
    func getImageData(url: String) {
        AF.request(url, method: .get).responseDecodable(of: PhotoData.self) {
            response in
            if let data = response.value {
                self.photoList = data.data
    
                DispatchQueue.main.async {
                self.customCollectionView.reloadData()
                }
            } else {
                print(response.error)
            }
        }
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
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftAndRightPaddings: CGFloat = 20
        let numberOfItemsPerRow: CGFloat = 2
        
        let width = (collectionView.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photoList = photoList else { return 0 }
        
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = customCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! ColleciontViewCell
        
        return cell
    }
}
