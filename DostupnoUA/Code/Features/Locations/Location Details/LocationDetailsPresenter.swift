//
//  LocationDetailsPresenter.swift
//  DostupnoUA
//
//  Created by Anton on 14.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import MapKit

protocol LocationDetailsNavigation {
    //    var didFinish: (() -> Void)? { get set }
    var toLocationList: (() -> Void)? { get set }
    var toLocationMapPosition: ((Location?) -> Void)? { get set }
    var toComments: ((Location?) -> Void)? { get set }
}

protocol LocationDetailsViewProtocol: AnyObject {
    func reloadViewContent()
}

protocol LocationDetailsPresenterProtocol: AnyObject {
    
    var managedView: LocationDetailsViewProtocol? { get set }
    var numberOfRows: Int? { get }
    var headerContent: LocationDetailsHeaderModel? { get }
    var navigationTitle: String? { get }
    var isCommentsAvailable: Bool { get }
    
    func viewDidLoad()
    func model(at indexPath: IndexPath) -> Any?
    func likeLocation()
    func backTapped()
    func editTapped()
    func makeRoute(type: RouteType)
    func toLocationMapPosition()
    func toComments()
    func changeLocationStatus(completion: @escaping (Result<Void, Error>) -> Void)
    func errorTitle(for error: Error) -> String

}

enum RouteType {
    case apple
    case google
}

class LocationDetailsPresenter: LocationDetailsPresenterProtocol {
    
    weak var managedView: LocationDetailsViewProtocol?
    var navigation: LocationDetailsNavigation
    private var location: Location?
    private var cellsContent = [LocationDetailsFilterCellModel]()
    private var headerModel: LocationDetailsHeaderModel?
    private var mainFilters: [MainFilter]?
    private var includedFilters: [MainFilter]?
    private var favouriteLocationIDs = [Int]()

    var headerContent: LocationDetailsHeaderModel? { headerModel }
    
    var numberOfRows: Int? { cellsContent.count }
    
    var navigationTitle: String? { location?.title }
    
    var isCommentsAvailable: Bool { location?.isCommentsAvailable ?? false }
    
    init(navigation: LocationDetailsNavigation, location: Location?) {
        self.navigation = navigation
        self.location = location
    }
    
    func viewDidLoad() {
        StorageManager.shared.getFilters(onSuccess: { [weak self] filterList in
            self?.mainFilters = filterList.main
            self?.includedFilters = filterList.included
            if PersistenceManager.manager.isLoggedIn {
                StorageManager.shared.getUserFavouriteIDs(onSuccess: { ids in
                    self?.favouriteLocationIDs = ids
                    self?.setContent()
                }, onFailure: { _ in
                    self?.setContent()
                })
            } else {
                self?.setContent()
            }
        })
    }
    
    func setContent() {
        setHeaderContent(for: location)
        prepareCellsContent(for: location)
    }
    
    func likeLocation() {
        print("like/dislike location")
    }
    
    func model(at indexPath: IndexPath) -> Any? {
        return cellsContent[safe: indexPath.row]
    }
    
    private func isFavouriteLocation(location: Location?) -> Bool {
        return favouriteLocationIDs.contains(where: { $0 == location?.id })
    }
    
    private func setHeaderContent(for location: Location?) {
        headerModel = LocationDetailsHeaderModel(photos: location?.allPhotosUrl(), grade: location?.generalGrade, description: location?.generalInfoText, isFavourite: isFavouriteLocation(location: location))
    }

