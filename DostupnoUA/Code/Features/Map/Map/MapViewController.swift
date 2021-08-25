//
//  MapViewController.swift
//  DostupnoUA
//
//  Created by admin on 10/6/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import GoogleMaps
import Loady
import UIKit

class MapViewController: UIViewController, MapViewProtocol {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var showLocationsButton: LoadyButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tabBarView: TabBarView!
    
    var presenter: MapPresenterProtocol?
    let searchBarContainer = SearchBarPlacesContainer()
    var clusterManager: GMUClusterManager?
    
    private let markerSize = CGSize(width: 36, height: 36)
    private let markerInfoViewSize = CGSize(width: 240, height: 130)
    
    private var alreadyShowLocationFirstTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //if language is changes we will update titles here
        configureButtonsTitles()
        searchBarContainer.updateContentLanguage()
    }
    
    func configureView() {
        configureMap()
        configureButtons()
        configureTabBarView()
        configureSearchBar()
    }
    
    func configureSearchBar() {
        searchBarContainer.bind(to: view, navigationItem: navigationItem)
        searchBarContainer.onPlaceDidSelect = { [weak self] location in
            self?.presenter?.showLocationDetails(location: location)
        }
        searchBarContainer.onShowAllPlacesDidTap = { [weak self] searchText, locationsResponse in
            self?.presenter?.showLocationList(searchText: searchText, locationsReponse: locationsResponse)
        }
    }
    
    func configureTabBarView() {
        tabBarView.selectedTabBarItem = .map
        tabBarView.onScanTap = { [weak self] in
            self?.tabBarController?.selectedIndex = 0
        }
        tabBarView.onProfileTap = { [weak self] in
            self?.tabBarController?.selectedIndex = 2
        }
    }
    
    func configureMap() {
        mapView.isMyLocationEnabled = true
        mapView.initMapStyle()
        mapView.delegate = self
        presenter?.setCameraOnMyLocation()
    }
    
    func configureButtons() {
        filterButton.setImage(R.image.filter(), for: .normal)
        filterButton.backgroundColor = .white
        filterButton.addRoundShadow()
        
        myLocationButton.setImage(R.image.myLocation(), for: .normal)
        myLocationButton.backgroundColor = .white
        myLocationButton.addRoundShadow()
        
        addButton.setImage(R.image.add(), for: .normal)
        addButton.titleEdgeInsets = UIEdgeInsets(left: 10)
        addButton.set(style: .green30)
        
        showLocationsButton.titleLabel?.font = UIFont.p2LeftBold
        showLocationsButton.backgroundColor = .white
        showLocationsButton.addRoundShadow()
        showLocationsButton.isHidden = true
        showLocationsButton.setAnimation(LoadyAnimationType.indicator(with: .init(indicatorViewStyle: .black)))
        
        configureButtonsTitles()
    }
    
    func configureButtonsTitles() {
        addButton.setTitle(R.string.localizable.mapAddButtonTitle.localized(), for: .normal)
        showLocationsButton.setTitle(R.string.localizable.filterShowResultsTitle.localized(), for: .normal)
    }
    
    private func loadLocationsWithBounds() {
        showLocationsButton.startLoading()
        let bounds = mapView.locationCoordinateBounds
        presenter?.getLocations(coordinateBounds: bounds,
                                searchText: nil,
                                onlyCoordinateResults: true)
    }
    
    // MARK: - Actions
    
    @IBAction func showLocationsButtonTapped(_ sender: Any) {
        loadLocationsWithBounds()
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        presenter?.showFilters()
    }
    
    @IBAction func myLocationButtonTapped(_ sender: Any) {
        presenter?.didTapMyLocation() 
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let webViewController = WebViewController(urlString: "https://forms.gle/5Pgy6RyprGWbEVyV9",
                                                  title: R.string.localizable.locationCreationIntroNavigationTitle.localized())
        navigationController?.show(webViewController, sender: nil)
        //TODO: return when start native create location implementation
        //presenter?.showNewLocation()
    }
    
    // MARK: - MapViewProtocol
    
    func setMarkersOnMap(markers: [MapMarker]?) {
        clusterManager?.clearItems()
        guard let markers = markers else { return }
        setupClusters(markers: markers)
    }
    
    func setCameraOnLocation(camera: GMSCameraPosition) {
        mapView.animate(to: camera)
    }
    
    func updateCameraToBounds(camera: GMSCameraUpdate) {
        mapView.animate(with: camera)
    }
    
    func clearMapView() {
        showLocationsButton.stopLoading()
        showLocationsButton.isHidden = true
        clusterManager?.clearItems()
    }
    
    func showAlerController(_ alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
}

extension MapViewController: GMSMapViewDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        showLocationsButton.isHidden = false
        StorageManager.shared.mapLocationBounds = mapView.locationCoordinateBounds
        if StorageManager.shared.mapLocationBounds != nil, alreadyShowLocationFirstTime == false, LocationManager.shared.currentLocation != nil {
            //load locations first time after set camera to user location
            loadLocationsWithBounds()
            alreadyShowLocationFirstTime = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let clusterItem = marker.userData as? ClusterItem else { return }
        let mapMarker = clusterItem.mapMarker
        presenter?.showLocationDetails(locationID: mapMarker.locationId)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let clusterItem = marker.userData as? ClusterItem else { return nil }
        let mapMarker = clusterItem.mapMarker
//        let view = MarkerInfoView(frame: CGRect(origin: .zero, size: markerInfoViewSize), model: mapMarker)
        let view = ManualMarkerInfoView(frame: CGRect(origin: .zero, size: markerInfoViewSize), model: mapMarker)
        
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let cluster = marker.userData as? GMUCluster {
            presenter?.setCameraOnLocation(coordinate: cluster.position, zoom: mapView.camera.zoom + 1)
        }
        guard let clusterItem = marker.userData as? ClusterItem else { return false }
        let mapMarker = clusterItem.mapMarker
        presenter?.setCameraOnLocation(coordinate: mapMarker.coordinate, zoom: mapView.camera.zoom)
        return false
    }
    
    private func setupClusters(markers: [MapMarker]?) {
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = ClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        generateClusterItems(markers: markers)
        clusterManager?.cluster()
    }
    
    private func generateClusterItems(markers: [MapMarker]?) {
        guard let markers = markers else { return }
        for marker in markers {
            let clusterItem = ClusterItem(mapMarker: marker)
            clusterManager?.add(clusterItem)
        }
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        guard let clusterItem = marker.userData as? ClusterItem else { return }
        marker.iconView = createMarkerImageView(mapMarker: clusterItem.mapMarker)
        marker.zIndex = Int32(clusterItem.mapMarker.zIndex)
    }
    
    private func createMarkerImageView(mapMarker: MapMarker) -> UIImageView {
        let imageView = UIImageView(image: mapMarker.pinImage)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = mapMarker.color
        imageView.frame.size = markerSize
        imageView.contentMode = .scaleToFill
        return imageView
    }

}

class ClusterRenderer: GMUDefaultClusterRenderer {
    override func shouldRender(as cluster: GMUCluster, atZoom zoom: Float) -> Bool {
        return cluster.count >= 21
    }
}

extension MapViewController {
    
    static func make(with presenter: MapPresenterProtocol?) -> MapViewController? {
        let viewController = R.storyboard.map.mapViewController()
        viewController?.presenter = presenter
        presenter?.managedView = viewController
        return viewController
    }
}
