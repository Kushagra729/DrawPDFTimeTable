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

    var pdfWeek = [PdfRawDataModel]()
    
    func createFlyer(pdfeditor: PdfRawDataModel) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm:ss"
        var _data = Data()
        
        if let lecturesArray = pdfeditor.lectures{
            for item in lecturesArray{
                let time1 = timeformatter.date(from:  pdfeditor.timing?.start ?? "")
                let time2 = timeformatter.date(from:  pdfeditor.timing?.end ?? "")
                let timeArray = PDFManager()._timeRange(from: time1 ?? Date(), to: time2 ?? Date())
                PDFManager.shared.pageWidth = 150 + (timeArray.count * 120)
                PDFManager.shared.pageHeight = 60 + (lecturesArray.count * 57)
                let pageRect = CGRect(x: 0, y: 0, width: PDFManager.shared.pageWidth, height: PDFManager.shared.pageHeight)
                let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
                let data = renderer.pdfData { (context) in
                    context.beginPage()
                    let context = context.cgContext
//                    guard let lectures = lecturesArray else {
//                        return
//                    }
                    
// Horrizontal Days
                    PDFManager.shared.showTemplate(arrayWeekDays: lecturesArray , pageRect: pageRect, context: context)
// Vertical times
                    PDFManager.shared.showHeaderTime(arrayHeaderTime: timeArray, pageRect: pageRect, context: context)
// Context
                    PDFManager.shared.saveContext(context: context)
// Draw Rects
                    PDFManager.shared.numOfRect(arrayHeaderTime: timeArray, schTimesArry:lecturesArray, context: context)
                }
                _data = data
            }
        }
        

        
//        for item in pdfeditor.lectures{
//
//        }
        
//        for _pdfEditor in pdfeditor.lectures{
//            let time1 = timeformatter.date(from:  _pdfEditor.timing?.start ?? "")
//            let time2 = timeformatter.date(from:  _pdfEditor.timing?.end ?? "")
//            let timeArray = PDFManager()._timeRange(from: time1 ?? Date(), to: time2 ?? Date())
//            PDFManager.shared.pageWidth = 150 + (timeArray.count * 120)
//            PDFManager.shared.pageHeight = 60 + (_pdfEditor.lectures?.count ?? 0 * 57)
//            let pageRect = CGRect(x: 0, y: 0, width: PDFManager.shared.pageWidth, height: PDFManager.shared.pageHeight)
//            let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
//            let data = renderer.pdfData { (context) in
//                context.beginPage()
//                let context = context.cgContext
//                guard let lectures = _pdfEditor.lectures else {
//                    return
//                }
//
//                PDFManager.shared.showTemplate(arrayWeekDays: lectures , pageRect: pageRect, context: context)
//                PDFManager.shared.showHeaderTime(arrayHeaderTime: timeArray, pageRect: pageRect, context: context)
//                PDFManager.shared.saveContext(context: context)
//                PDFManager.shared.numOfRect(arrayHeaderTime: timeArray, schTimesArry:lectures, context: context)
//            }
//            _data = data
//        }
        return _data
    }
}

