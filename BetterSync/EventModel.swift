//
//  EventModel.swift
//  BetterSync
//
//  Created by Daniel on 3/19/25.
//
import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    var title: String
    let location: String?
    let description: String?
    let hostedOrganization: String?
    let additionalDetail: String?
    var dateStart: Date?
    let dateEnd: Date?
    //   let status: String?               //confirmed or canceled
    let url: String?                  //asu url event
    let category: [String]
    
    
}
