//
//  ProfileInteractor.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ProfileInteractorInput {
    case prepareDataSource(([UserProfileDataSourceItem]) -> Void)
    
}

protocol ProfileInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: ProfileInteractorInput)
}

class ProfileInteractor: ProfileInteractorInputProtocol {
    typealias Presenter = ProfilePresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: ProfileInteractorInput) {
        switch inputCase {
        case .prepareDataSource(let completion):
            completion(prepareDataSource())
        }
    }
    
    private func prepareDataSource() -> [UserProfileDataSourceItem] {
        return [createProfileDetailsSection(),
                createAdditionalInfoSection(),
                createRateAppSection(),
                createLogoutSection()]
    }
    
    private func createProfileDetailsSection() -> UserProfileDataSourceItem {
        let profileHeaderViewModel = ImagedTitleSubtitleViewModel(leftImage: Asset.menuUser.image,
                                                                  title: SessionManager.shared.profile?.fullName,
                                                                  attributedTitle: nil,
                                                                  subtitle: "Apprentice",
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
