//
//  CafeListViewController.swift
//  CoffeTimeMVC
//
//  Created by AndrRum on 03.09.2023.
//

import Foundation
import UIKit

class CafeListViewController: UIViewController, CommonLifecycleMethods {
    
    private var cafeListView = CafeListView()
    private var allCafeService = AllCafeService()
    private var customModalViewController = CustomModalViewController()
    private var cafeVC = CafeViewController()
    private var drawerMenuViewController = DrawerMenuViewController()
    
    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.isHidden = true
        setupCafeListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllCafeData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        commonViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        commonViewWillDisappear()
        
        if drawerMenuViewController.parent != nil {
            drawerMenuDidClose(viewController: drawerMenuViewController)
        }
    }
    
    func setupCafeListView() {
        cafeListView.delegate = self
        cafeListView.setHeaderViewDelegate(self)
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
                let cafeArray = cafeSet.allObjects.compactMap { dict -> CafeModel? in
                    guard let cafeDict = dict as? [String: Any] else {
                        return nil
                    }
                    
                    return CafeModel(
                        address: cafeDict["address"] as? String,
                        coordinates: cafeDict["coordinates"] as? String,
                        descr: cafeDict["description"] as? String,
                        id: cafeDict["id"] as? String,
                        images: cafeDict["images"] as? String,
                        name: cafeDict["name"] as? String
                    )
                }
            
                self?.cafeListView.setCafeList(cafeArray)
            } else {
                print("Failed to fetch cafe data")
            }
        }
    }
}


extension CafeListViewController: CafeListViewDelegate, ModalDelegate {
        
    func handleMapTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: cafeListView.mapView)
        let coordinate = cafeListView.mapView.projection.coordinate(for: location)
        
        cafeListView.lastCameraCoordinates?.latitude = coordinate.latitude
        cafeListView.lastCameraCoordinates?.longitude = coordinate.longitude
    }
    
    func showCustomModal(for cafe: CafeModel) {
        customModalViewController.configure(with: cafe)
        customModalViewController.delegate = self
        self.present(customModalViewController, animated: true, completion: nil)
    }
    
    func modalDidClose(data: CafeModel?) {
        detailsButtonDidTap(data: data!)
    }
    
    func detailsButtonDidTap(data: CafeModel) {
        cafeVC.cafe = data
        goToCafeScreen()
    }
    
    @objc func goToCafeScreen() {
        navigationController?.pushViewController(cafeVC, animated: true)
    }
}

extension CafeListViewController: PageHeaderViewDelegate, DrawerMenuViewControllerDelegate {
    func backButtonTapped() {
        
    }
    
    func favoriteButtonTapped() {
        showDrawerMenu(viewController: drawerMenuViewController)
    }
    
    func drawerMenuDidClose() {
        drawerMenuDidClose(viewController: drawerMenuViewController)
    }
}
