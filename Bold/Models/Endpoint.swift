//
//  Endpoint.swift
//  Bold
//
//  Created by Admin on 10/1/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum Endpoint: String {
    case authApple = "/apple/auth/redirect"
    case authFacebook = "/auth/facebook"
    /// Delete image from user
    case deleteImage = "/users/image"
    case profile = "/users/profile"
    case registerDevice = "/devices/register"
    /// Send user reset password email
    case resetPassword = "/passwords/reset"
    case signIn = "/sessions"
    case signUp = "/registrations"
    case unregisterDevice = "/devices/unregister"
    /// Update password with current password
    case updatePassword = "/passwords/update_with_password"
    /// Update password with reset token
    case updatePasswordWithToken = "/passwords/update_with_token"
    
    case contentObject = "/content_objects/%@/%d"
    case contentObjectsWithType = "/content_objects/%@"
    case likeContentObject = "/content_objects/%@/%d/like"
    case unlikeContentObject = "/content_objects/%@/%d/unlike"
    
    case contentGroupAllWithType = "/content_groups/%@"
    case contentGroupWithID = "/content_groups/%d"
}
