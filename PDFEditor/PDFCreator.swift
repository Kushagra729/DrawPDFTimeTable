//
//  PDFCreator.swift
//  PDFEditor
//
//  Created by Kushagra on 2/2/22.
//

import Foundation 
import UIKit
import PDFKit

class PDFCreator: NSObject {
    let title: String
    let body: String
    let image: UIImage
    let contactInfo: String
    
    init(title: String, body: String, image: UIImage, contact: String) {
        self.title = title
        self.body = body
        self.image = image
        self.contactInfo = contact
    }
    
    func createFlyer() -> Data {
        let format = UIGraphicsPDFRendererFormat()
        let pdfRawModel = PdfRawDataModel()
        let timeArray = Timings()
//        PdfRawDataModel(timeArray: ["08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM"], activity: [
//            ActivityModel(day: "Monday", activities: [LecturesModel(name: "Math", startTime: "08:00 AM", endTime:  "09:30 AM", hrs: 1, isLecture: 1),
//                                                      LecturesModel(name: "B", startTime: "11:00 AM", endTime:  "12:00 PM", hrs: 1, isLecture: 1),
//                                                      LecturesModel(name: "Lunch", startTime: "02:00 PM", endTime:  "02:45 PM", hrs: 2, isLecture: 0)]),
//            ActivityModel(day: "Tuesday", activities: [LecturesModel(name: "Math", startTime: "08:00 AM", endTime:  "09:00 AM", hrs: 1, isLecture: 1),
//                                                       LecturesModel(name: "Science", startTime: "09:00 AM", endTime:  "10:00 AM", hrs: 1, isLecture: 1),
//                                                       LecturesModel(name: "B", startTime: "12:00 PM", endTime:  "01:00 PM", hrs: 1, isLecture: 1),
//                                                       LecturesModel(name: "Lunch", startTime: "02:00 PM", endTime:  "02:45 PM", hrs: 2, isLecture: 0)]),
//            ActivityModel(day: "Wednesday", activities: [LecturesModel(name: "Math", startTime: "08:00 AM", endTime:  "09:00 AM", hrs: 1, isLecture: 1),
//                                                         LecturesModel(name: "A", startTime: "09:00 AM", endTime:  "10:00 AM", hrs: 1, isLecture: 1),
//                                                         LecturesModel(name: "B", startTime: "11:00 AM", endTime:  "01:00 PM", hrs: 1, isLecture: 1),
//                                                         LecturesModel(name: "Lunch", startTime: "02:00 PM", endTime:  "02:45 PM", hrs: 2, isLecture: 0)]),
//            ActivityModel(day: "Thursday", activities: [LecturesModel(name: "Math", startTime: "08:00 AM", endTime:  "09:00 AM", hrs: 1, isLecture: 1),
//                                                        LecturesModel(name: "A", startTime: "09:00 AM", endTime:  "10:00 AM", hrs: 1, isLecture: 1),
//                                                        LecturesModel(name: "B", startTime: "11:00 AM", endTime:  "12:00 PM", hrs: 1, isLecture: 1),
//                                                        LecturesModel(name: "Lunch", startTime: "02:00 PM", endTime:  "02:45 PM", hrs: 2, isLecture: 0)]),
//            ActivityModel(day: "Friday", activities: [LecturesModel(name: "Math", startTime: "08:00 AM", endTime:  "09:00 AM", hrs: 1, isLecture: 1),
//                                                      LecturesModel(name: "A", startTime: "09:00 AM", endTime:  "10:00 AM", hrs: 1, isLecture: 1),
//                                                      LecturesModel(name: "B", startTime: "11:00 AM", endTime:  "12:00 PM", hrs: 1, isLecture: 1),
//                                                      LecturesModel(name: "Lunch", startTime: "02:00 PM", endTime:  "02:45 PM", hrs: 2, isLecture: 0),
//                                                      LecturesModel(name: "Game", startTime: "05:00 PM", endTime:  "08:30 PM", hrs: 2, isLecture: 1)]),
//            ActivityModel(day: "Saturday", activities: [LecturesModel(name: "Math", startTime: "08:00 AM", endTime:  "09:00 AM", hrs: 1, isLecture: 1),
//                                                        LecturesModel(name: "A", startTime: "09:00 AM", endTime:  "10:00 AM", hrs: 1, isLecture: 1),
//                                                        LecturesModel(name: "B", startTime: "11:00 AM", endTime:  "12:00 PM", hrs: 1, isLecture: 1),
//                                                        LecturesModel(name: "Lunch", startTime: "02:00 PM", endTime:  "02:45 PM", hrs: 2, isLecture: 0),
//                                                        LecturesModel(name: "Nap", startTime: "07:00 PM", endTime:  "09:00 PM", hrs: 2, isLecture: 1)])
//        ])
        
        PDFManager.shared.pageWidth = 150 + (pdfRawModel.timeArray.count * 120)
        PDFManager.shared.pageHeight = 60 + (pdfRawModel.lectures?.count ?? 0 * 57)
        let pageRect = CGRect(x: 0, y: 0, width: PDFManager.shared.pageWidth, height: PDFManager.shared.pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let context = context.cgContext
            //
            guard let lectures = pdfRawModel.lectures else {
                return
            }
            PDFManager.shared.showTemplate(arrayWeekDays: lectures , pageRect: pageRect, context: context)
            PDFManager.shared.showHeaderTime(arrayHeaderTime: pdfRawModel.timeArray, pageRect: pageRect, context: context)
            PDFManager.shared.saveContext(context: context)
            PDFManager.shared.numOfRect(arrayHeaderTime: pdfRawModel.timeArray, schTimesArry:lectures, context: context)
        }
        return data
    }
}
