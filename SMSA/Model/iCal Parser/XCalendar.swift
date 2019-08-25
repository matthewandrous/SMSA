//
//  XCalendar.swift
//  SMSAcalendar
//
//  Created by Matthew Androus on 8/22/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import Foundation

public class XCalendar {
    var eventList = [XEvent]()
    var name:String? = nil
    
    init(calendarName: String){
        self.name = calendarName
        print("XCalendar initialized")
    }



}

