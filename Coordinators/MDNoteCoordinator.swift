//
//  MDNoteCoordinator.swift
//  MDSimpleNote
//
//  Created by MDLE on 2019-04-07.
//  Copyright © 2019 dcre8tive. All rights reserved.
//

import Foundation
import UIKit

class MDNoteCoordinator: NSObject, MDCoordinator {
    var navigationController: UINavigationController
    var childCoordinators = [MDCoordinator]()

    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = MDDataService.shared
        let vc = createNoteViewController(service: service)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func createNoteViewController(service :MDDataService) -> MDNoteViewController {
        let vc = MDNoteViewController.instantiate()
        let presenter = MDNotePresenter(service: service, viewController: vc)
        vc.presenter = presenter
        return vc
    }
}


