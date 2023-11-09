//
//  Router.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 31/10/2023.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func reset() {
        path = NavigationPath()
    }
}
