//
//  RecipeViewController.swift
//  RFinder
//
//  Created by Abhilash uday on 12/3/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import Foundation

import UIKit
import KYWheelTabController

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var recipes = [Recipe]()
    var window: UIWindow?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipe"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        let bgColor = UIColor(red:0.15, green:0.14, blue:0.22, alpha:1.0)
        self.tableView.backgroundColor = bgColor
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        fetchAndSetResults()
         //roundButton.animate(start: true)
       self.view.makeToast("You can see recipes.",duration: 2.0, position: .center)
        self.tableView.reloadData()
    }
    func fetchAndSetResults() {
       recipes = recipesCreated
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell") as? RecipeCell {
            
            let recipe = recipes[indexPath.row]
            cell.recipeImg.image = UIImage(data: recipe.image, scale: 1.0)!
            
            cell.recipeTitle.text = recipe.title
            cell.recipeTitle.textColor = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1.0)
            return cell
        } else {
            return RecipeCell()
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
            CellAnimator.animateCell(cell, withTransform: CellAnimator.TransformHelix, andDuration: 1)
            cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
            UIView.animateWithDuration(0.3, animations: {
                cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
                },completion: { finished in
                    UIView.animateWithDuration(0.8, animations: {
                        cell.layer.transform = CATransform3DMakeScale(1,1,1)
                    })
            })
            
            cell.layer.borderWidth = 0.75
            cell.layer.borderColor = UIColor.whiteColor().CGColor
     }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    
}


