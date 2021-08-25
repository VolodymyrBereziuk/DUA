//
//  LocationListCell.swift
//  DostupnoUA
//
//  Created by Anton on 12.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import ERJustifiedFlowLayout
import Kingfisher
import UIKit

class LocationListCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTypeImageView: UIImageView!
    @IBOutlet weak var locationTypeLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var verticalLeftFlowLayout: ERJustifiedFlowLayout!

    var didTapLikeButton: ((IndexPath?) -> Void)?
    
    private var indexPath: IndexPath?
    private var cvContent: [LocationListCVCellModel]?
    private var itemsSize = [CGSize]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        collectionView.delegate = self
        collectionView.dataSource = self
        verticalLeftFlowLayout.horizontalJustification = .left
        verticalLeftFlowLayout.minimumLineSpacing = 0
        verticalLeftFlowLayout.sectionInset = UIEdgeInsets.zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Appearance
    
    private func setupView() {
        containerView.addRoundShadow(color: R.color.paleGrey(), radius: 18)
        setupFonts()
    }
    
    private func setupFonts() {
        ratingLabel.font = UIFont.p2LeftBold
        nameLabel.font = UIFont.h2LeftBold
        locationLabel.font = UIFont.p2LeftRegular
        locationTypeLabel.font = UIFont.p2LeftRegular
    }
    
    // MARK: - Data
    
    func setupCell(model: Location?, typeTitle: String?, indexPath: IndexPath, isFavourite: Bool?) {
        self.indexPath = indexPath
        
        setImage(urlStr: model?.thumbnail?.sizes?.sliderMain?.url)
        setGrade(gradeTitle: model?.getGradeTitle(), gradeColor: model?.getGradeColor())
        setLikeButton(isFavourite: isFavourite)
        
        nameLabel.text = model?.title
        locationLabel.text = model?.mapAddressText
        locationTypeLabel.text = typeTitle
        setupCollectionView(with: model)
    }
   
    private func setImage(urlStr: String?) {
        guard let unwrappedUrlStr = urlStr, let url = URL(string: unwrappedUrlStr) else { return }
        photoView.kf.setImage(with: url, placeholder: R.image.imagePlaceholder())
        photoView.roundView(radius: 9.0)
        photoView.contentMode = .scaleAspectFill
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
    
    // MARK: - CollectionView
    
    private func setupCollectionView(with location: Location?) {
        cvContent = createCollectionViewContent(location: location)
        collectionView.register(LocationListCVCell.self)
        calculateModelSizes(cvCellModels: cvContent)
        collectionView.reloadData()
    }
    
    private func createCollectionViewContent(location: Location?) -> [LocationListCVCellModel] {
        let entranceModel = LocationListCVCellModel(name: R.string.localizable.locationsFacilitiesEntrance.localized(), gradeColor: location?.getGradeColor(gradeStr: location?.enterGrade))
        let bathroomModel = LocationListCVCellModel(name: R.string.localizable.locationsFacilitiesBathroom.localized(), gradeColor: location?.getGradeColor(gradeStr: location?.bathroomGrade))
        let indoorModel = LocationListCVCellModel(name: R.string.localizable.locationsFacilitiesIndoor.localized(), gradeColor: location?.getGradeColor(gradeStr: location?.indoorGrade))
        let staffModel = LocationListCVCellModel(name: R.string.localizable.locationsFacilitiesStaff.localized(), gradeColor: location?.getGradeColor(gradeStr: location?.stuffGrade))
        let parkingModel = LocationListCVCellModel(name: R.string.localizable.locationsFacilitiesParking.localized(), gradeColor: location?.getGradeColor(gradeStr: location?.parkingGrade))
//        let bikeParkingModel = LocationListCVCellModel(name: R.string.localizable.locationsFacilitiesBikeParking.localized(), gradeColor: location?.getGradeColor(gradeStr: location?.bikeParkingGrade))
        let recommendsModel = LocationListCVCellModel(name: R.string.localizable.locationsFacilitiesDostupnoRecommends.localized(), gradeColor: location?.getGradeColor(gradeStr: location?.dostupnoRecommendsGrade))
        let childModel = LocationListCVCellModel(name: R.string.localizable.locationsFacilitiesChildren.localized(), gradeColor: location?.getGradeColor(gradeStr: location?.childGrade))
        let petsModel = LocationListCVCellModel(name: R.string.localizable.locationsFacilitiesPets.localized(), gradeColor: location?.getGradeColor(gradeStr: location?.petsGrade))
        let brailleModel = LocationListCVCellModel(name: R.string.localizable.locationsFacilitiesBraille.localized(), gradeColor: location?.getGradeColor(gradeStr: location?.brailleGrade))
        let content = [entranceModel, recommendsModel, bathroomModel, indoorModel, staffModel, parkingModel, childModel, petsModel, brailleModel]
        return content
    }
    
    // MARK: - Actions
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        didTapLikeButton?(indexPath)
    }
}

extension LocationListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cvContent?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(LocationListCVCell.self, for: indexPath)
        let cellModel = cvContent?[safe: indexPath.item]
        if let cell = cell as? LocationListCVCell {
            cell.setupCell(model: cellModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemsSize[safe: indexPath.item] ?? CGSize.zero
    }
    
    func calculateModelSizes(cvCellModels: [LocationListCVCellModel]?) {
        cvCellModels?.forEach { model in
            let name = model.name ?? ""
            let itemSize = calculateItemSize(using: name)
            itemsSize.append(itemSize)
        }
    }
    
    func calculateItemSize(using name: String) -> CGSize {
        let font = UIFont.p2LeftRegular
        let constraintRect = CGSize(width: 500, height: 500)
        let labelSize = name.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return CGSize(width: labelSize.width + 45, height: 30)
    }
}
