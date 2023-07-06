import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    let searchImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 8)
        $0.textAlignment = .center
        $0.numberOfLines = 3
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUI()
        setConstraint()
    }
    
    func setUI() {
        self.backgroundColor = .orange
        self.addSubview(searchImageView)
        self.addSubview(descriptionLabel)
    }
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            searchImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide
                .topAnchor),
            searchImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -35),
            
            descriptionLabel.topAnchor.constraint(equalTo: searchImageView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: searchImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: searchImageView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
