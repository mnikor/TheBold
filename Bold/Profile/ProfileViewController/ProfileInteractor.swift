//
//  ProfileInteractor.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum ProfileInteractorInput {
    case prepareDataSource(([UserProfileDataSourceItem]) -> Void)
    
}

protocol ProfileInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: ProfileInteractorInput)
}

class ProfileInteractor: ProfileInteractorInputProtocol {
    typealias Presenter = ProfilePresenter
    
    weak var presenter: Presenter!
    let disposeBag = DisposeBag()
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: ProfileInteractorInput) {
        switch inputCase {
        case .prepareDataSource(let completion):
            prepareDataSource(completed: completion)
        }
    }
    
    private func prepareDataSource(completed: @escaping ([UserProfileDataSourceItem])->Void ) {
        
        LevelOfMasteryService.shared.changePoints.subscribe(onNext: {[unowned self] (levelInfo) in
        
            let dataSourceArray = [self.createProfileDetailsSection(nameLevel: levelInfo.level.type.titleText!),
                                   self.createAdditionalInfoSection(),
                                   self.createRateAppSection(),
                                   self.createLogoutSection()]
        
            completed(dataSourceArray)
            
        }).disposed(by: disposeBag)
        
        
    }
    
    private func createProfileDetailsSection(nameLevel: String) -> UserProfileDataSourceItem {
        
        let profileHeaderViewModel = ImagedTitleSubtitleViewModel(leftImage: Asset.menuUser.image,
                                                                  title: SessionManager.shared.profile?.fullName,
                                                                  attributedTitle: nil,
                                                                  subtitle: nameLevel,
                                                                  attributedSubtitle: nil,
                                                                  rightImage: Asset.rightArrowProfileIcon.image)
        let profileHeader = UserProfileListItem.imagedTitleSubtitle(viewModel: profileHeaderViewModel)
        return (section: .profileHeader,
                items: [profileHeader])
    }
    
    private func createAdditionalInfoSection() -> UserProfileDataSourceItem {
        let items = ProfileAdditionalInfoCell.allCases.compactMap { UserProfileListItem.underlinedImageTitle( viewModel: UnderlinedImageTitleViewModel(title: $0.title,
                                                                                                                                                attributedTitle: nil,
                                                                                                                                                image: Asset.rightArrowProfileIcon.image,
                                                                                                                                                underlineColor: nil)) }
        
        return (section: .additionalInfo,
                items: items)
    }
    
    private func createRateAppSection() -> UserProfileDataSourceItem {
        let rateAppViewModel = ImagedTitleViewModel(leftImage: Asset.rateApp.image,
                                                    title: SessionManager.shared.profile?.fullName,
                                                    attributedTitle: nil,
                                                    rightImage: Asset.rightArrowProfileIcon.image)
        let rateAppItem = UserProfileListItem.imagedTitle(viewModel: rateAppViewModel)
        return (section: .rate,
                items: [rateAppItem])
    }
    
    private func createLogoutSection() -> UserProfileDataSourceItem {
        let logoutItem = UserProfileListItem.label(title: "Sign Out")
        return (section: .logout, items: [logoutItem])
    }
    
}
