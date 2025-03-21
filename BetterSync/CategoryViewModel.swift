//
//  CategoryViewModel.swift
//  BetterSync
//
//  Created by Linda Chen on 3/20/25.
//

import Foundation
import SwiftUI

public class CategoryViewModel:ObservableObject
{
    @Published var categoryNames: [CategoryGroup] = []
    
    /* All the category filters (so far)*/
    private var AcademicGroup = CategoryGroup(groupName:"Academics and Learning", categories:["ThoughtfulLearning", "Career and Professional Development"])
    
    private var StudentClubGroup = CategoryGroup(groupName:"Student Organizations", categories:["Clubs and Organization Information", "Barrett Student Organization", "Club Meetings"])
    
    private var CulturalGroup = CategoryGroup(groupName:"Cultural", categories:["Multicultural Communities of Excellence", "Cultural Connections and Multicultural Communities of Excellence", "Cultural", "Culture @ ASU", "International", "Indigenous Culture Week", "Indigenous People's Day", "Asian American & Pacific Islander Heritage Month"])
    
    private var SocialGroup = CategoryGroup(groupName: "Social", categories:["In-Person Event", "ASU Sync", "Social", "CommunityService", "Civic Engagement", "Changemaker Central", "Sun Devils UNITE", "Sustainability", "Change The World", "General"])
    
    private var WellnessGroup = CategoryGroup(groupName: "Wellness", categories:["Sun Devil Fitness/Wellness", "DeStress Fest", "Spirituality"])
    
    private var EntertainmentGroup = CategoryGroup(groupName: "Entertainment", categories:["Arts", "PAB Event", "Student Engagement Event", "Student Organization Event"])
    
    private var SportGroup = CategoryGroup(groupName: "Sport", categories:["Athletics"])
    
    private var EntrepreneurGroup = CategoryGroup(groupName: "Entrepreneur", categories:["Entrepreneurship & Innovation", "W.P. Carey Event"])
    
    private var ASUGroup = CategoryGroup(groupName: "ASU", categories:["ASU New Student Experience", "ASU Welcome Event", "University Signature Event", "ASU California Center Events", "California Events", "Student Engagement Event"])
    
    private var FundraisingGroup = CategoryGroup(groupName: "Fundraising", categories:["Fundraising"])
    
    private var eventViewModel: EventViewModel
    
    init(eventViewModel: EventViewModel) {
        self.eventViewModel = eventViewModel
    }
    
    // Returns a list of all the possible distinct categories
    func getAllCategories(events: [Event]) -> CategoryGroup {
        var allCategories: [String] = []
        
        for event in events {
            let eventCategories = getCategory(event: event)
            for cat in eventCategories {
                if !allCategories.contains(cat) {
                    allCategories.append(cat)
                }
            }
        }
        
        let allCatGroup = CategoryGroup(groupName: "ALL", categories: allCategories)
       // print(allCatGroup)
        return allCatGroup
    }
    
    func getCategory(event: Event) -> [String] {
        return event.category
    }
    
    // Method to filter events by category group
    func filterCategories(categories: [String]) -> [String] {
        var filteredCategoryNames: [String] = []
        
        if isAcademicEvent(categories: categories) {
            filteredCategoryNames.append(AcademicGroup.groupName)
        }
        
        if isStudentClubEvent(categories: categories) {
            filteredCategoryNames.append(StudentClubGroup.groupName)
        }
        
        if isCultureEvent(categories: categories) {
            filteredCategoryNames.append(CulturalGroup.groupName)
        }
        
        if isSocialEvent(categories: categories) {
            filteredCategoryNames.append(SocialGroup.groupName)
        }
        
        if isWellnessEvent(categories: categories) {
            filteredCategoryNames.append(WellnessGroup.groupName)
        }
        
        if isEntertainmentEvent(categories: categories) {
            filteredCategoryNames.append(EntertainmentGroup.groupName)
        }
        
        if isSportEvent(categories: categories) {
            filteredCategoryNames.append(SportGroup.groupName)
        }
        
        if isEntrepreneurEvent(categories: categories) {
            filteredCategoryNames.append(EntrepreneurGroup.groupName)
        }
        
        if isASUEvent(categories: categories) {
            filteredCategoryNames.append(ASUGroup.groupName)
        }
        
        if isFundraiserEvent(categories: categories) {
            filteredCategoryNames.append(FundraisingGroup.groupName)
        }
        
       // print(filteredCategoryNames)
        return filteredCategoryNames
    }
    
    private func isAcademicEvent(categories: [String]) -> Bool {
        return !Set(AcademicGroup.categories).isDisjoint(with: Set(categories))
    }
    
    private func isStudentClubEvent(categories: [String]) -> Bool {
        return !Set(StudentClubGroup.categories).isDisjoint(with: Set(categories))
    }
    
    private func isCultureEvent(categories: [String]) -> Bool {
        return !Set(CulturalGroup.categories).isDisjoint(with: Set(categories))
    }
    
    private func isSocialEvent(categories: [String]) -> Bool {
        return !Set(SocialGroup.categories).isDisjoint(with: Set(categories))
    }
    
    private func isWellnessEvent(categories: [String]) -> Bool {
        return !Set(WellnessGroup.categories).isDisjoint(with: Set(categories))
    }
    
    private func isEntertainmentEvent(categories: [String]) -> Bool {
        return !Set(EntertainmentGroup.categories).isDisjoint(with: Set(categories))
    }
    
    private func isSportEvent(categories: [String]) -> Bool {
        return !Set(SportGroup.categories).isDisjoint(with: Set(categories))
    }
    
    private func isEntrepreneurEvent(categories: [String]) -> Bool {
        return !Set(EntrepreneurGroup.categories).isDisjoint(with: Set(categories))
    }
    
    private func isASUEvent(categories: [String]) -> Bool {
        return !Set(ASUGroup.categories).isDisjoint(with: Set(categories))
    }
    
    private func isFundraiserEvent(categories: [String]) -> Bool {
        return !Set(FundraisingGroup.categories).isDisjoint(with: Set(categories))
    }
    
    
}
