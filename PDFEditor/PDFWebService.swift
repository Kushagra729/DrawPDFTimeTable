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
        headers["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiZWE2YTZmZGMzNTZhMjYwMGUyOWYxZjY0MTcyOTZkMzMwMjg2OTIxODczNTc1MTMyYzg1MzIwNzhmZWNkNmJjOTYzMjZhNDM5ZDM1NDdkNTciLCJpYXQiOjE2NDY5MDk2MjcsIm5iZiI6MTY0NjkwOTYyNywiZXhwIjoxNjc4NDQ1NjI3LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.KH4uhaIaKpU8VxUPGjpCTOtGdaGVBjX_RaoGDr2qgArSGDK1XYdBBScK2BRTLuZJ5prn0HNDqwzelxSprZYR1ZKgDu-D8H3jz2Z3StRyjcTcpOrnfEyX8ziUSrJQzID4YbD0_X5Am0Qs0OVm7aFzBM5bFfsmP2LDK25q2Vlzi3pFhsBVbCdI_RbDzXvH73AdkziXotNKoYyBugm-rBbQzfcFZjR1z412rXA8b3Dlvk_wAV-QR8wUZHrKtVOuemtH5vT1M9C8NPswXoA99afkVbRg5489DwBCa9NRij8ZRsbLbM1kKQdwClaOvcGwzI_T2JfwF7PKKFQRUcByhXlVZLPHCxffPQv6USm6PIxJBfHpvUBQq7Z5ZMGYAgHSh_hfbHvJqlBg32FhLvp-2_N_7Py8xgbpaZV1y096WpHYYew60W7Wd5rIDxp4pp5fNLkTi1wCUVv_seBrGh7EABUnng1UfcukbUQW8Q9ufFnIcHgiMEzpdXfHR5lPNETNtqWtcN9DsDJQZqz-qPqtcBtaQJRQ2nmCzr-qqx2kAIp7tinlBGyaz7OL0kKZ_W91YAFsPK-E2lV5NH3nGy6bESYRCjXJlmlpHW5kvmouzqqa6KVEQ2s2_9YjHrsw8rrteRdr-Oo3mJMLBChKZL9-DB1GAISB-B9NpB5hBwfgmeKj4SM"
        
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

