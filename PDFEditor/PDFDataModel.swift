//
//  PDFDataModel.swift
//  PDFEditor
//
//  Created by Kushagra on 08/02/22.
//

import Foundation
import ObjectMapper

class PdfRawDataModel :Mappable{
    var timing : Timings?
    var lectures : [LecturesModel]?
    
    required init?(map: Map){}
    init() {}
    
    func mapping(map: Map) {
        timing <- map["timing"]
        lectures <- map["lectures"]
    }
    
}

class Timings: Mappable{
    var start : String?
    var end : String?
    required init?(map: Map){}
    init() {}
    
    func mapping(map: Map) {
        start <- map["start"]
        end <- map["end"]
    }
}

class LecturesModel :Mappable{
    var day : String?
    var classes : [ClassesModel]?
    
    required init?(map: Map){}
    init() {}
    
    func mapping(map: Map) {
        day <- map["day"]
        classes <- map["classes"]
    }
    
}

class ClassesModel :Mappable{
    var activity_name : String?
    var slot_from : String?
    var slot_to : String?
    var hrs : Int?
    var activity_type : Int?
    
    required init?(map: Map){}
    init() {}
    
    func mapping(map: Map) {
        activity_name <- map["activity_name"]
        slot_from <- map["slot_from"]
        slot_to <- map["slot_to"]
        activity_type <- map["activity_type"]
    }
    
    
    class func pdfMethod(response:((_ success:[PdfRawDataModel]?, _ errMsg:String, _ erorCode:Int)->Void)!) {
        
        let url = "http://c4d.kitlabs.us/api/view_schedule"
        PDFWebService.sendRequest(urlPath: url, type: .get, parms: nil ,success: { (responseObject) in
            print(responseObject)
            if let data = responseObject["lectures"] as? [[String:Any]]{
                var dataModel = [PdfRawDataModel]()
                for item in data{
                    let user = Mapper<PdfRawDataModel>().map(JSON: item)
                    dataModel.append(user!)
                }
                response(dataModel, "", 0)
            }
        }){ (errorMessage, status) in
            response(nil, errorMessage, status)
        }
    }
}
