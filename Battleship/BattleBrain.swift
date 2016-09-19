//
//  BattleBrain.swift
//  Battleship
//
//  Created by Victor Zhong on 9/17/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

// I am not sure why the placeShip() sometimes outputs a string with more than the expected 17 characters

class BattleBrain {
	let gridSize: Int
	let shipsArray = [5, 4, 3, 3, 2] // The allocation of hitpoints per ship, represented as index value
	var holdArray = [Int]() // Holds onto all the values of the hitable buttons
	init(gridSize:Int){
		self.gridSize = gridSize
		setupGrids()
	}
	
	fileprivate enum State {
		case hitable
		case miss
	}
	
	private var grids = [State]()
	
	func placeShip(ships: [Int]) {
		holdArray = []
		for ship in ships {
			checkGrid(gridHealth: ship)
		}
		activateShipPositions()
		print(holdArray)
	}
	
	func checkGrid(gridHealth: Int) {
		var tempArray = [Int]()
		let tempRandom = arc4random_uniform(UInt32(gridSize)) + 1 // finds a random placement
		let directionSense = arc4random_uniform(2) // rolls 0 for horizontal, 1 for vertical
		if directionSense == 0 { //horizontal placement and position checking
			let boundsCheck = (Int(tempRandom) % 10) + gridHealth
			if boundsCheck > 10 || tempRandom % 10 == 0 {
				checkGrid(gridHealth: gridHealth)
				return
			} else {
				for x in 0..<gridHealth {
					for all in holdArray {
						if Int(tempRandom) + x == all {
							checkGrid(gridHealth: gridHealth)
							return
						}
					}
					tempArray.append(Int(tempRandom) + x)
				}
				holdArray.append(contentsOf: tempArray)
			}
		} else { // vertical placement and position checking
			let boundsCheck = Int(tempRandom) + (gridHealth*10)
			if boundsCheck > 100 {
				checkGrid(gridHealth: gridHealth)
				return
			} else {
				for x in 0..<gridHealth {
					for all in holdArray {
						if (Int(tempRandom) + (x * 10)) == all {
							checkGrid(gridHealth: gridHealth)
							return
						}
					}
					tempArray.append(Int(tempRandom) + (x * 10))
				}
				holdArray.append(contentsOf: tempArray)
			}
		}
	}
	
	func activateShipPositions() {
		for all in holdArray {
			grids[all-1] = .hitable
		}
	}
	
	func setupGrids(){
		grids = Array(repeating: .miss, count: gridSize)
	}
	
	func checkGrid(_ gridIn: Int) -> Bool{
		assert(gridIn < grids.count)  //helps with debugging
		return grids[gridIn] == .hitable
	}
}
