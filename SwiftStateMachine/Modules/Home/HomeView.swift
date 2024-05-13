//
//  HomeView.swift
//  SwiftStateMachine
//
//  Created by Santo Michael on 13/05/24.
//

import SwiftUI

struct HomeView: View {
	@EnvironmentObject var servers: Servers
	@StateObject var viewModel = HomeViewModel(.initial)
	
    var body: some View {
		NavigationView {
			List {
				ForEach(servers.orders.filter { $0.state != .rejected && $0.state != .served }) { food in
					HStack {
						Text(food.name)
							.swipeActions {
								if food.state == .ready {
									Button("Cook") {
										viewModel.send(event: .cook(food.id))
									}
									.tint(.yellow)
								}
								
								if food.state == .cooking {
									Button("Stop") {
										viewModel.send(event: .stopCook(food.id))
									}
									.tint(.yellow)
								}
								
								if food.state == .cooked {
									Button("Serve") {
										withAnimation {
											viewModel.send(event: .serve(food.id))
										}
									}
									.tint(.green)
								}
								
								if food.state != .cooking {
									Button("Reject") {
										withAnimation {
											viewModel.send(event: .reject(food.id))
										}
									}
									.tint(.red)
								}
							}
						
						Spacer()
						if food.remainingTime != 0 {
							Text(viewModel.secondsToTimeString(seconds: food.remainingTime))
						} else if food.state == .cooked {
							Image(systemName: "checkmark.circle.fill")
								.resizable()
								.renderingMode(.template)
								.aspectRatio(contentMode: .fit)
								.frame(width: 20, height: 20)
								.foregroundColor(.green)
						}
					}
				}
			}
			.navigationBarTitle(Text("Orders"))
		}
    }
}

#Preview {
    HomeView()
}
