//
//  EventViewModel.swift
//  BetterSync
//
//  Created by Daniel on 3/19/25.
//
import SwiftUI

public class EventViewModel:ObservableObject
{
    func fetchICSFiles(from directory: String) -> [String] {
        
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(atPath: directory)
            return files.filter { $0.hasSuffix(".ics") }
        } catch {
            print("Error reading directory: \(error)")
            return []
        }
    }
    
    func parseICSFile(at path: String) -> [Event] {
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            print(content)
            let lines = content.components(separatedBy: .newlines)
            
            var events: [Event] = []
            var title: String?
            var location: String?
            var description: String?
            var dateStart: Date?
            var dateEnd: Date?
            var hostedOrganization: String?
            var additionalDetail: String?
            var url: String?
            var categories: [String] = []
        //    var categoryFilter: [String] = []
            for line in lines {
                if line.hasPrefix("BEGIN:VEVENT") {
                    title = nil
                    location = nil
                    description = nil
                    dateStart = Date()
                    dateEnd = Date()
                    categories = []
                    hostedOrganization = nil
                    additionalDetail = nil
                    url = nil
                } else if line.hasPrefix("SUMMARY:") {
                    title = line.replacingOccurrences(of: "SUMMARY:", with: "").trimmingCharacters(in: .whitespaces)
                } else if line.hasPrefix("LOCATION:") {
                    location = line.replacingOccurrences(of: "LOCATION:", with: "").trimmingCharacters(in: .whitespaces)
                } else if line.hasPrefix("CATEGORIES:") {
                    categories.append(line.replacingOccurrences(of: "CATEGORIES:", with: "").trimmingCharacters(in: .whitespaces))
                } else if line.hasPrefix("DESCRIPTION:") {
                    description = line.replacingOccurrences(of: "DESCRIPTION:", with: "").trimmingCharacters(in: .whitespaces)
                } else if line.hasPrefix("DTSTART:") {
                    let timeStamp = line.replacingOccurrences(of: "DTSTART:", with:
                                                                "").trimmingCharacters(in: .whitespaces)
                    dateStart = parseICSTimeStamp(timeStamp: timeStamp)
                } else if line.hasPrefix("DTEND:") {
                    let timeStamp = line.replacingOccurrences(of: "DTEND:", with:
                                                                "").trimmingCharacters(in: .whitespaces)
                    dateEnd = parseICSTimeStamp(timeStamp: timeStamp)
                }  else if line.hasPrefix("UID:") {
                    url = line.replacingOccurrences(of: "UID:",  with: "").trimmingCharacters(in: .whitespaces)
                } else if line.hasPrefix("X-HOSTS:") {
                    hostedOrganization = line.replacingOccurrences(of: "X-HOSTS:",  with: "").trimmingCharacters(in: .whitespaces)
                    print(hostedOrganization!)
                } else if line.hasPrefix("X-DETAIL:") {
                    additionalDetail = line.replacingOccurrences(of: "X-DETAIL:", with: "").trimmingCharacters(in: .whitespaces)
                } else if line.hasPrefix("END:VEVENT") {
                    if let eventTitle = title {
                        events.append(Event(
                            title: eventTitle,
                            location: location,
                            description: description,
                            hostedOrganization: hostedOrganization,
                            additionalDetail: additionalDetail,
                            dateStart: dateStart,
                            dateEnd: dateEnd,
                            url: url,
                            category: categories))
                    }
                }
            }
            return events
        } catch {
            print("Error reading .ics: \(error)")
            return []
        }
    }
    
    
    func processICSFiles(in directory: String) -> [Event] {
        let files = fetchICSFiles(from: directory)
        var events: [Event] = []
        
        for file in files {
            let filePath = "\(directory)/\(file)"
            events.append(contentsOf: parseICSFile(at: filePath))
        }
        
        //print("Final loaded events:", events.map { $0.title })
        return events
    }
    
    //
    func parseICSTimeStamp(timeStamp: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"        //ics' expected date format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")   //sets the timezone to UTC since 'Z'
        
        if let validDate = dateFormatter.date(from: timeStamp) { //converts the timestamp into a date object
            return validDate
        }   else {
            print("invalid date")
            return Date()
        }
    }
    
    func formatDateToString(time: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy hh:mm a zzz"       //formats the date into month, day, year, hour, min, am/pm, timezone
        format.timeZone = TimeZone(identifier: "America/Phoenix")
        return format.string(from: time)
    }

    

}
