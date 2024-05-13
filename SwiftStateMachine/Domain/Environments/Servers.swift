//
//  Orders.swift
//  SwiftStateMachine
//
//  Created by Santo Michael on 14/05/24.
//

import Foundation
import SwiftUI

internal class Servers: ObservableObject {
	static let shared = Servers()
	private init() {}
	@Published var orders: [Food] = []
	
	func cook(id: UUID) {
		if let foodIndex = orders.firstIndex(where: { $0.id == id }) {
			var selectedFood = orders[foodIndex]
			selectedFood.state = .cooking
			if selectedFood.remainingTime == 0 {
				selectedFood.remainingTime = selectedFood.duration
			}
			orders[foodIndex] = selectedFood
		}
	}
	
	func stopCook(id: UUID) {
		if let foodIndex = orders.firstIndex(where: { $0.id == id }) {
			var selectedFood = orders[foodIndex]
			selectedFood.state = .ready
			orders[foodIndex] = selectedFood
		}
	}
	
	func serve(id: UUID) {
		if let foodIndex = orders.firstIndex(where: { $0.id == id }) {
			var selectedFood = orders[foodIndex]
			selectedFood.state = .served
			orders[foodIndex] = selectedFood
		}
	}
	
	func reject(id: UUID) {
		if let foodIndex = orders.firstIndex(where: { $0.id == id }) {
			var selectedFood = orders[foodIndex]
			selectedFood.state = .rejected
			orders[foodIndex] = selectedFood
		}
	}
	
	func add(_ food: Food) {
		orders.append(food)
	}
}
