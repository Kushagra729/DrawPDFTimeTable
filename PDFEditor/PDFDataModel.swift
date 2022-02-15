//
//  PDFDataModel.swift
//  PDFEditor
//
//  Created by Kushagra on 08/02/22.
//

import Foundation
struct PdfRawDataModel {
    var timeArray = [String]()
    var activity = [ActivityModel]()
}

struct ActivityModel {
    var day = String()
    var activities = [LecturesModel]()
}

struct LecturesModel {
    var name = String()
    var startTime = String()
    var endTime = String()
    var hrs = Int()
    var isLecture = Int()
}



