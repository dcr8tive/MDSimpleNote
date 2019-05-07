//
//  MDCoordinator.swift
//  MDSimpleNote
//
//  Created by MDLE on 2019-04-07.
//  Copyright © 2019 dcre8tive. All rights reserved.
//

import Foundation
import UIKit

protocol MDCoordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [MDCoordinator] { get set }
    
    func start()
}
