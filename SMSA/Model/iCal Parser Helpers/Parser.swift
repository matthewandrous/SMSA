import Foundation

/// Used and modified under the MIT License from: https://github.com/kiliankoe/iCalKit/internal

class Parser {
    let icsContent: [String]
    
    init(_ ics: [String]) {
        icsContent = ics
    }
    
    func read(calendarName: String) -> XCalendar{
        var completeCal = XCalendar(calendarName: calendarName)
        
        //calendar data fields
        var calname:String? = "none"
        
        //event data fields
        var summary:String? = "none"
        var dtstart:String? = "none"
        var dtend:String? = "none"
        var rrule:String? = "none"
        
        var inEvent = false
        
        for (_ , line) in icsContent.enumerated() {
            
            var field:String = "no data found"
            var data:String = "no data found"
            
            
            if inEvent {
                var splitLine = line.split(separator: ":")
                if(splitLine.count > 1){
                    field = String(splitLine[0])
                    data = String(splitLine[1])
                    if field.contains(";"){
                        field = String(field.split(separator: ";")[0])
                    }
                }
            } else {
                field = line
            }
            

            switch field {
                case "BEGIN:VCALENDAR\r":
                    calname = "none"
                    continue
                case "END:VCALENDAR\r":
                    continue
                case "BEGIN:VEVENT\r":
                    print()
                    print("STARTING EVENT=======")
                    summary = "none"
                    rrule = "none"
                    dtstart = "none"
                    dtend = "none"
                    inEvent = true
                    continue
                case "SUMMARY":
                    print("summary: " + data)
                    summary = data
                    continue
                case "RRULE":
                    print("rrule: " + data)
                    rrule = data
                    continue
                case "DTSTART":
                    print("dtstart: " + data)
                    dtstart = data
                    continue
                case "DTEND":
                    print("dtend: " + data)
                    dtend = data
                    continue
                case "END":
                    if true{
                        print("ENDING EVENT=======")
                        completeCal.eventList.append(XEvent.init(summary: summary!, dtstart: dtstart!, dtend: dtend!, rrule: rrule!))
                        inEvent = false
                    }
                    continue
                default:
                    break
            }
        }
        return completeCal
    }
}
