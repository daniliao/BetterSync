//
//  HomeView.swift
//  BetterSync
//
//  Created by Daniel on 3/19/25.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var eventVM = EventViewModel()
    @State var events: [Event] = []
    @State var eventName = ""
    @State private var showHomeView = true
    @State private var showDiscoverView = false
    @State var toTodayView: Bool = false
    
    
    var body: some View {
        let catVM = CategoryViewModel(eventViewModel: eventVM)
        NavigationView{
            Form {
                Section(){
                    HStack{
                        TextField("Search all events", text: $eventName)
                        Button(action:
                                {
                            
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                    }
                }
                
                
                
                Section("Events"){
                    if toTodayView {
                        TodayEventView(vm: eventVM, categoryVM: catVM, events: $events, eventName: $eventName)
                    } else {
                        AllEventView(vm: eventVM, categoryVM: catVM, events: $events, eventName: $eventName)
                    }
                }
                
            }
            .padding()
            .navigationTitle("Welcome back")
            .onAppear {
                
                events = eventVM.processICSFiles(in: "/Users/lindachen/Desktop/CSE335/BetterSync/BetterSync")
                print("Loaded events from HomeView: \(events.count)")
              //  print("ALL CATEGORIES: \(catVM.getAllCategories(events: events))")
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Today") {
                        toTodayView = true
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("This week") { }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {
                            showHomeView = true
                        }) {
                            Image(systemName: "house")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        
                        Spacer().frame(width: 50)
                        
                        Button(action: {
                            showDiscoverView = true
                        }) {
                            Image(systemName: "wand.and.stars.inverse")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
    }
}

struct TodayEventView: View {
    @ObservedObject var vm: EventViewModel
    var categoryVM: CategoryViewModel
    @Binding  var events: [Event]
    @Binding  var eventName: String
    @State private var isLoading = true
   // let projectFolder = "/Users/daniel/Desktop/CSE 335/BetterSync/BetterSync"
    let projectFolder = "/Users/lindachen/Desktop/CSE335/BetterSync/BetterSync"
    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        List($events) { event in
            if let timeStart = event.dateStart.wrappedValue {
                let time = formattedDate(from: timeStart)
                let today = formattedDate(from: Date())
                
                if time == today {
                    VStack(alignment: .leading) {
                        
                        Text(event.wrappedValue.title)
                            .font(.headline)
                        Text("TIME: \(time)").font(.subheadline)
                        if let location = event.wrappedValue.location {
                            Text("📍 Location: \(location)").font(.subheadline)
                        }
                        if let description = event.wrappedValue.description {
                            Text("📝 \(description)").font(.subheadline)
                        }
                        if let host = event.wrappedValue.hostedOrganization {
                            Text("🏢 Hosted by: \(host)").font(.subheadline)
                        }else {
                            Text("🏢 Hosted by: ASU").font(.subheadline)
                        }
                        if let detail = event.wrappedValue.additionalDetail {
                            Text("🔍 Additional: \(detail)").font(.subheadline)
                        }
                        
                        if let url = event.wrappedValue.url {
                            Text("URL: \(url)").font(.subheadline)
                        }
                    
                        if !event.wrappedValue.category.isEmpty {
                            Text("Category: \(categoryVM.getCategory(event: event.wrappedValue).joined(separator: ", "))")
                            let filters = event.wrappedValue.category
                            Text("Filters: \(categoryVM.filterCategories(categories: filters).joined(separator: ","))")
                            
                        }
                    }
                }
            }
        }
    }
}

struct AllEventView: View {
    @ObservedObject var vm: EventViewModel
    var categoryVM: CategoryViewModel
    @Binding  var events: [Event]
    @Binding  var eventName: String
    @State private var isLoading = true
   // let projectFolder = "/Users/daniel/Desktop/CSE 335/BetterSync/BetterSync"
    let projectFolder = "/Users/lindachen/Desktop/CSE335/BetterSync/BetterSync"
    
    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        List($events) { event in
            let categoryVM = CategoryViewModel(eventViewModel: vm)
            VStack(alignment: .leading) {
                
                Text(event.wrappedValue.title)
                    .font(.headline)
                if let timeStart = event.dateStart.wrappedValue {
                    let time = vm.formatDateToString(time: timeStart)
                    Text("TIME: \(time)").font(.subheadline)
                }
                if let location = event.wrappedValue.location {
                    Text("📍 Location: \(location)").font(.subheadline)
                }
                if let description = event.wrappedValue.description {
                    Text("📝 \(description)").font(.subheadline)
                }
                if let host = event.wrappedValue.hostedOrganization {
                    Text("🏢 Hosted by: \(host)").font(.subheadline)
                }else {
                    Text("🏢 Hosted by: ASU").font(.subheadline)
                }
                if let detail = event.wrappedValue.additionalDetail {
                    Text("🔍 Additional: \(detail)").font(.subheadline)
                }
                
                if let url = event.wrappedValue.url {
                    Text("URL: \(url)").font(.subheadline)
                }
                
                if !event.wrappedValue.category.isEmpty {
                    Text("Category: \(event.wrappedValue.category.joined(separator: ", "))")
                    let filters = event.wrappedValue.category
                    Text("Filters: \(categoryVM.filterCategories(categories: filters).joined(separator: ","))")
                }
                // we need to clean category display
                //                            if !event.wrappedValue.category.isEmpty {
                //                                Text("Category: \(event.wrappedValue.category.joined(separator: ", "))")
                //                            }
            }
        }
    }
    
    
}
