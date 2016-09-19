//
//  BattleBrain.swift
//  Battleship
//
//  Created by Victor Zhong on 9/17/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class BattleBrain {
	private let gridSize: Int
	internal let shipsArray = [5, 4, 3, 3, 2] // The allocation of hitpoints per ship, represented as index value
	private var holdArray = [Int]() // Holds onto all the values of the hitable buttons
	init(gridSize:Int){
		self.gridSize = gridSize
		setupGrids()
	}
	
	fileprivate enum State {
		case hitable
		case miss
	}
	
	private var grids = [State]()
	
	internal func placeShip(ships: [Int]) {
		holdArray = []
		for ship in ships {
			checkGrid(gridHealth: ship)
		}
		activateShipPositions()
		print(holdArray)
	}
	
	private func checkGrid(gridHealth: Int) {
		var tempArray = [Int]()
		let tempRandom = Int(arc4random_uniform(UInt32(gridSize)) + 1) // finds a random placement
		let directionSense = arc4random_uniform(2) // rolls 0 for horizontal, 1 for vertical
		if directionSense == 0 { //horizontal placement and position checking
			let boundsCheck = (tempRandom % 10) + gridHealth
			if boundsCheck > 10 || tempRandom % 10 == 0 {
				checkGrid(gridHealth: gridHealth)
				return
			} else {
				for x in 0..<gridHealth {
					for all in holdArray {
						if tempRandom + x == all {
							checkGrid(gridHealth: gridHealth)
							return
						}
					}
					tempArray.append(tempRandom + x)
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
						if (tempRandom + (x * 10)) == all {
							checkGrid(gridHealth: gridHealth)
							return
						}
					}
					tempArray.append(tempRandom + (x * 10))
				}
				holdArray.append(contentsOf: tempArray)
			}
		}
	}
	
	private func activateShipPositions() {
		for all in holdArray {
			grids[all-1] = .hitable
		}
	}
	
	internal func setupGrids(){
		grids = Array(repeating: .miss, count: gridSize)
	}
	
	internal func checkGrid(_ gridIn: Int) -> Bool{
		assert(gridIn < grids.count)  //helps with debugging
		return grids[gridIn] == .hitable
	}
}
