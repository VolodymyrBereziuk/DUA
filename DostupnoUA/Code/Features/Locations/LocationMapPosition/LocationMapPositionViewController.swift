//
//  LocationMapPositionViewController.swift
//  DostupnoUA
//
//  Created by admin on 11.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class LocationMapPositionViewController: UIViewController, LocationMapPositionViewProtocol {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!
    
    var presenter: LocationMapPositionPresenterProtocol?
    
    private let markerSize = CGSize(width: 36, height: 36)

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        configureMap()
        configureView()
    }
    
    // MARK: - Appearance
    
    func configureMap() {
        mapView.isMyLocationEnabled = true
        mapView.initMapStyle()
        mapView.delegate = self
    }
    
    func configureView() {
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        configureButtons()
    }
    
    func configureButtons() {
        myLocationButton.setImage(R.image.myLocation(), for: .normal)
        myLocationButton.backgroundColor = .white
        myLocationButton.addRoundShadow()
        let image = R.image.route()?.withRenderingMode(.alwaysTemplate)
        routeButton.setTitle(R.string.localizable.locationsDetailsMakeRoute.localized(), for: .normal)
        routeButton.setImage(image, for: .normal)
        if let imView = routeButton.imageView {
            imView.tintColor = .white
            routeButton.bringSubviewToFront(imView)
        }
        routeButton.addRoundShadow(color: R.color.blueGray(), radius: 9)
    }
    
    private func routeActionSheet() {
        showActionSheetView(title: R.string.localizable.locationsDetailsRouteActionTitle.localized(), firstActionTitle: R.string.localizable.locationsDetailsMakeRouteApple.localized(), secondActionTitle: R.string.localizable.locationsDetailsMakeRouteGoogle.localized(), firstAction: { [weak self] _ in
            self?.presenter?.makeRoute(type: .apple)
            }, secondAction: { [weak self] _ in
                self?.presenter?.makeRoute(type: .google)
        })
    }
    
    // MARK: - LocationMapPositionViewProtocol

    func setCameraOnLocation(camera: GMSCameraPosition) {
        mapView.animate(to: camera)
    }
    
    func setMarkerOnMap(marker: MapMarker?) {
        mapView.clear()
        guard let marker = marker else { return }
        let gmMarker = GMSMarker()
        gmMarker.title = marker.title
        gmMarker.position = marker.coordinate
        gmMarker.map = mapView
        gmMarker.iconView = createMarkerImageView(mapMarker: marker)
    }
    
    private func createMarkerImageView(mapMarker: MapMarker) -> UIImageView {
        let imageView = UIImageView(image: mapMarker.pinImage)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = mapMarker.color
        imageView.frame.size = markerSize
        imageView.contentMode = .scaleToFill
        return imageView
    }
    
    func reloadViewContent() {
        navigationItem.title = presenter?.navigationTitle
    }
    
    // MARK: - Actions
    
    @objc func backTapped() {
        presenter?.backTapped()
    }
    
    @IBAction func routeButtonTapped(_ sender: Any) {
        routeActionSheet()
    }
    
    @IBAction func myLocationButtonTapped(_ sender: Any) {
        presenter?.setCameraOnMyLocation()
    }
}

extension LocationMapPositionViewController {
    
    static func make(with presenter: LocationMapPositionPresenter?) -> LocationMapPositionViewController? {
        let viewController = R.storyboard.locationMapPosition.locationMapPositionViewController()
        viewController?.presenter = presenter
        presenter?.managedView = viewController
        return viewController
    }
}

extension LocationMapPositionViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
}
