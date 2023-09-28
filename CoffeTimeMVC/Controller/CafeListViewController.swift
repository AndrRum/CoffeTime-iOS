//
//  CafeListViewController.swift
//  CoffeTimeMVC
//
//  Created by AndrRum on 03.09.2023.
//

import Foundation
import UIKit

class CafeListViewController: UIViewController {
    
    private var cafeListView = CafeListView()
    private var allCafeService = AllCafeService()
    
    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.isHidden = true
        setupCafeListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationManager.shared.addObserver(observer: self, selector: #selector(handleHttpErrorStatus500), name: "HttpErrorStatus500")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCafeData()
    }

    func setupCafeListView() {
        cafeListView.delegate = self
        self.view = cafeListView
    }
    
    @objc func handleHttpErrorStatus500() {
        cafeListView.stopLoader()
        let cafeMocks = allCafeMockDataArray
        cafeListView.setCafeList(cafeMocks as [CafeModel])
    }
}

private extension CafeListViewController {
    func getAllCafeData() {
        cafeListView.startLoader()
        
        allCafeService.getAllCafe(url: ApiEndpoints.allCafe) { [weak self] cafeList in
            
            self?.cafeListView.loaderView.stopLoader()
            
            if let cafeSet = cafeList {
                let cafeArray = cafeSet.allObjects.compactMap { $0 as? CafeModel }
                                
                self?.cafeListView.setCafeList(cafeArray)
            } else {
                print("Failed to fetch cafe data")
            }
        }
    }
}


extension CafeListViewController: CafeListDelegate {
    func handleMapTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: cafeListView.mapView)
        let coordinate = cafeListView.mapView.projection.coordinate(for: location)
        
        cafeListView.lastCameraCoordinates?.latitude = coordinate.latitude
        cafeListView.lastCameraCoordinates?.longitude = coordinate.longitude
        print("coord \(coordinate)")
    }
}
