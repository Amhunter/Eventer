//
//  DateToStringConverter.swift
//  Eventer
//
//  Created by Grisha on 06/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//
import UIKit

class DateToStringConverter {
    var date:NSDate = NSDate()
    
    init(fromDate:NSDate){
        date = fromDate
    }
    
    class func getCreatedAtString(fromDate:NSDate , tab:forTab) -> String{
        var shorten:Bool
        switch tab{
        case forTab.Home:
            shorten = true
        case forTab.Activity:
            shorten = false
        default:
            shorten = false

        }
        
        
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        
        let DateComponents:NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.WeekOfMonth, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: fromDate, toDate: NSDate(), options: [])
        let SecondDifference = DateComponents.second
        let MinuteDifference = DateComponents.minute
        let HourDifference = DateComponents.hour
        let WeekDifference = DateComponents.weekOfMonth
        let DayDifference = DateComponents.day
        let MonthDifference = DateComponents.month
        let YearDifference = DateComponents.year
        //!
        var ext:String = ""

        if (YearDifference != 0){
            if (shorten){
                ext = "y"
            }else{
                if (YearDifference > 1){
                    ext = "years"
                }else{
                    ext = "year"
                }
            }
            return ("\(YearDifference) \(ext)")

        }else{
            if(MonthDifference != 0){
                if (shorten){
                    ext = "m"
                }else{
                    if (MonthDifference > 1){
                        ext = "months"
                    }else{
                        ext = "month"
                    }
                }
                return ("\(MonthDifference) \(ext)")
            }else{
                if (WeekDifference != 0){
                    if (shorten){
                        ext = "w"
                    }else{
                        if (WeekDifference  > 1){
                            ext = "weeks"
                        }else{
                            ext = "week"
                        }
                    }
                    return ("\(WeekDifference) \(ext)")
                }else{
                    if(DayDifference != 0){
                        if (shorten){
                            ext = "d"
                        }else{
                            if (DayDifference > 1){
                                ext = "days"
                            }else{
                                ext = "day"
                            }
                        }
                        return ("\(DayDifference) \(ext)")
                    }else{
                        if(HourDifference != 0){
                            if (shorten){
                                ext = "h"
                            }else{
                                if (HourDifference > 1){
                                    ext = "hours"
                                }else{
                                    ext = "hour"
                                }
                            }
                            return ("\(HourDifference) \(ext)")
                        }else{
                            if(MinuteDifference != 0){
                                if (shorten){
                                    ext = "min"
                                }else{
                                    if (MinuteDifference > 1){
                                        ext = "minutes"
                                    }else{
                                        ext = "minute"
                                    }
                                }
                                return ("\(MinuteDifference) \(ext)")
                            }else{
                                if(SecondDifference != 0){
                                    if (shorten){
                                        ext = "s"
                                    }else{
                                        if (SecondDifference > 1){
                                            ext = "seconds"
                                        }else{
                                            ext = "second"
                                        }
                                    }
                                    return ("\(SecondDifference) \(ext)")
                                }else if (SecondDifference == 0){
                                    return ("just now")
                                }else{
                                    return "N/A"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
//    class func convertNSDateToString(fromDate:NSDate) -> String{
//
//        var calendar:NSCalendar = NSCalendar.currentCalendar()
//        
//        var DateComponents:NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond, fromDate: NSDate(), toDate: fromDate , options: nil)
//        var SecondDifference = DateComponents.second
//        var MinuteDifference = DateComponents.minute
//        var HourDifference = DateComponents.hour
//        var DayDifference = DateComponents.day
//        var MonthDifference = DateComponents.month
//        var YearDifference = DateComponents.year
//
//        var text:String = String()
//        if (YearDifference != 0){
//            // 2016 jun
//            var year = calendar.component(NSCalendarUnit.CalendarUnitYear, fromDate: fromDate)
//            var month = self.monthInText(calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: fromDate), shorten: true)
//            text = "\(year)\n\(month)"
//            return text
//        }else{
//            if (MonthDifference >= 0){
//                if (DayDifference > 0){
//                    if(DayDifference < 14){
//                        var weekDayText = self.weekDayInText(calendar.component(NSCalendarUnit.CalendarUnitWeekday, fromDate: fromDate), shorten: true)
//                        if (DayDifference > 7){ // next week , positive date
//                            return "Next\n\(weekDayText)"
//                        }else{                  // this week , positive date
//                            if (DayDifference == 0){
//                                return "Today"
//                            }else if (DayDifference == 1){
//                                return "Tomor"
//                            }else{
//                                return weekDayText
//                            }
//                        }
//                    }else{
//                        var day = calendar.component(NSCalendarUnit.CalendarUnitDay, fromDate: fromDate)
//                        var month = self.monthInText(calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: fromDate), shorten: true)
//                        return "\(day) \n\(month)"
//                    }
//                }else{ // this month, negative date
//                    var day = calendar.component(NSCalendarUnit.CalendarUnitDay, fromDate: fromDate)
//                    var month = self.monthInText(calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: fromDate), shorten: true)
//                    return "\(day) \n\(month)"
//                }
//
//            }else{ // previous month, negative date
//                
//                var day = calendar.component(NSCalendarUnit.CalendarUnitDay, fromDate: fromDate)
//                var month = self.monthInText(calendar.component(NSCalendarUnit.CalendarUnitMonth, fromDate: fromDate), shorten: true)
//                return "\(day)\n\(month)"
//            }
//        }
//        //
//    }
    
    class func eventDateToText(date:NSDate,tab:forTab) -> NSMutableAttributedString{
        var smallFont:CGFloat = 12
        var smallFontName = "Lato-Medium"
        var mediumFont:CGFloat = 13
        var mediumFontName = "Lato-Regular"

        var bigFont:CGFloat = 14
        var bigFontName = "Lato-Medium"

        if (tab == forTab.Home){
            smallFont = 14 // month
            mediumFont = 16 // for weekday
            bigFont = 27 // for day/year
        }else if (tab == forTab.Explore){
            smallFont = 12
            mediumFont = 13
            bigFont = 17
        }
        var difference = differenceBetweenDates(NSDate(), toDateTime: date)
        let calendar:NSCalendar = NSCalendar.currentCalendar()

        let DayDifference = difference["day"]!
        let MonthDifference = difference["month"]!
        let YearDifference = difference["year"]!


        //println(YearDifference)
        let text:NSMutableAttributedString = NSMutableAttributedString()
        if (YearDifference != 0){
            // 2016 jun
            let year = calendar.component(NSCalendarUnit.Year, fromDate: date)
            let month = self.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: date), shorten: true)
            if (tab == forTab.Explore){
                bigFont = 16
            }
            
            text.appendAttributedString(self.attrStr("\(year)", size: bigFont, fontName: bigFontName))
            text.appendAttributedString(NSAttributedString(string: "\n"))
            text.appendAttributedString(self.attrStr("\(month)", size: smallFont, fontName: smallFontName))
            return text
        }else{
            if (MonthDifference >= 0){
                if (DayDifference >= 0){
                    if(DayDifference < 13){
                        let weekDayText = self.weekDayInText(calendar.component(NSCalendarUnit.Weekday, fromDate: date), shorten: true)
                        if (DayDifference > 6){ // next week , positive date
                            text.appendAttributedString(self.attrStr("Next\n\(weekDayText)", size: mediumFont, fontName: mediumFontName))
                            return text
                        }else{                  // this week , positive date
                            if (DayDifference == 0){
                                text.appendAttributedString(self.attrStr("Today", size: mediumFont, fontName: mediumFontName))
                                return text
                            }else if (DayDifference == 1){
                                
                                text.appendAttributedString(self.attrStr("Tom", size: mediumFont, fontName: mediumFontName))
                                return text
                            }else{
                                text.appendAttributedString(self.attrStr("This\n\(weekDayText)", size: mediumFont, fontName: mediumFontName))
                                return text
                            }
                        }
                    }else{
                        let day = calendar.component(NSCalendarUnit.Day, fromDate: date)
                        let month = self.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: date), shorten: true)
                        text.appendAttributedString(self.attrStr("\(day)", size: bigFont, fontName: bigFontName))
                        text.appendAttributedString(NSAttributedString(string: "\n"))
                        text.appendAttributedString(self.attrStr("\(month)", size: smallFont, fontName:  smallFontName))
                        return text
                    }
                }else{ // this month, negative date
                    let day = calendar.component(NSCalendarUnit.Day, fromDate: date)
                    let month = self.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: date), shorten: true)
                    text.appendAttributedString(self.attrStr("\(day)", size: bigFont, fontName: bigFontName))
                    text.appendAttributedString(NSAttributedString(string: "\n"))
                    text.appendAttributedString(self.attrStr("\(month)", size: smallFont, fontName:  smallFontName))
                    return text
                }
                
            }else{ // previous month, negative date
                
                let day = calendar.component(NSCalendarUnit.Day, fromDate: date)
                let month = self.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: date), shorten: true)
                text.appendAttributedString(self.attrStr("\(day)", size: bigFont, fontName: bigFontName))
                text.appendAttributedString(NSAttributedString(string: "\n"))
                text.appendAttributedString(self.attrStr("\(month)", size: smallFont, fontName:  smallFontName))
                return text
            }
        }
    }
    
    class func differenceBetweenDates(fromDateTime:NSDate, toDateTime:NSDate) -> [String:Int]{
//        var DateComponents:NSDateComponents = NSDateComponents()
        var fromDate:NSDate? = nil
        var toDate:NSDate? = nil
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        var difference:[String:Int] = ["year": 0, "month": 0, "day": 0]
        //year
        calendar.rangeOfUnit(NSCalendarUnit.Year, startDate: &fromDate, interval: nil ,forDate: fromDateTime)
        calendar.rangeOfUnit(NSCalendarUnit.Year, startDate: &toDate, interval: nil, forDate: toDateTime)
        let YearDifference:NSDateComponents = calendar.components(NSCalendarUnit.Year, fromDate: fromDate!, toDate: toDate!, options: [])
        if (YearDifference.year != NSNotFound){
            difference["year"] = YearDifference.year
        }

        //month
        fromDate = nil
        toDate = nil
        calendar.rangeOfUnit(NSCalendarUnit.Month, startDate: &fromDate, interval: nil ,forDate: fromDateTime)
        calendar.rangeOfUnit(NSCalendarUnit.Month, startDate: &toDate, interval: nil, forDate: toDateTime)
        let MonthDifference:NSDateComponents = calendar.components(NSCalendarUnit.Month, fromDate: fromDate!, toDate: toDate!, options: [])
        
        if (MonthDifference.year != NSNotFound){
            difference["month"] = MonthDifference.year
        }
        
        //day
        fromDate = nil
        toDate = nil
        calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &fromDate, interval: nil ,forDate: fromDateTime)
        calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        let DayDifference:NSDateComponents = calendar.components(NSCalendarUnit.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        if (DayDifference.day != NSNotFound){
            difference["day"] = DayDifference.day
        }
        
        return difference
    }
    
    class func attrStr(text:String,size:CGFloat,fontName: String) -> NSAttributedString{
        
        let font = UIFont(name: fontName, size: size)!
//
//        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = NSTextAlignment.Center
//        paragraphStyle.lineSpacing = 1
//        paragraphStyle.lineHeightMultiple = 0.5
//        let minMaxLineHeight: CGFloat = (font.pointSize - font.ascender + font.capHeight)
//        let offset = font.capHeight - font.ascender
//        paragraphStyle.minimumLineHeight = minMaxLineHeight
//        paragraphStyle.maximumLineHeight = minMaxLineHeight
//        

        return NSAttributedString(string: "\(text)",
            attributes: [NSFontAttributeName: font])
    }
    class func monthInText(month:Int,shorten:Bool) -> String {
        var text:NSString = NSString()
        switch month{
        case 1:
            text = "January"
        case 2:
            text = "February"
        case 3:
            text = "March"
        case 4:
            text = "April"
        case 5:
            text = "May"
        case 6:
            text = "June"
        case 7:
            text = "July"
        case 8:
            text = "August"
        case 9:
            text = "September"
        case 10:
            text = "October"
        case 11:
            text = "November"
        case 12:
            text = "December"
        default:
            text = "   "
        }
        if (shorten){
            text = text.substringToIndex(3)
        }
        return text as String
    }
    
    class func weekDayInText(weekDay:Int,shorten:Bool) -> String {
        var text:NSString = NSString()
        switch weekDay{
        case 2:
            text = "Monday"
        case 3:
            text = "Tuesday"
        case 4:
            text = "Wednesday"
        case 5:
            text = "Thursday"
        case 6:
            text = "Friday"
        case 7:
            text = "Saturday"
        case 1:
            text = "Sunday" // in gregorian calendar 1 - sunday
        default:
            text = "   "
        }
        if (shorten){
            text = text.substringToIndex(3)
        }
        return text as String
    }
    
    
    class func getWeekdayFromDate(date:NSDate) -> String{

        var difference = differenceBetweenDates(NSDate(), toDateTime: date)
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        
        let DayDifference = difference["day"]!
        let MonthDifference = difference["month"]!
        let YearDifference = difference["year"]!
        
        
        //println(YearDifference)
//        var text:NSMutableAttributedString = NSMutableAttributedString()
        if (YearDifference != 0){
            return self.weekDayInText(calendar.component(NSCalendarUnit.Weekday, fromDate: date), shorten: false)
        }else{
            if (MonthDifference >= 0){
                if (DayDifference >= 0){
                    if(DayDifference < 13){
                        let weekDayText = self.weekDayInText(calendar.component(NSCalendarUnit.Weekday, fromDate: date), shorten: false)
                        if (DayDifference > 6){ // next week , positive date
                            return "Next\n\(weekDayText)"
                        }else{                  // this week , positive date
                            if (DayDifference == 0){
                                return "Today"
                            }else if (DayDifference == 1){
                                return "Tomorrow"
                            }else{
                                return "This\n\(weekDayText)"
                            }
                        }
                    }else{
                        return self.weekDayInText(calendar.component(NSCalendarUnit.Weekday, fromDate: date), shorten: false)

                    }
                }else{ // this month, negative date
                    return self.weekDayInText(calendar.component(NSCalendarUnit.Weekday, fromDate: date), shorten: false)
                }
                
            }else{ // previous month, negative date
                return self.weekDayInText(calendar.component(NSCalendarUnit.Weekday, fromDate: date), shorten: false)

            }
        }
    }
    
    
    class func dateToUsualFullString(date:NSDate) -> String{

        var difference = differenceBetweenDates(NSDate(), toDateTime: date)
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        
        let DayDifference = difference["day"]!
        let MonthDifference = difference["month"]!
        let YearDifference = difference["year"]!
        
        
        //println(YearDifference)
        if (YearDifference != 0){
            // 2016 jun
            let year = calendar.component(NSCalendarUnit.Year, fromDate: date)
            let month = self.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: date), shorten: false)
            let day = "\(calendar.component(NSCalendarUnit.Day, fromDate: date))"

            return "\(day) \(month) \(year)"
        }else{
            if (MonthDifference >= 0){
                if (DayDifference >= 0){
                    if(DayDifference < 13){
                        let weekDayText = self.weekDayInText(calendar.component(NSCalendarUnit.Weekday, fromDate: date), shorten: false)
                        if (DayDifference > 6){ // next week , positive date
                            return "Next \(weekDayText)"
                        }else{                  // this week , positive date
                            if (DayDifference == 0){
                                return "Today"
                            }else if (DayDifference == 1){
                                
                                return "Tomorrow"
                            }else{
                                return "This \(weekDayText)"
                            }
                        }
                    }else{
                        let day = calendar.component(NSCalendarUnit.Day, fromDate: date)
                        let month = self.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: date), shorten: false)
                        return "\(day) \(month)"

                    }
                }else{ // this month, negative date
                    let day = calendar.component(NSCalendarUnit.Day, fromDate: date)
                    let month = self.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: date), shorten: false)
                    return "\(day) \(month)"
                }
                
            }else{ // previous month, negative date
                
                let day = calendar.component(NSCalendarUnit.Day, fromDate: date)
                let month = self.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: date), shorten: false)
                return "\(day) \(month)"
            }
        }
    }

    
}