/*
 
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
         
         //        let pdfRawModel = PdfRawDataModel(timeArray: ["08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM"], activity: [
         //            ActivityModel(day: "Monday", activities: [LecturesModel(name: "Math", startTime: "08:13 AM", endTime:  "09:30 AM", hrs: 1, isLecture: 1),
         //                                                      LecturesModel(name: "B", startTime: "11:00 AM", endTime:  "12:00 PM", hrs: 1, isLecture: 1),
         //                                                      LecturesModel(name: "Lunch", startTime: "02:00 PM", endTime:  "02:45 PM", hrs: 2, isLecture: 0)]),
         //            ActivityModel(day: "Tuesday", activities: [LecturesModel(name: "Math", startTime: "08:00 AM", endTime:  "09:00 AM", hrs: 1, isLecture: 1),
         //                                                       LecturesModel(name: "Science", startTime: "09:00 AM", endTime:  "10:00 AM", hrs: 1, isLecture: 1),
         //                                                       LecturesModel(name: "B", startTime: "12:00 PM", endTime:  "01:00 PM", hrs: 1, isLecture: 1),
         //                                                       LecturesModel(name: "Lunch", startTime: "02:00 PM", endTime:  "03:00 PM", hrs: 2, isLecture: 0)]),
         //            ActivityModel(day: "Wednesday", activities: [LecturesModel(name: "Math", startTime: "08:00 AM", endTime:  "09:00 AM", hrs: 1, isLecture: 1),
         //                                                         LecturesModel(name: "A", startTime: "09:00 AM", endTime:  "10:00 AM", hrs: 1, isLecture: 1),
         //                                                         LecturesModel(name: "B", startTime: "11:00 AM", endTime:  "02:00 PM", hrs: 1, isLecture: 1),
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
         
         let pdfRawModel = PdfRawDataModel(timeArray: ["00:00:00", "01:00:00", "02:00:00", "03:00:00", "04:00:00", "05:00:00", "06:00:00", "07:00:00","08:00:00", "09:00:00", "10:00:00", "11:00:00", "12:00:00", "13:00:00", "14:00:00", "15:00:00","16:00:00", "17:00:00", "18:00:00", "19:00:00", "20:00:00", "21:00:00", "22:00:00", "23:00:00" ], activity: [
             ActivityModel(day: "Monday", activities: [LecturesModel(name: "Gk", startTime: "01:30:00", endTime:  "02:00:00", hrs: 1, isLecture: 1),
                                                       LecturesModel(name: "Music", startTime: "05:00:00", endTime:  "05:30:00", hrs: 1, isLecture: 1),
                                                       LecturesModel(name: "Maths", startTime: "07:00:00", endTime:  "08:00:00", hrs: 2, isLecture: 1)]),
             
             ActivityModel(day: "Tuesday", activities: [LecturesModel(name: "English", startTime: "00:00:00", endTime:  "01:00:00", hrs: 1, isLecture: 1),
                                                        LecturesModel(name: "Activity", startTime: "01:00:00", endTime:  "02:00:00", hrs: 1, isLecture: 1),
                                                        LecturesModel(name: "Maths", startTime: "02:00:00", endTime:  "03:00:00", hrs: 1, isLecture: 1),
                                                        LecturesModel(name: "Music", startTime: "03:00:00", endTime:  "04:00:00", hrs: 2, isLecture: 1),
                                                        LecturesModel(name: "Playing", startTime: "04:00:00", endTime:  "05:00:00", hrs: 1, isLecture: 1),
                                                        LecturesModel(name: "Gk", startTime: "05:00:00", endTime:  "06:00:00", hrs: 1, isLecture: 1),
                                                        LecturesModel(name: "English", startTime: "06:00:00", endTime:  "07:00:00", hrs: 1, isLecture: 1),
                                                        LecturesModel(name: "Maths", startTime: "07:00:00", endTime:  "08:00:00", hrs: 1, isLecture: 1),
                                                        LecturesModel(name: "Gk", startTime: "08:00:00", endTime:  "09:00:00", hrs: 1, isLecture: 1),
                                                        LecturesModel(name: "Gk", startTime: "09:00:00", endTime:  "10:00:00", hrs: 1, isLecture: 1)]),
             
             ActivityModel(day: "Wednesday", activities: [LecturesModel(name: "Activity", startTime: "01:00:00", endTime:  "02:00:00", hrs: 1, isLecture: 1),
                                                          LecturesModel(name: "English", startTime: "02:00:00", endTime:  "03:00:00", hrs: 1, isLecture: 1),
                                                          LecturesModel(name: "Maths", startTime: "03:00:00", endTime:  "04:00:00", hrs: 1, isLecture: 1),
                                                          LecturesModel(name: "Music", startTime: "04:00:00", endTime:  "06:00:00", hrs: 1, isLecture: 1),
                                                          LecturesModel(name: "Playing", startTime: "07:00:00", endTime:  "08:00:00", hrs: 1, isLecture: 1),
                                                          LecturesModel(name: "Gk", startTime: "08:00:00", endTime:  "10:00:00", hrs: 1, isLecture: 1),
                                                          LecturesModel(name: "Playing", startTime: "10:00:00", endTime:  "11:00:00", hrs: 2, isLecture: 1)]),
             
             ActivityModel(day: "Thursday", activities: [LecturesModel(name: "Activity", startTime: "00:00:00", endTime:  "01:00:00", hrs: 1, isLecture: 1),
                                                         LecturesModel(name: "Music", startTime: "01:00:00", endTime:  "03:00:00", hrs: 1, isLecture: 1),
                                                         LecturesModel(name: "Playing", startTime: "03:00:00", endTime:  "05:00:00", hrs: 1, isLecture: 1)]),
             
             ActivityModel(day: "Friday", activities: [LecturesModel(name: "English", startTime: "04:00:00", endTime:  "05:00:00", hrs: 1, isLecture: 1),
                                                       LecturesModel(name: "Activity", startTime: "05:00:00", endTime:  "06:30:00", hrs: 1, isLecture: 1)]),
             
             ActivityModel(day: "Saturday", activities: []),
             ActivityModel(day: "Sunday", activities: [])
             
         ])
         
         PDFManager.shared.pageWidth = 150 + (pdfRawModel.timeArray.count * 120)
         PDFManager.shared.pageHeight = 60 + (pdfRawModel.activity.count * 57)
         let pageRect = CGRect(x: 0, y: 0, width: PDFManager.shared.pageWidth, height: PDFManager.shared.pageHeight)
         let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
         let data = renderer.pdfData { (context) in
             context.beginPage()
             let context = context.cgContext
             //
             PDFManager.shared.showTemplate(arrayWeekDays: pdfRawModel.activity, pageRect: pageRect, context: context)
             PDFManager.shared.showHeaderTime(arrayHeaderTime: pdfRawModel.timeArray, pageRect: pageRect, context: context)
             PDFManager.shared.saveContext(context: context)
             PDFManager.shared.numOfRect(arrayHeaderTime: pdfRawModel.timeArray, schTimesArry: pdfRawModel.activity, context: context)
         }
         return data
     }
 }

 
 */
