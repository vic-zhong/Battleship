//
//  FirstViewController.swift
//  Battleship
//
//  Created by Jason Gresh on 9/16/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
	
	@IBOutlet weak var gameLabel: UILabel!
	@IBOutlet weak var buttonContainer: UIView!
	
	let howManyGrids: Int
	
	
	let battleEngine: BattleBrain
	var loaded: Bool
	let resetTitle = "Reset"
	
	required init?(coder aDecoder: NSCoder) {
		self.howManyGrids = 100 // How big is the playing field?
		self.loaded = false
		self.battleEngine = BattleBrain(gridSize: self.howManyGrids)
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidLayoutSubviews() {
		if !loaded {
			setUpGameButtons(v: buttonContainer, totalButtons: self.howManyGrids, buttonsPerRow: 10)
			self.view.setNeedsDisplay()
			setUpResetButton()
			battleEngine.placeShip(ship: battleEngine.shipsArray)
		}
		loaded = true
	}
	
	func resetButtonColors() {
		for v in buttonContainer.subviews {
			if let button = v as? UIButton {
				button.backgroundColor = UIColor.blue
				button.isEnabled = true
			}
		}
	}
	
	func handleReset() {
		resetButtonColors()
		battleEngine.setupGrids()
		setUpGameLabel()
	}
	
	func disableCardButtons() {
		for v in buttonContainer.subviews {
			if let button = v as? UIButton {
				button.isEnabled = false
			}
		}
	}
	
	func buttonTapped(_ sender: UIButton) {
		gameLabel.text = sender.currentTitle
		
		if battleEngine.checkGrid(sender.tag - 1) {
			gameLabel.text = "That was a hit!"
			sender.backgroundColor = UIColor.red
			//disableCardButtons()
		}
		else {
			gameLabel.text = "Miss!"
			sender.backgroundColor = UIColor.white
		}
	}
	
	func setUpResetButton() {
		let resetRect = CGRect(x: 150, y: 475, width: 60, height: 40)
		let resetButton = UIButton(frame: resetRect)
		resetButton.setTitle(resetTitle, for: UIControlState())
		resetButton.backgroundColor = UIColor.darkGray
		resetButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
		view.addSubview(resetButton)
	}
	
	func setUpGameLabel () {
		gameLabel.text = "Let's Play!"
	}
	
	func setUpGameButtons(v: UIView, totalButtons: Int, buttonsPerRow : Int) {
		for i in 1...howManyGrids {
			let y = ((i - 1) / buttonsPerRow)
			let x = ((i - 1) % buttonsPerRow)
			let side : CGFloat = v.bounds.size.width / CGFloat(buttonsPerRow)
			
			let rect = CGRect(origin: CGPoint(x: side * CGFloat(x), y: (CGFloat(y) * side)), size: CGSize(width: side, height: side))
			let button = UIButton(frame: rect)
			button.tag = i
			button.backgroundColor = UIColor.blue
			button.setTitle(String(i), for: UIControlState())
			button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
			v.addSubview(button)
		}
	}
}
