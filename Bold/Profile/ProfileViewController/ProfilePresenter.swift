//
//  ProfilePresenter.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ProfilePresenterInput {
    case prepareDataSource(([UserProfileDataSourceItem]) -> Void)
    case profileInfo
    case didTapAtProfilePhoto
    case choosePhotoFromGallery
    case allowCameraUse(Bool)
    case makeAPhoto
    case accountDetails
    case archivedGoals
    case downloads
    case calendar
    case rateApp
    case logout
    case setPhoto(Data)
}

protocol ProfilePresenterInputProtocol: PresenterProtocol {
    func input(_ inputCase: ProfilePresenterInput)
}

class ProfilePresenter: ProfilePresenterInputProtocol {
    typealias View = ProfileViewController
    typealias Interactor = ProfileInteractor
    typealias Router = ProfileRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    private var alertController: UIViewController?
    
    required init(view: View) {
        viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: ProfilePresenterInput) {
        switch inputCase {
        case .prepareDataSource(let completion):
            interactor.input(.prepareDataSource(completion))
        case .profileInfo:
            profileInfo()
        case .didTapAtProfilePhoto:
            didTapAtProfilePhoto()
        case .accountDetails:
            accountDetails()
        case .archivedGoals:
            archivedGoals()
        case .downloads:
            downloads()
        case .calendar:
            calendar()
        case .rateApp:
            rateApp()
        case .logout:
            logout()
        case .choosePhotoFromGallery:
            choosePhotoFromGalery()
        case .makeAPhoto:
            makeAPhoto()
        case .allowCameraUse(let allowed):
            allowCameraUse(allowed: allowed)
        case .setPhoto(let imageData):
            setPhoto(imageData: imageData)
        }
    }
    
    private func profileInfo() {
        router.input(.performSegue(segueType: .levelOfMasteryIdentifier))
    }
    
    private func didTapAtProfilePhoto() {
        if let alertController = alertController {
            alertController.dismiss(animated: true) { [weak self] in
                let contentView = ChangePhotoView.loadFromNib()
                contentView.delegate = self?.viewController
                self?.alertController = self?.viewController.showAlert(with: contentView, completion: nil)
            }
        } else {
            let contentView = ChangePhotoView.loadFromNib()
            contentView.delegate = viewController
            alertController = viewController.showAlert(with: contentView, completion: nil)
        }
    }
    
    private func accountDetails() {
        router.input(.performSegue(segueType: .showAccountDetails))
    }
    
    private func archivedGoals() {
        router.input(.performSegue(segueType: .archivedGoalsIdentifier))
    }
    
    private func downloads() {
        router.input(.performSegue(segueType: .downloadsIdentifier))
    }
    
    private func calendar() {
        router.input(.performSegue(segueType: .showCalendarAndHistoryIdentifier))
    }
    
    private func rateApp() {
        router.input(.performSegue(segueType: .rateIdentifier))
    }
    
    private func logout() {
        SessionManager.shared.killSession()
        router.input(.logout)
        // TODO
    }
    
    private func choosePhotoFromGalery() {
        if let alertController = alertController {
            alertController.dismiss(animated: true) { [weak self] in
                self?.viewController.input(.choosePhotoFromGallery)
            }
        } else {
            viewController.input(.choosePhotoFromGallery)
        }
    }
    
    private func makeAPhoto() {
        if let alertController = alertController {
            alertController.dismiss(animated: true) { [weak self] in
                let contentView = AllowCameraView.loadFromNib()
                contentView.delegate = self?.viewController
                self?.alertController = self?.viewController.showAlert(with: contentView, completion: nil)
            }
        } else {
            let contentView = AllowCameraView.loadFromNib()
            contentView.delegate = viewController
            alertController = viewController.showAlert(with: contentView, completion: nil)
        }
    }
    
    private func allowCameraUse(allowed: Bool) {
        if allowed {
            if let alertController = alertController {
                alertController.dismiss(animated: true) { [weak self] in
                    self?.viewController.input(.makeAPhoto)
                }
            } else {
                viewController.input(.makeAPhoto)
            }
        } else {
            
        }
    }
    
    private func setPhoto(imageData: Data) {
        interactor.input(.setPhoto(imageData: imageData))
    }
    
}
