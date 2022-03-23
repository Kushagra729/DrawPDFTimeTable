//
//  PDFManager.swift
//  PDFEditor
//
//  Created by Kushagra on 2/2/22.
//

import Foundation 
import UIKit
import PDFKit

let cellHeight = 80
let maxChar = 30
let minChar = 7
let midChar = 14

class PDFManager: NSObject{
    static let shared = PDFManager()
    var pageWidth = 800
    var pageHeight = 382
    var rects = [CGRect]()
    override init(){}
    //MARK: - Horizontal Template
    
    func showTemplate(arrayWeekDays: [LecturesModel], pageRect: CGRect, context: CGContext){
        addRow(y: 40, context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 9)
        addColumn(x: 150, context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 9)
        addWeekName(arrayWeekDays: arrayWeekDays, context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 7, context: context)
    }
    
    func addRow(y: Int, _ drawContext: CGContext, pageRect: CGRect,
                tearOffY: CGFloat, numberTabs: Int){
        drawContext.saveGState()
        drawContext.setLineWidth(2.0)
        drawContext.move(to: CGPoint(x: 0, y: y))
        drawContext.addLine(to: CGPoint(x: pageRect.width, y: CGFloat(y)))
    }
    
    func addColumn(x: Int, _ drawContext: CGContext, pageRect: CGRect,
                   tearOffY: CGFloat, numberTabs: Int){
        drawContext.saveGState()
        drawContext.setLineWidth(2.0)
        drawContext.move(to: CGPoint(x: x, y: 0))
        drawContext.addLine(to: CGPoint(x: CGFloat(x) , y: pageRect.height))
    }
    
    func addWeekName(arrayWeekDays: [LecturesModel], _ drawContext: CGContext, pageRect: CGRect,
                     tearOffY: CGFloat, numberTabs: Int, context: CGContext){
        var estimatedWeekNameY = cellHeight
        for index in 0..<arrayWeekDays.count {
            _ = addUILabel(title: arrayWeekDays[index].day ?? "", x: 20, y: CGFloat(estimatedWeekNameY-6))
            addRow(y: Int(Double(estimatedWeekNameY) + 40.0), context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 9)
            estimatedWeekNameY += cellHeight
        }
        drawContext.restoreGState()
    }
    
    //MARK: - Save Context
    
    func saveContext(context: CGContext){
        context.strokePath()
        context.restoreGState()
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
        addWeekName(arrayHeaderTime: arrayHeaderTime, context, pageRect: pageRect)
    }
    
    func addHeaderColumn(x: Int, _ drawContext: CGContext, pageRect: CGRect){
        drawContext.saveGState()
        drawContext.setLineWidth(2.0)
        drawContext.move(to: CGPoint(x: x, y: 0))
        drawContext.addLine(to: CGPoint(x: CGFloat(x) , y: 40))
    }
    
