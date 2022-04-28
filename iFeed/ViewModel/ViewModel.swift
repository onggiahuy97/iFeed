//
//  ViewModel.swift
//  iFeed
//
//  Created by Huy Ong on 4/17/22.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var appGroups: [AppGroup] = []
    @Published var selectedContry: CountryCode = .us {
        didSet {
            appGroups = []
            reload()
        }
    }
    
    init() {
        reload()
    }
    
    func reload() {
        Task {
            do {
                appGroups = try await Service.shared.fetchAppGroups(selectedContry)
                print("Count: \(appGroups.count)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