    private func prepareCellsContent(for location: Location?) {

        cellsContent = [
            NoFilterCellModel(name: R.string.localizable.locationsFacilitiesAddress.localized(), description: location?.mapAddressText, iconImage: R.image.location(), isLocation: true, isHidden: false),
            
            NoFilterCellModel(name: R.string.localizable.locationsFacilitiesTypeLocation.localized(), description: location?.getTitle(for: .type, inside: mainFilters), iconImage: R.image.locationType(), isHidden: location?.isHiddenFilter(for: .type)),
            
            ThreeFilterCellModel(name: R.string.localizable.locationsFacilitiesEntrance.localized(), description: location?.enterText, iconImage: R.image.enter(), gradeColor: location?.enterGrade?.gradeColor(), firstFilterTitle: R.string.localizable.locationsFacilitiesEntranceParameters.localized(), firstFilterDescription: location?.getTitle(for: .enter, inside: mainFilters), secondFilterTitle: R.string.localizable.locationsFacilitiesEntranceWidth.localized(), secondFilterDescription: location?.getTitle(for: .enterWidth, inside: includedFilters), thirdFilterTitle: R.string.localizable.locationsFacilitiesEntranceHandrailsHeight.localized(), thirdFilterDescription: location?.getTitle(for: .enterHandrailsHeight, inside: includedFilters), isHidden: location?.isHiddenFilter(for: .enter)),
            
            OneFilterCellModel(name: R.string.localizable.locationsFacilitiesBathroom.localized(), description: location?.bathroomText, iconImage: R.image.toilet(), gradeColor: location?.bathroomGrade?.gradeColor(), firstFilterTitle: R.string.localizable.locationsFacilitiesBathroomCondition.localized(), firstFilterDescription: location?.getTitle(for: .bathroom, inside: mainFilters), isHidden: location?.isHiddenFilter(for: .bathroom)),
            
            OneFilterCellModel(name: R.string.localizable.locationsFacilitiesIndoor.localized(), description: location?.indoorText, iconImage: R.image.comfort(), gradeColor: location?.indoorGrade?.gradeColor(), firstFilterTitle: R.string.localizable.locationsFacilitiesIndoorAdditionally.localized(), firstFilterDescription: location?.getTitle(for: .indoor, inside: mainFilters), isHidden: location?.isHiddenFilter(for: .indoor)),
            
            OneFilterCellModel(name: R.string.localizable.locationsFacilitiesStaff.localized(), description: location?.stuffText, iconImage: R.image.staff(), gradeColor: location?.stuffGrade?.gradeColor(), firstFilterTitle: R.string.localizable.locationsFacilitiesStaffQuality.localized(), firstFilterDescription: location?.getTitle(for: .staff, inside: mainFilters), isHidden: location?.isHiddenFilter(for: .staff)),
            
            OneFilterCellModel(name: R.string.localizable.locationsFacilitiesParking.localized(), description: location?.parkingText, iconImage: R.image.parking(), gradeColor: location?.parkingGrade?.gradeColor(), firstFilterTitle: R.string.localizable.locationsFacilitiesParking50meters.localized(), firstFilterDescription: location?.getTitle(for: .parking, inside: mainFilters), isHidden: location?.isHiddenFilter(for: .parking)),
            
            OneFilterCellModel(name: R.string.localizable.locationsFacilitiesDostupnoRecommends.localized(), description: location?.bikeParkingText, iconImage: R.image.dostupno(), gradeColor: location?.bikeParkingGrade?.gradeColor(), firstFilterTitle: R.string.localizable.locationsFacilitiesBikeParkingAvailability.localized(), firstFilterDescription: location?.getTitle(for: .dostupnoRecommends, inside: mainFilters), isHidden: location?.isHiddenFilter(for: .dostupnoRecommends)),
            
//            OneFilterCellModel(name: R.string.localizable.locationsFacilitiesBikeParking.localized(), description: location?.bikeParkingText, iconImage: R.image.bicycle(), gradeColor: location?.bikeParkingGrade?.gradeColor(), firstFilterTitle: R.string.localizable.locationsFacilitiesBikeParkingAvailability.localized(), firstFilterDescription: location?.getTitle(for: .bikeParking, inside: mainFilters), isHidden: location?.isHiddenFilter(for: .bikeParking)),
            
            OneFilterCellModel(name: R.string.localizable.locationsFacilitiesChildren.localized(), description: location?.childText, iconImage: R.image.kids(), gradeColor: location?.childGrade?.gradeColor(), firstFilterTitle: R.string.localizable.locationsFacilitiesChildrenAdditionally.localized(), firstFilterDescription: location?.getTitle(for: .child, inside: mainFilters), isHidden: location?.isHiddenFilter(for: .child)),
            
            OneFilterCellModel(name: R.string.localizable.locationsFacilitiesPets.localized(), description: location?.petsText, iconImage: R.image.pets(), gradeColor: location?.petsGrade?.gradeColor(), firstFilterTitle: R.string.localizable.locationsFacilitiesPetsAccessibility.localized(), firstFilterDescription: location?.getTitle(for: .pets, inside: mainFilters), isHidden: location?.isHiddenFilter(for: .pets)),
            
            OneFilterCellModel(name: R.string.localizable.locationsFacilitiesBraille.localized(), description: location?.brailleText, iconImage: R.image.braille(), gradeColor: location?.brailleGrade?.gradeColor(), firstFilterTitle: R.string.localizable.locationsFacilitiesBrailleAvailability.localized(), firstFilterDescription: location?.getTitle(for: .braille, inside: mainFilters), isHidden: location?.isHiddenFilter(for: .braille))
        ]
        cellsContent = cellsContent.filter({ $0.isHidden == false })
        managedView?.reloadViewContent()
    }
    
    // MARK: - Actions
    
    func backTapped() {
        navigation.toLocationList?()
    }
    
    func editTapped() {
        print("edit tapped")
    }
    
    func toLocationMapPosition() {
        navigation.toLocationMapPosition?(location)
    }
    
    func toComments() {
        navigation.toComments?(location)
    }
    
    func changeLocationStatus(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let location = location else { return }
        let isFavouriteLocation = self.isFavouriteLocation(location: location)
        isFavouriteLocation ? removeFromFavourites(location: location, completion: completion) : addToFavourites(location: location, completion: completion)
    }
    
    func makeRoute(type: RouteType) {
        RouteManager.makeRoute(location: location, type: type)
    }
    
    // MARK: - API
    
    private func addToFavourites(location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        let connection = AddLocationToFavouritesConnection(id: location.id)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] _ in
            StorageManager.shared.appendToFavouritesLocation(id: location.id)
            self?.favouriteLocationIDs.append(location.id)
            self?.setHeaderContent(for: self?.location)
            completion(.success(()))
        }, failureHandler: {  error in
            completion(.failure(error))
        })
    }
    
    private func removeFromFavourites(location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        let connection = RemoveLocationToFavouritesConnection(id: location.id)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] success in
            StorageManager.shared.removeFromFavouritesLocation(id: location.id)
            self?.favouriteLocationIDs.removeAll(where: { $0 == location.id })
            self?.setHeaderContent(for: self?.location)
            completion(.success(()))
        }, failureHandler: { error in
            completion(.failure(error))
        })
    }
    
    // MARK: - Error
    
    func errorTitle(for error: Error) -> String {
        let title: String
        switch error {
        case FavouritesError.forbidden:
            title = R.string.localizable.errorUserProfileForbidden.localized()
        case FavouritesError.update:
            title = R.string.localizable.errorFavouritesUpdate()
        case FavouritesError.objectID:
            title = R.string.localizable.errorFavouritesId()
        default:
            title = R.string.localizable.genericErrorUnknown.localized()
        }
        return title
    }
}