    func addWeekName(arrayHeaderTime: [String], _ drawContext: CGContext,pageRect: CGRect){
        var estimatedWeekNameX = 150.0
        for index in 0..<arrayHeaderTime.count {
            _ = addTimeUILabel(title: arrayHeaderTime[index], x: estimatedWeekNameX, y: 7)
            addHeaderColumn(x: Int(estimatedWeekNameX), drawContext, pageRect: pageRect)
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
        let titleFont = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let titleAttributes: [NSAttributedString.Key: Any] =
        [
            NSAttributedString.Key.font: titleFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        
        var titleStringRect = CGRect(x: x,
                                     y: CGFloat(y + 10), width: rectWidth,
                                     height: 100)
        
        let currentChar = title.count
        
        if rectWidth <= 60{
            
            if currentChar <= maxChar && currentChar >= midChar{
                
                titleStringRect = CGRect(x: x,
                                         y: CGFloat(y - 8), width: rectWidth,
                                         height: 100)
            }else if currentChar <= midChar && currentChar >= minChar{
                
                titleStringRect = CGRect(x: x,
                                         y: CGFloat(y + 5), width: rectWidth,
                                         height: 100)
            }else{
                
                titleStringRect = CGRect(x: x,
                                         y: CGFloat(y + 10), width: rectWidth,
                                         height: 100)
            }
        }else {
            if currentChar <= maxChar && currentChar >= midChar{
                
                titleStringRect = CGRect(x: x,
                                         y: CGFloat(y + 5), width: rectWidth,
                                         height: 100)
            }else if currentChar <= midChar && currentChar >= minChar{
                
                titleStringRect = CGRect(x: x,
                                         y: CGFloat(y + 10), width: rectWidth,
                                         height: 100)
            }else {
                
            }
        }
        
        attributedTitle.draw(in: titleStringRect)
        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    func addRect(x: CGFloat,y: CGFloat, _ drawContext: CGContext,rectWidth: CGFloat,isLecture :Int) -> CGRect{
        let titleStringRect = CGRect(x: x,
                                     y: CGFloat(y - 20), width: rectWidth,
                                     height: CGFloat(cellHeight))
        
        var bgColor : UIColor!
        let strokeColor : UIColor = .black
        if isLecture == 2 {
            bgColor = UIColor(red: 255/255, green: 127/255, blue: 0/255, alpha:0.4)
        }else {
         
            bgColor = UIColor(red: 10/255, green: 121/255, blue: 191/255, alpha:1.0)
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
    
    // MARK: - Draw rectangles
    // Number of rectangles in a day
    
    func numOfRect(arrayHeaderTime: [String],schTimesArry:[LecturesModel],context : CGContext) {
        let numOfRects = schTimesArry.count
        var startTime = ""
        var endTime = ""
        var y = 0
        var count = -1
        print(numOfRects)
        print(schTimesArry)
        for days in schTimesArry {
            count += 1
            if let dayClass =  days.classes {
                for _activity in dayClass {
                    print(_activity)
                    startTime = _activity.slot_from ?? ""
                    endTime = _activity.slot_to ?? ""
                    y = Int(Double(cellHeight) + Double((count * cellHeight))) - 20 //lecture cell top constraint
                    let combineHours = findTimeDiff(time1Str: startTime, time2Str: endTime)
                    print(combineHours)
                    if let activityName = _activity.activity_name {
                        
                        drawRectangles(combineHours: combineHours, startTime: startTime, arrayHeaderTime: arrayHeaderTime, className: _activity.activity_name ?? "", y: CGFloat(y), isLecture: _activity.activity_type ?? 1, context: context)
                        
                    }else {
                        
                    }
                }
            }
        }
        context.addRects(rects)
    }
    
    //MARK: -  Difference between dates
    
    func findTimeDiff(time1Str: String, time2Str: String) -> Int {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm:ss"
        guard let time1 = timeformatter.date(from: time1Str),
              let time2 = timeformatter.date(from: time2Str) else { return 0 }
        //You can directly use from here if you have two dates
        let interval = time2.timeIntervalSince(time1)
        let minute = interval / 60
        print(minute)
        return Int(minute)
    }
    
    //MARK: - Returns the Time range array
    
    func _timeRange(from: Date, to: Date) -> [String] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        if from > to { return [String]() }
        var tempDate = from
        var array = [tempDate]
        var strArray = [dateFormatter.string(from: tempDate)]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .hour, value: 1, to: tempDate)!
            array.append(tempDate)
            strArray.append(dateFormatter.string(from: tempDate))
        }
        return strArray
    }
    
    
    // Drawing the rectangles
    
    func drawRectangles(combineHours: Int, startTime: String,arrayHeaderTime: [String], className: String, y : CGFloat, isLecture : Int , context : CGContext){
        let rectWidth = CGFloat(combineHours * 2)
        var rectX = 150
        var count = -1
        for i in arrayHeaderTime{
            count += 1
            print(i)
            if i == startTime {
                rectX = 150 + (count * 120)
                addLecture(rectX: rectX, y: y, rectWidth: rectWidth, isLecture: isLecture, className: className, context: context)
                break
            } else {
                var diff = findTimeDiff(time1Str: i, time2Str: startTime)
                print(diff)
                rectX = 150 + (diff*2) + (count * 120)
                addLecture(rectX: rectX, y: y, rectWidth: rectWidth, isLecture: isLecture, className: className, context: context)
                break
            }
        }
    }
    
    func addLecture(rectX: Int, y : CGFloat, rectWidth : CGFloat, isLecture: Int, className: String, context : CGContext ){
        let rect = addRect(x:CGFloat(rectX), y: y, context, rectWidth: rectWidth, isLecture: isLecture)
        self.rects.append(rect)
        _ = addRectUILabel(title: className, x: CGFloat(rectX), y: y, rectWidth : rectWidth, isLecture : isLecture, context : context)
    }}
