//
//  LocationDetailsHeaderView.swift
//  DostupnoUA
//
//  Created by Anton on 14.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Kingfisher
import UIKit

struct LocationDetailsHeaderModel {
    let photos: [String]?
    let grade: String?
    let description: String?
    let isFavourite: Bool?
}

class LocationDetailsHeaderView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var didTapLikeButton: (() -> Void)?
    
    var content: LocationDetailsHeaderModel? {
        didSet {
            setupCollectionView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        xibSetup()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - CollectionView
    
    private func setupCollectionView() {
        pageControl.numberOfPages = content?.photos?.count ?? 0
        titleLabel.text = R.string.localizable.locationsFacilitiesGeneralImpression.localized()
        let text = content?.description
        descriptionLabel.text = text
        descriptionLabel.isHidden = text?.isEmpty ?? true
        titleLabel.isHidden = descriptionLabel.isHidden
        self.layoutIfNeeded()
        setGrade(gradeTitle: content?.grade?.gradeTitle(), gradeColor: content?.grade?.gradeColor())
        setLikeButton(isFavourite: content?.isFavourite)
        collectionView.register(LocationDetailsHeaderCvCell.self)
        collectionView.reloadData()
    }
    
    private func setGrade(gradeTitle: String?, gradeColor: UIColor?) {
        ratingImageView.image = R.image.ratingSelected()?.withRenderingMode(.alwaysTemplate)
        ratingImageView.tintColor = gradeColor
        ratingLabel.text = gradeTitle?.capitalized
    }
    
    private func setLikeButton(isFavourite: Bool?) {
        likeButton.isHidden = !PersistenceManager.manager.isLoggedIn
        let image = isFavourite == true ? R.image.likeActive()?.withRenderingMode(.alwaysTemplate) : R.image.likeNotActive()?.withRenderingMode(.alwaysTemplate)
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = .white
    }
    
    // MARK: - Actions
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        didTapLikeButton?()
    }
}

extension LocationDetailsHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content?.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(LocationDetailsHeaderCvCell.self, for: indexPath)
        let urlStr = content?.photos?[safe: indexPath.item]
        if let cell = cell as? LocationDetailsHeaderCvCell,
            let unwrappedUrlStr = urlStr,
            let url = URL(string: unwrappedUrlStr) {
            cell.imageView.kf.setImage(with: url, placeholder: R.image.imagePlaceholder())

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}

extension LocationDetailsHeaderView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = scrollView.currentPage
    }
}

extension UIScrollView {
    var currentPage: Int {
        let pageWidth = self.frame.size.width
        return Int(floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
    }
}
