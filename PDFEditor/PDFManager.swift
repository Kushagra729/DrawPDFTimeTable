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

//MARK: - Enum


enum LineDirection {  // Enum for lines directions
    case horizontal
    case verticalAndHorizontal
    case daysTimeVertical
}

enum LabelTypes {  // Enum for label types
    case timeTableName
    case day
    case days
    case activity
    case times
}

//MARK: - Class

class PDFManager: NSObject{
    static let shared = PDFManager()
    var pageWidth = 800
    var pageHeight = 382
    var rects = [CGRect]()
    override init(){}
    
    //MARK: - Horizontal Template
    
    func showTemplate(arrayWeekDays: [LecturesModel], pageRect: CGRect, context: CGContext){
        drawLine( x: 150, y: 40, context, pageRect: pageRect, lineDirection: .verticalAndHorizontal)  /// Draws the lines of template
        addWeekName(arrayWeekDays: arrayWeekDays, context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 7, context: context)
        addTimeTableUILabel(title: "TimeTable", x:CGFloat(pageWidth) / 2, y: 200, fontSize: 30, fontWeight: .bold)
        
    }
    
    //MARK: - Draws Line(s)
    
    func drawLine(x: Int,y: Int, _ drawContext: CGContext, pageRect: CGRect , lineDirection : LineDirection){
        drawContext.saveGState()
        drawContext.setLineWidth(2.0)
        
        switch lineDirection {
        
        case .horizontal:
            
            drawContext.move(to: CGPoint(x: 0, y: y))
            drawContext.addLine(to: CGPoint(x: pageRect.width, y: CGFloat(y)))
            
        case .verticalAndHorizontal:
            
            drawContext.move(to: CGPoint(x: x, y: 0))
            drawContext.addLine(to: CGPoint(x: CGFloat(x) , y: pageRect.height))
            drawContext.move(to: CGPoint(x: 0, y: y))
            drawContext.addLine(to: CGPoint(x: pageRect.width, y: CGFloat(y)))
            
        case .daysTimeVertical:
            
            drawContext.move(to: CGPoint(x: x, y: 0))
            drawContext.addLine(to: CGPoint(x: CGFloat(x) , y:  CGFloat(y)))
        }
    }
    
    //MARK: - Draw Week Names
    
    func addWeekName(arrayWeekDays: [LecturesModel], _ drawContext: CGContext, pageRect: CGRect,
                     tearOffY: CGFloat, numberTabs: Int, context: CGContext){
        var estimatedWeekNameY = cellHeight
        for index in 0..<arrayWeekDays.count {
            addUILabel(title: arrayWeekDays[index].day ?? "", x: 20, y: CGFloat(estimatedWeekNameY-6))
            drawLine(x: 0, y: Int(Double(estimatedWeekNameY) + 40.0), context, pageRect: pageRect, lineDirection: .horizontal)
            estimatedWeekNameY += cellHeight
        }
        drawContext.restoreGState()
    }
    
    //MARK: - Save Context
    
    func saveContext(context: CGContext){
        context.strokePath()
        context.restoreGState()
    }
 
    //MARK: SetData
    func showHeaderTime(arrayHeaderTime: [String], pageRect: CGRect, context: CGContext){
        addTimeUILabel(title: "Days", x: -19, y: 7)
        addWeekName(arrayHeaderTime: arrayHeaderTime, context, pageRect: pageRect)
    }
    
    func addWeekName(arrayHeaderTime: [String], _ drawContext: CGContext,pageRect: CGRect){
        var estimatedWeekNameX = 150.0
        for index in 0..<arrayHeaderTime.count {
            let time1 = convertDateTimeFormatter(date: arrayHeaderTime[index]) /// Converting  time formate from "HH:mm:ss" to "HH:mm a"
            addTimeUILabel(title: "\(time1)", x: estimatedWeekNameX, y: 7)
            drawLine(x:  Int(estimatedWeekNameX), y: 40, drawContext, pageRect: pageRect, lineDirection: .daysTimeVertical) // Draws the vrtical lines slices in days row
            estimatedWeekNameX += 120
        }
        drawContext.restoreGState()
    }
    
    func addUILabel(title: String, x: CGFloat, y: CGFloat){
            let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
            let titleAttributes: [NSAttributedString.Key: Any] =
            [
                NSAttributedString.Key.font: titleFont
            ]
            let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
            let titleStringSize = attributedTitle.size()
            let titleStringRect = CGRect(x: x,
                                         y: CGFloat(y), width: titleStringSize.width,
                                         height: titleStringSize.height)
            attributedTitle.draw(in: titleStringRect)
        }
    
    func addTimeTableUILabel(title: String, x: CGFloat, y: CGFloat,fontSize:CGFloat,fontWeight: UIFont.Weight) {
        let titleFont = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let titleAttributes: [NSAttributedString.Key: Any] =
        [
            NSAttributedString.Key.font: titleFont
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: x,
                                     y: CGFloat(y), width: titleStringSize.width,
                                     height: titleStringSize.height)
        attributedTitle.draw(in: titleStringRect)
        }
    
    func addTimeUILabel(title: String, x: CGFloat, y: CGFloat){
        let titleFont = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let titleAttributes: [NSAttributedString.Key: Any] =
       
        [
            NSAttributedString.Key.font: titleFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(x: x,
                                     y: CGFloat(y), width: 120,
                                     height: titleStringSize.height)
        attributedTitle.draw(in: titleStringRect)
    }
    
    func addRectUILabel(title: String, x: CGFloat, y: CGFloat ,rectWidth: CGFloat,isLecture :Int,context: CGContext){
        let titleFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let titleAttributes: [NSAttributedString.Key: Any] =
        
        [
            NSAttributedString.Key.font: titleFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor : UIColor.white
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
    }
    
    func addRect(x: CGFloat,y: CGFloat, _ drawContext: CGContext,rectWidth: CGFloat,isLecture :Int) -> CGRect{
        let titleStringRect = CGRect(x: x,
                                     y: CGFloat(y - 20), width: rectWidth,
                                     height: CGFloat(cellHeight))
        
        var bgColor : UIColor!
        let strokeColor : UIColor = .black
        if isLecture == 2 {
            bgColor = UIColor(red: 255/255, green: 127/255, blue: 0/255, alpha:1.0)
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
    
    //MARK: - Date Time format converter
      
      func convertDateTimeFormatter(date: String) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "HH:mm:ss"    /// Time And Date format from
          dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
          
          guard let date = dateFormatter.date(from: date) else {
              assert(false, "no date from string")
              return ""
          }
          
          dateFormatter.dateFormat = "HH:mm a"    /// Time and date format to
          dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
          let timeStamp = dateFormatter.string(from: date)
          
          return timeStamp
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
        addRectUILabel(title: className, x: CGFloat(rectX), y: y, rectWidth : rectWidth, isLecture : isLecture, context : context)
    }}
