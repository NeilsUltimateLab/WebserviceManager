//
//  WebserviceManager.swift
//
//  Created by Ratnesh on 24/11/16.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

/// Webservice Manager Class
///
/// - is Singleton class
/// - handles all the Get and Post web requests

class WebserviceManager: NSObject {
    
    // MARK: - Singleton
    static let shared: WebserviceManager = {
        return WebserviceManager()
    }()
    
    // MARK: - Post Webservice
    func callPostWebService(
        url: String?,
        isTokenRequired: Bool = true,
        withParameters parameters: [String: Any]?,
        withSuccessHandler successCH : (([String:AnyObject]?) -> Void)?,
        withErrorHandler errorCH : (([String:AnyObject]?) -> Void)?
    ){
        var header = [String: String]()
        
        if singleton_LoginManager.isLoggedIn() && isTokenRequired {
            header["token"] = singleton_User.token
            header["user_id"] = singleton_User.user_id
        }
        
        debugPrint("Header__>",header)
    
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (dataResponse) in
            
            if let responseDictionary = dataResponse.result.value as? [String: AnyObject] {
                print(responseDictionary)
                if let status = responseDictionary["status"] as? String, status == "success" {
                    successCH?(responseDictionary)
                }else {
                    errorCH?(responseDictionary)
                }
            }else {
                debugPrint(dataResponse)
                debugPrint("Response-->",dataResponse.response ?? "Could not connect to the server","Result-->", dataResponse.result)
                if dataResponse.result.isFailure {
                    let error = dataResponse.result.error!
                    print(error.localizedDescription)
                    let errorDictionary = ["InternetError": error.localizedDescription]
                    errorCH?(errorDictionary as [String: AnyObject]?)
                }
            }
        }
    }
    
    // MARK: - Get Webservice
    func callGetWebService(
        url: String?,
        isTokenRequired: Bool = true,
        withParameters parameters: [String: Any]?,
        withSuccessHandler successCH : (([String:AnyObject]?) -> Void)?,
        withErrorHandler errorCH : (([String:AnyObject]?) -> Void)?
        ){
        
        var header = [String: String]()
        
        if singleton_LoginManager.isLoggedIn() && isTokenRequired {
            header["token"] = singleton_User.token
            header["user_id"] = singleton_User.user_id
            
        }
        
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.queryString , headers: header).responseJSON { (dataResponse) in
            print("Description ->", dataResponse.result.value as? [String: AnyObject] ?? "Error")
            
            if let responseDictionary = dataResponse.result.value as? [String: AnyObject] {
                print(responseDictionary)
                if let status = responseDictionary["status"] as? String, (status == "success" || status == "OK") {
                    successCH?(responseDictionary)
                }else {
                    errorCH?(responseDictionary)
                }
            }else {
                debugPrint(dataResponse)
                if dataResponse.result.isFailure {
                    let error = dataResponse.result.error!
                    print(error.localizedDescription)
                    let errorDictionary = ["InternetError": error.localizedDescription]
                    errorCH?(errorDictionary as [String : AnyObject]?)
                }
            }
            
        }
        
    }    
    
}
