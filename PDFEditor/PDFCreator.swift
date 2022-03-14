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
