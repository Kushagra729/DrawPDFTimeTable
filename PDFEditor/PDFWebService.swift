//
//  PDFWebService.swift
//  PDFEditor
//
//  Created by Osvin-Mob-MAc on 10/03/22.
//

import Foundation
import Alamofire
import ObjectMapper

//MARK: Base Response Model
class BaseResponse: Mappable {
    
    var status:String?
    var success:String?
    var code:Int = 500
    var message:String = ""
    var userId:String = ""
    var sessionId:String = ""
    var userName:String = ""
    var displayName:String = ""
    
    var responseStatus: ResponseStatus?
    var error:[String:String]?
    var errorMessage:[String:String]?
    var data:Any?
    
    required init?(map: Map) {}
    
    
    func mapping(map: Map) {
        status <- map["status"]
        success <- map["success"]
        code <- map["code"]
        message <- map["message"]
        errorMessage <- map["message"]
        userId <- map["userId"]
        sessionId <- map["sessionId"]
        userName <- map["userName"]
        displayName <- map["displayName"]
        error <- map["error"]
        responseStatus <- map["responseStatus"]
        data <- map["data"]
    }
}

//MARK:  ResponseStatus Model
class ResponseStatus: Mappable {
    
    var message:String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        message <- map["message"]
        
    }
}


//Refresh Token Handler
class RequestRetryHandler : RequestAdapter, RequestRetrier {
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return urlRequest
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        completion(false, 0.0)
    }
}

 class PDFWebService : NSObject {
    
    static var sessionManager:SessionManager = {
        let sesionManager = SessionManager.default
        let requestRetrier = RequestRetryHandler()
        sesionManager.retrier = requestRetrier
        sesionManager.adapter = requestRetrier
        return sesionManager
    }()
    
    class func getHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        headers = [
            "Content-Type" : "application/json"
        ]
        headers["Authorization"] = "Bearer "
        
        return headers
    }
    
    
    
   class func sendRequest(urlPath:String, type:HTTPMethod, parms:Parameters?, success:((_ responseObject:[String : Any])->Void)!, faliure:((_ errMsg:String,_ errCode:Int)->Void)!) {
        
        //baseURL
        let requestURL:URLConvertible = urlPath
        let responseQueue = DispatchQueue(label:"AlomaFire", qos:.background, attributes:[.concurrent])
        PDFWebService.sessionManager.request(requestURL, method:type, parameters:parms, encoding: JSONEncoding.default, headers:PDFWebService.getHeaders()).responseJSON(queue: responseQueue) { (response) in
            
            DispatchQueue.main.async {
                guard response.result.error == nil else {
                    print("Error in response : \(response.result.error)")
                    print("Error Code in response : \(response.response?.statusCode)" )
                    faliure("Server Error",response.response?.statusCode ?? 0)
                    return
                }
                
                if response.response?.statusCode == 500 {
                    faliure("Error 500",500)
                    return
                }
                
                if let responseObj:[String:Any] = response.value as? [String : Any] {
                    let baseResponse = Mapper<BaseResponse>().map(JSON: responseObj)
                    
                    print(response.request)
                    print(response)
                    if baseResponse?.status == "error" {
                        print(baseResponse?.message ?? "")
                        var errorMessage = ""
                        if responseObj["message"] is NSDictionary {
                            if let message = responseObj["message"] as? NSDictionary {
                                if (message as NSDictionary).count > 0 {
                                    for (key, value) in message {
                                        if let val = value as? NSArray{
                                            for v in val {
                                                print("\(key) and \(v)")
                                                errorMessage = errorMessage + " \(v)"
                                            }
                                        }
                                    }
                                    faliure(errorMessage,0)
                                }
                            }
                        }
                        if let error = baseResponse?.message {
                            faliure(error,baseResponse!.code)
                        }
                    }else{
                        if baseResponse?.data is [String:Any] {
                            success((baseResponse?.data as? [String : Any])! )
                        }
                        else if baseResponse?.data is [Any] {
                            success(["results":baseResponse?.data as Any])
                        }else if baseResponse?.status == "success" {
                            success((["message": baseResponse?.message ?? ""]) )
                        }else if baseResponse?.message != nil {
                            success((["message": baseResponse?.message ?? ""]) )
                        }
                    }
                }
            }
        }
    }
}

