//
//  UpdateProfileConnection.swift
//  DostupnoUA
//
//  Created by Anton on 12.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct UpdateProfileConnection: Connection {
    
    typealias ReturnType = UserProfile
    
    var method: HTTPMethod = .post
    var path = "profile-update/"
    
    var parameters: Parameters? {
        var params = Parameters()
        
        if let value = parametersModel?.firstName, value.isEmptyOrWhitespace == false {
            params["first_name"] = value
        }
        if let value = parametersModel?.lastName, value.isEmptyOrWhitespace == false {
            params["last_name"] = value
        }
        if let value = parametersModel?.email, value.isEmptyOrWhitespace == false {
            params["email"] = value
        }
        if let value = parametersModel?.phone, value.isEmptyOrWhitespace == false {
            params["tel"] = value
        }
        if let value = parametersModel?.photo {
            params["photo"] = value
        }
        if let value = parametersModel?.photoAction?.rawValue {
            params["photo_action"] = value
        }
        //empty string in city parameter means we want to remove city
        params["city"] = parametersModel?.cityID ?? ""
        params["language"] = language
        
        return params.isEmpty ? nil : params
    }
    
    let parametersModel: UpdateProfileModel?
    let language: String

    var httpBody: Data?
    
    var headers: HTTPHeaders? {
        var params = HTTPHeaders()
        if let dostupnoToken = PersistenceManager.manager.dostupnoToken,
            let bearerToken = dostupnoToken.bearerValue {
            params.add(name: "Authorization", value: bearerToken)
        }
        return params
    }
    
    var isMultipartFormData: Bool? {
        return true
    }
}

enum UpdatePhotoAction: String {
    case delete, upload
}

struct UpdateProfileModel {
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var city: String?
    var cityID: String?
    var password: String?
    var oldPassword: String?
    var photo: UIImage?
    var photoAction: UpdatePhotoAction?
    
    init(firstName: String? = nil, lastName: String? = nil, email: String? = nil, phone: String? = nil, city: String? = nil, cityID: String? = nil, password: String? = nil, oldPassword: String? = nil, photo: UIImage? = nil, photoAction: UpdatePhotoAction? = nil) {

        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.city = city
        self.cityID = cityID
        self.password = password
        self.oldPassword = oldPassword
		self.photo = photo
        self.photoAction = photoAction
    }
}

enum UpdateProfileConnectionError: String, Error {
    case notLoggedInUser = "not_logged_in_user"
    case forbidden = "forbidden"
    case inputData = "input_data_error"
}

extension UpdateProfileConnection {
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return UpdateProfileConnectionError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}
