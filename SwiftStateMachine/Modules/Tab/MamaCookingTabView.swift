//
//  MamaCookingTabView.swift
//  SwiftStateMachine
//
//  Created by Santo Michael on 13/05/24.
//

import SwiftUI

struct MamaCookingTabView: View {
    var body: some View {
		NavigationStack {
			TabView {
				HomeView()
					.tabItem {
						Image(systemName: "list.clipboard")
						Text("Orders")
					}
				
//				RecipesView()
//					.tabItem {
//						Image(systemName: "fork.knife")
//						Text("Recipes")
//					}
				
				ServedView()
					.tabItem {
						Image(systemName: "checkmark.circle")
						Text("Served order")
					}
			}
		}
    }
}

#Preview {
    MamaCookingTabView()
}
