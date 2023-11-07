//
//  CafeListView.swift
//  CoffeTimeMVC
//
//  Created by AndrRum on 03.09.2023.
//

import Foundation
import UIKit
import GoogleMaps

protocol CafeListDelegate: AnyObject {
    func handleMapTap(_ sender: UITapGestureRecognizer) -> Void
    func showCustomModal(for cafe: CafeModel) -> Void
    func detailsButtonDidTap(data: CafeModel) -> Void
}

class CafeListView: UIView, GMSMapViewDelegate {
    
    private(set) var loaderView = LoaderView()
    private(set) var pageHeader = PageHeaderView()
    private(set) var switchButton = UISegmentedControl(items: ["Map", "List"])
    private(set) var tableView = UITableView(frame: .zero, style: .grouped)
    private(set) var mapView: GMSMapView!
    private(set) var allCafe = [CafeModel]()
    
    private let defaultLatitude: Double = -33.86
    private let defaultLongitude: Double = 151.20
    
    public var lastCameraCoordinates: CLLocationCoordinate2D?
    
    weak var delegate: CafeListDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func setHeaderViewDelegate(_ delegate: PageHeaderViewDelegate?) {
        pageHeader.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCafeList(_ cafeList: [CafeModel]) {
        allCafe = cafeList

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension CafeListView {
    
    func configureUI() {
        self.backgroundColor = .white
        
        setupHeaderView()
        setupLoaderView()
        setupMapView()
        configureSwitchButton()
        configureTableView()
        
        mapView.delegate = self
    }
    
    func setupLoaderView() {
        addSubview(loaderView)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo:centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setupHeaderView() {
        addSubview(pageHeader)
        pageHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageHeader.topAnchor.constraint(equalTo: topAnchor),
            pageHeader.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageHeader.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageHeader.bottomAnchor.constraint(equalTo: pageHeader.bottomAnchor)
        ])
        
        pageHeader.configureUI(showBackButton: false)
    }
    
    func configureSwitchButton() {
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        switchButton.backgroundColor = .white
        switchButton.layer.borderWidth = 1.0
        switchButton.layer.borderColor = UIColor.gray.cgColor
        switchButton.selectedSegmentTintColor = Colors.buttonGreen
        switchButton.layer.zPosition = 1
        
        switchButton.setImage(UIImage(systemName: "mappin.and.ellipse"), forSegmentAt: 0)
        switchButton.imageForSegment(at: 0)?.accessibilityLabel = "Map"
        switchButton.setImage(UIImage(systemName: "list.dash"), forSegmentAt: 1)
        
        switchButton.selectedSegmentIndex = 1
        switchButton.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        addSubview(switchButton)
        
        NSLayoutConstraint.activate([
            switchButton.widthAnchor.constraint(equalToConstant: 130),
            switchButton.heightAnchor.constraint(equalToConstant: 32),
            switchButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            switchButton.topAnchor.constraint(equalTo: pageHeader.bottomAnchor, constant: 16)
        ])
    }
    
    func setupMapView() {
        mapView = GMSMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.settings.compassButton = false

        addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: pageHeader.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
       
        hideMapView()
    }

    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CafeListItem.self, forCellReuseIdentifier: CafeListItem.reuseId)
        addSubview(tableView)
                
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: switchButton.bottomAnchor, constant: 2),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func startLoader() {
        loaderView.startLoader()
    }
    
    func stopLoader() {
        loaderView.stopLoader()
    }
}

extension CafeListView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCafe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CafeListItem.reuseId, for: indexPath) as! CafeListItem
        cell.setParametersForCafeItem(allCafe[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126 + 20
    }
}

extension CafeListView: CafeListItemDelegate {
    
    func detailsButtonDidTap(data: CafeModel) {
        delegate?.detailsButtonDidTap(data: data)
    }
}

extension CafeListView {
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        
        if selectedIndex == 0 {
            tableView.isHidden = true
            showMapView()
        } else {
            tableView.isHidden = false
            hideMapView()
        }
    }
    
    private func showMapView() {
        mapView.isHidden = false
        mapView.isUserInteractionEnabled = true
        
        if mapView.gestureRecognizers?.isEmpty ?? true {
            setupTapRecognizer()
        }
        
        setupMarkers()
        setupCamera(cafeList: allCafe)
    }
    
    func hideMapView() {
        mapView.isHidden = true
        mapView.isUserInteractionEnabled = false
        
        if let gestures = mapView.gestureRecognizers {
            for gesture in gestures {
                mapView.removeGestureRecognizer(gesture)
            }
        }
    }
    
    func coordinates(from cafe: CafeModel) -> CLLocationCoordinate2D? {
        guard let coordinates = cafe.coordinates,
              let coordinatesComponents = coordinates.split(separator: ",").map(String.init) as? [String],
              coordinatesComponents.count == 2,
              let latitude = Double(coordinatesComponents[0].trimmingCharacters(in: .whitespaces)),
              let longitude = Double(coordinatesComponents[1].trimmingCharacters(in: .whitespaces)) else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func setupCamera(cafeList: [CafeModel]) {
        var camera: GMSCameraPosition
        
        if let firstCafe = cafeList.first,
           let coordinates = coordinates(from: firstCafe) {
            
            if coordinates == lastCameraCoordinates {
                camera = mapView.camera
            } else {
                camera = GMSCameraPosition.camera(withTarget: coordinates, zoom: 16)
                lastCameraCoordinates = coordinates
            }
        } else {
            camera = GMSCameraPosition.camera(withLatitude: defaultLatitude, longitude: defaultLongitude, zoom: 16)
            lastCameraCoordinates = CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude)
        }
        
        mapView.camera = camera
    }

    private func setupMarkers() {
        mapView.clear()
        
        let customMarkerImage = UIImage(named: "Marker")
        
        for cafe in allCafe {
            if let coordinates = coordinates(from: cafe) {
                let marker = GMSMarker(position: coordinates)
                marker.title = cafe.name
                marker.icon = customMarkerImage
                marker.map = mapView
                
                marker.userData = cafe
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
            }
        }
    }

    
    private func setupTapRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
        delegate?.handleMapTap(sender)
    }
}

extension CafeListView {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let cafe = marker.userData as? CafeModel else {
            return false
        }
        
        delegate?.showCustomModal(for: cafe)
        
        return true
    }
}
