//
//  ServedView.swift
//  SwiftStateMachine
//
//  Created by Santo Michael on 14/05/24.
//

import SwiftUI

struct ServedView: View {
	@EnvironmentObject var servers: Servers
	var body: some View {
		List {
			ForEach(servers.orders.filter { $0.state == .served }) { food in
				HStack {
					Text(food.name)
				}
			}
		}
	}
}

#Preview {
    ServedView()
}
