//
//  FavouriteControl.swift
//  MeetU
//
//  Created by Alexandre dos Santos Rodrigues on 18/01/2020.
//  Copyright © 2020 MeetU Inc. All rights reserved.
//

import UIKit

@IBDesignable class FavouriteControl: UIStackView {
    
    //MARK: Properties
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 1 {
        didSet {
            setupButtons()
        }
    }
    
    private var favouriteButton = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Private Methods
    
    private func setupButtons() {
        // clear any existing buttons
        for button in favouriteButton {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        favouriteButton.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle,
                                 compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith:
            self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle,
                                      compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive =
            true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive =
            true
            
            // Setup the button action
            button.addTarget(self,
                             action: #selector(FavouriteControl.ratingButtonTapped(button:)),
                             for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            // Add the new button to the rating button array
            favouriteButton.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let viewCell = self.findSuperViewOfType(superView: UITableViewCell.self, view: button.superview!) as? NearbyUserTableViewCell else{
            fatalError("The view is not UITableViewCell")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
        
        UserController.shared.updateFavouriteUsers(userId: viewCell.user!.id, isSelectedUser: rating == 1)
        
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in favouriteButton.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
    
    func findSuperViewOfType<T>(superView: T.Type, view: UIView) -> UIView? {
    
        var xsuperView : UIView!  = view
        var foundSuperView : UIView!

        while (xsuperView != nil && foundSuperView == nil) {

            if xsuperView.self is T {
                foundSuperView = xsuperView
            } else {
                xsuperView = xsuperView.superview
            }
        }
        return foundSuperView
    }
}
