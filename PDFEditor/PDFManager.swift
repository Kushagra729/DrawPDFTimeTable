//
//  PDFManager.swift
//  PDFEditor
//
//  Created by Kushagra on 2/2/22.
//

import Foundation 
import UIKit
import PDFKit

class PDFManager: NSObject{
    static let shared = PDFManager()
    var pageWidth = 800
    var pageHeight = 382
    var rects = [CGRect]()
    override init(){}
    
    func showTemplate(arrayWeekDays: [ActivityModel], pageRect: CGRect, context: CGContext){
        addRow(y: 40, context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 9)
        addColumn(x: 150, context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 9)
        addWeekName(arrayWeekDays: arrayWeekDays, context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 7, context: context)
    }
    
    func saveContext(context: CGContext){
        context.strokePath()
        context.restoreGState()
    }
    
    func addWeekName(arrayWeekDays: [ActivityModel], _ drawContext: CGContext, pageRect: CGRect,
                     tearOffY: CGFloat, numberTabs: Int, context: CGContext){
        var estimatedWeekNameY = 60.0
        for index in 0..<arrayWeekDays.count {
            _ = addUILabel(title: arrayWeekDays[index].day, x: 20, y: estimatedWeekNameY-3)
            addRow(y: Int(estimatedWeekNameY + 40.0), context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 9)
            estimatedWeekNameY += 60
        }
        drawContext.restoreGState()
    }
    
    func addColumn(x: Int, _ drawContext: CGContext, pageRect: CGRect,
                   tearOffY: CGFloat, numberTabs: Int){
        drawContext.saveGState()
        drawContext.setLineWidth(2.0)
        drawContext.move(to: CGPoint(x: x, y: 0))
        drawContext.addLine(to: CGPoint(x: CGFloat(x) , y: pageRect.height))
    }
    
    func addRow(y: Int, _ drawContext: CGContext, pageRect: CGRect,
                tearOffY: CGFloat, numberTabs: Int){
        drawContext.saveGState()
        drawContext.setLineWidth(2.0)
        drawContext.move(to: CGPoint(x: 0, y: y))
        drawContext.addLine(to: CGPoint(x: pageRect.width, y: CGFloat(y)))
    }
    
    func addUILabel(title: String, x: CGFloat, y: CGFloat) -> CGFloat{
        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: x,
                                     y: CGFloat(y), width: titleStringSize.width,
                                     height: titleStringSize.height)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    //MARK: SetData
    func showHeaderTime(arrayHeaderTime: [String], pageRect: CGRect, context: CGContext){
        _ = addTimeUILabel(title: "Days", x: -19, y: 7)
        addWeekName(arrayHeaderTime: arrayHeaderTime, context)
    }
    
    func addWeekName(arrayHeaderTime: [String], _ drawContext: CGContext){
        var estimatedWeekNameX = 150.0
        for index in 0..<arrayHeaderTime.count {
            _ = addTimeUILabel(title: arrayHeaderTime[index], x: estimatedWeekNameX, y: 7)
            estimatedWeekNameX += 120
        }
        drawContext.restoreGState()
    }
    
    func addTimeUILabel(title: String, x: CGFloat, y: CGFloat) -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: x,
                                     y: CGFloat(y), width: 120,
                                     height: titleStringSize.height)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    func addRectUILabel(title: String, x: CGFloat, y: CGFloat ,rectWidth: CGFloat,isLecture :Int,context: CGContext) -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let titleAttributes: [NSAttributedString.Key: Any] =
        [
            NSAttributedString.Key.font: titleFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        let titleStringRect = CGRect(x: x,
                                     y: CGFloat(y), width: rectWidth,
                                     height: 40)
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    func addRect(x: CGFloat,y: CGFloat, _ drawContext: CGContext,rectWidth: CGFloat,isLecture :Int) -> CGRect{
        let titleStringRect = CGRect(x: x,
                                     y: CGFloat(y - 20), width: rectWidth,
                                     height: 60)
        
        var bgColor : UIColor!
        let strokeColor : UIColor = .black
        if isLecture == 0 {
            bgColor = UIColor(red: 255/255, green: 127/255, blue: 0/255, alpha:0.4)
        }else {
            bgColor = UIColor(red: 252/255, green: 7/255, blue: 139/255, alpha:0.4)
        }
        let bpath:UIBezierPath = UIBezierPath(rect: titleStringRect)
        UIColor.clear.setFill()
        bgColor.set()
        bpath.fill()
        let bpath2:UIBezierPath = UIBezierPath(rect: titleStringRect)
        strokeColor.set()
        bpath2.stroke()
        return titleStringRect
    }
    
    // MARK: Draw rectangles
    // Number of rectangles in a day
    
    func numOfRect(arrayHeaderTime: [String],schTimesArry:[ActivityModel],context : CGContext) {
        let numOfRects = schTimesArry.count
        var startTime = ""
        var endTime = ""
        var y = 50.0
        var count = -1
        print(numOfRects)
        print(schTimesArry)
        for days in schTimesArry {
            print(days.activities)
            count += 1
            for _activity in days.activities {
                print(_activity)
                startTime = _activity.startTime
                endTime = _activity.endTime
                y = 60 + Double((count * 60))
                let combineHours = findDateDiff(time1Str: startTime, time2Str: endTime)
                print(combineHours)
                drawRectangles(combineHours: combineHours, startTime: startTime, arrayHeaderTime: arrayHeaderTime, className: _activity.name, y: y, isLecture: _activity.isLecture, context: context)
            }
        }
        context.addRects(rects)
    }
    
    // Difference between dates
    
    func findDateDiff(time1Str: String, time2Str: String) -> Int {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm a"
        guard let time1 = timeformatter.date(from: time1Str),
              //            let time2 = timeformatter.date(from: time2Str) else { return "" }
              let time2 = timeformatter.date(from: time2Str) else { return 0 }
        //You can directly use from here if you have two dates
        let interval = time2.timeIntervalSince(time1)
//        let hour = interval / 3600;
        //        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let minute = interval / 60
        print(minute)
        //        let intervalInt = Int(interval)
        //        return "\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes"
        return Int(minute)
    }
    
    // Drawing the rectangles
    
    func drawRectangles(combineHours: Int, startTime: String,arrayHeaderTime: [String], className: String, y : CGFloat, isLecture : Int , context : CGContext){
        let rectWidth = CGFloat(combineHours * 2)
        var rectX = 150
        var count = -1
        for i in arrayHeaderTime{
            count += 1
            if i == startTime {
                print(i)
                rectX = 150 + (count * 120)
                let rect = addRect(x:CGFloat(rectX), y: y, context, rectWidth: rectWidth, isLecture: isLecture)
                self.rects.append(rect)
                _ = addRectUILabel(title: className, x: CGFloat(rectX), y: y-3, rectWidth : rectWidth, isLecture : isLecture, context : context)
                break
            }
        }
    }
}
