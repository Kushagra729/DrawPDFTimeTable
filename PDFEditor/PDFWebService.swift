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
        headers["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1IiwianRpIjoiM2U2NTVjMDEyMWU0M2E3OTgzYWU5ZDY4NWY3NmMzNDdiOTRlOWUzMGMyZTJjNDA5NjE5ZmIxN2Y5MDUwNWI2MWI2Y2JiNWRkMTJhODRhOWUiLCJpYXQiOjE2NDc1MTk3MTQsIm5iZiI6MTY0NzUxOTcxNCwiZXhwIjoxNjc5MDU1NzE0LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.fI8eb27MyiuJdIUdpi-Ls8WDtdicGMj1lNKij_T69_Bwx_pr6pxa6xQBYoeEsp8HXhnSUZDFW9vpq0A7v4ofk8BpllLqXAWhawOYCtbEqHf7BKB3nDxDUHSv03DctS6ZzkZ2dICfK57LRvFF010-uFSylXTv5Vw1yroLIybN2L08A0GZ70_zpxOeyIBkW4nawOCBu8UKGA3PImA_9WhK0ASa-cvBXaSVmqapyfLXSngKmr_2lEV_-6O8ZCMHSUF17jyM21oG3I-hLV9zCa1t0kzU9iMbB_1PUW8ABdEDDExL6PEJ_h_Mx_-dMXPomNNVTLU131OhEh327x_cYfNsu8cOeB7AaE3i6HCbntYhDVAvFxDch7AFfWTtOo9anUikmZuOw0EmWIIe28b3oQOxNyFQOHdY_6Sh_7rzNZwt2EW2KCZc-XMI_Qp4yPm_ny6n_OR-3zZyCJcDXSZRAic0nXzfe4WOEaPc4JpDrWdjLWJfOSzVD2rX0bdMo_hbnjR8U2dbVwngKmw_IBZPQxDzx1c6cZQFxhNonq60fDYQFXNNZzoxtS2WxUNk9xOH_QEc-hanDqB4alDq5EsJzwUZHirauRNwyihaWn9zpMhRQs9Frb-GseLECg0Tu6KYcTDJzu3nutXXXsQUXKDVBgp78iKD-IgXklGmOvHJw8jSSiE"
        
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

