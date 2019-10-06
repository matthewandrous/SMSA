//
//  XCalendar.swift
//  SMSAcalendar
//
/// Used and modified under the MIT License from: https://github.com/kiliankoe/iCalKit/

import Foundation

public class XCalendar {
    var eventList = [XEvent]()
    var name:String? = nil
    
    init(calendarName: String){
        self.name = calendarName
        print("XCalendar initialized")
    }



}

