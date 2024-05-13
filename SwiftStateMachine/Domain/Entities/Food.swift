//
//  Food.swift
//  SwiftStateMachine
//
//  Created by Santo Michael on 14/05/24.
//

import Foundation

struct Food: Identifiable {
	let id = UUID()
	let name: String
	let recipes: [Ingredient]
	let duration: Int // seconds
	var remainingTime: Int = 0 // seconds
	var state: FoodState = .ready
	
	enum FoodState {
		case ready
		case cooking
		case cooked
		case served
		case rejected
	}
}
