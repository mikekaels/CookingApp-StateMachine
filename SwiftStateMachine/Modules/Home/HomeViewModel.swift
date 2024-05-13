//
//  HomeViewModel.swift
//  SwiftStateMachine
//
//  Created by Santo Michael on 13/05/24.
//

import Foundation

enum HomeState: Equatable {
	case initial
	case cooking
	case empty
	case error
}

enum HomeEvent {
	case onAppear
	case cook(UUID)
	case stopCook(UUID)
	case serve(UUID)
	case reject(UUID)
	case tick(UUID)
}

internal class HomeViewModel: StateMachine<HomeState, HomeEvent>   {
	private var timers: [UUID: Timer] = [:]
	
	override init(_ initialState: HomeState) {
		super.init(initialState)
		DispatchQueue.main.async {
			[
				Food(name: "Scrambled egg", recipes: [.init(name: "Egg"), .init(name: "Butter")], duration: 5),
				Food(name: "Fried rice", recipes: [.init(name: "Rice"), .init(name: "Onion"), .init(name: "Sweet Soy Sauce")], duration: 10),
				Food(name: "Pancake", recipes: [.init(name: "Flour"), .init(name: "Eggs"), .init(name: "Mil")], duration: 8),
				Food(name: "Spaghetti carbonara", recipes: [.init(name: "Pancetta"), .init(name: "Parmesan"), .init(name: "Spaghetti")], duration: 15)
			]
				.forEach { Servers.shared.add($0) }
		}
	}
	
	override func handleEvent(_ event: HomeEvent) -> HomeState? {
		switch (state, event) {
			case (.initial, .onAppear):
				return .initial
				
			case (.initial, .cook(let id)), (.cooking, .cook(let id)):
				Servers.shared.cook(id: id)
				startCookingTimer(id: id)
				return .cooking
				
			case (.cooking, .tick(let id)):
				if let foodIndex = Servers.shared.orders.firstIndex(where: { $0.id == id }) {
					if Servers.shared.orders[foodIndex].state == .cooking {
						Servers.shared.orders[foodIndex].remainingTime -= 1
						if Servers.shared.orders[foodIndex].remainingTime <= 0 {
							Servers.shared.orders[foodIndex].state = .cooked
							// Stop timer if no more items are cooking
							if !Servers.shared.orders.contains(where: { $0.state == .cooking }) {
								stopAllTimers()
								return .initial
							}
						}
					}
				}
//				for index in Servers.shared.orders.indices {
//					if Servers.shared.orders[index].state == .cooking {
//						Servers.shared.orders[index].remainingTime -= 1
//						if Servers.shared.orders[index].remainingTime <= 0 {
//							Servers.shared.orders[index].state = .cooked
//							// Stop timer if no more items are cooking
//							if !Servers.shared.orders.contains(where: { $0.state == .cooking }) {
//								stopAllTimers()
//								return .initial
//							}
//						}
//					}
//				}
				return .cooking
				
			case (.cooking, .stopCook(let id)):
				stopCookingTimer(foodID: id)
				Servers.shared.stopCook(id: id)
				return state
				
			case (.initial, .serve(let id)), (.cooking, .serve(let id)):
				Servers.shared.serve(id: id)
				return state
				
			case (.initial, .reject(let id)), (.cooking, .reject(let id)):
				Servers.shared.reject(id: id)
				return state
				
			default:
				print("Event(\(event)) are not handled")
		}
		return nil
	}
	
	override func handleStateUpdate(_ oldState: HomeState, new newState: HomeState) {
		switch (oldState, newState) {
			default:
				print("You lended in a misterious place... Coming from \(oldState) and trying to get to \(newState)")
		}
	}
	
	private func startCookingTimer(id: UUID) {
		guard timers[id] == nil else { return }
		let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
			self?.send(event: .tick(id))
		}
		timers[id] = timer
	}
	
	private func stopCookingTimer(foodID: UUID) {
		timers[foodID]?.invalidate()
		timers[foodID] = nil
	}
	
	private func stopAllTimers() {
		for (foodID, timer) in timers {
			timer.invalidate()
			timers[foodID] = nil
		}
	}
	
	
	func secondsToTimeString(seconds: Int) -> String {
		let minutes = seconds / 60
		let remainingSeconds = seconds % 60
		
		let minutesString = String(format: "%02d", minutes)
		let secondsString = String(format: "%02d", remainingSeconds)
		
		return "\(minutesString):\(secondsString)"
	}
}
