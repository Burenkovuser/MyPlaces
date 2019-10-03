//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Vasilii on 02/10/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView { // @IBDesignable изменения в коде в реальном времени буду показывать в интерфейс билдере
    
    // MARK: Proprties
    
    var rating = 0 {
        didSet{
            updateButtonSelectiionState()
        }
    }
    
    private var ratingButtons = [UIButton]()
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var startCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    

    // MARK: Inicializatiion
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
        //fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Button action
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        // Calulate the rating the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    // MARK: Private methods
    
    private func setupButtons() {
        
        // прежде чем создать отчищаем
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // Load button image
        let bundel = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar",
                                 in: bundel,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundel,
                                compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named: "highlightedStar",
                                    in: bundel,
                                    compatibleWith: self.traitCollection)
        
        // создаем пять кнопок
        for _ in 0..<startCount {
            // Create the button
                    let button = UIButton()
                    //button.backgroundColor = .red
            
            // Set the button image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar , for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
                    
                    // Add constrains
                    button.translatesAutoresizingMaskIntoConstraints = false // отключаем автоматические констрейнты
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
                    
                    //Setup the button action
                    button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
                    
                    // Add button to the stack view
                    addArrangedSubview(button)
            
            // Add the new button on the rating button array
            ratingButtons.append(button)
                }
               updateButtonSelectiionState()
            }
    
    private func updateButtonSelectiionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
        
