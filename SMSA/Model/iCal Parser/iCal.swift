import Foundation

public enum iCal {
    /// Loads the content of a given string.
    ///
    /// - Parameter string: string to load
    /// - Returns: List of containted `Calendar`s
    public static func load(string: String) -> XCalendar {
        let icsContent = string.components(separatedBy: "\n")
        return parse(icsContent)
    }
    
    /// Loads the contents of a given URL. Be it from a local path or external resource.
    ///
    /// - Parameters:
    ///   - url: URL to load
    ///   - encoding: Encoding to use when reading data, defaults to UTF-8
    /// - Returns: List of contained `Calendar`s.
    /// - Throws: Error encountered during loading of URL or decoding of data.
    /// - Warning: This is a **synchronous** operation! Use `load(string:)` and fetch your data beforehand for async handling.
    public static func load(url: URL, encoding: String.Encoding = .utf8) throws -> XCalendar {
        let data = try Data(contentsOf: url)
        let string = String(data: data, encoding: encoding)!
        return load(string: string)
    }
    
    private static func parse(_ icsContent: [String]) -> XCalendar {
        let parser = Parser(icsContent)
        return parser.read(calendarName: "Liturgical Services")
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        return dateFormatter
    }()
}
