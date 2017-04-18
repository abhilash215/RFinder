//
//  CreateRecipeVC.swift
//  RFinder
//
//  Created by Saahith Reddy on 12/3/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import Foundation

import UIKit
import CoreData

var recipesCreated = [Recipe]()
class CreateRecipeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UITextFieldDelegate{
    
    @IBOutlet weak var recipeTitle: B68UIFloatLabelTextField!
    @IBOutlet weak var recipeIngredients: B68UIFloatLabelTextField!
    @IBOutlet weak var recipeSteps: B68UIFloatLabelTextField!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var addRecipeBtn: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        recipeImg.layer.cornerRadius = 4.0
        recipeImg.clipsToBounds = true
        self.title = "Create Recipe"
        recipeTitle.delegate = self
        recipeSteps.delegate = self
        recipeIngredients.delegate = self
        
        let bgColor = UIColor(red:0.15, green:0.14, blue:0.22, alpha:1.0)
        self.view.backgroundColor = bgColor
        
       
        recipeTitle.attributedPlaceholder = NSAttributedString(string:"Recipe Title",
                                                                  attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        recipeIngredients.attributedPlaceholder = NSAttributedString(string:"Recipe Ingredients",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        recipeSteps.attributedPlaceholder = NSAttributedString(string:"Recipe Ingredients",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        let btnColor = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1.0)
        recipeTitle.activeTextColorfloatingLabel = btnColor
        recipeTitle.textColor = btnColor
        recipeSteps.activeTextColorfloatingLabel = btnColor
        recipeSteps.textColor = btnColor
        recipeIngredients.textColor = btnColor
        recipeIngredients.activeTextColorfloatingLabel = btnColor
        recipeTitle.inactiveTextColorfloatingLabel = UIColor.whiteColor()
        recipeSteps.inactiveTextColorfloatingLabel = UIColor.whiteColor()
        recipeIngredients.inactiveTextColorfloatingLabel = UIColor.whiteColor()
        self.addRecipeBtn.backgroundColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:0.6)
        
        self.addRecipeBtn.layer.cornerRadius = 10
        self.addRecipeBtn.layer.borderWidth = 0.5
        self.addRecipeBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.addRecipeBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        recipeImg.image = image
    }
    
    @IBAction func addImage(sender: AnyObject!) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        recipeTitle.resignFirstResponder()
        recipeSteps.resignFirstResponder()
        recipeIngredients.resignFirstResponder()
    }
    
    @IBAction func createRecipe(sender: AnyObject!) {
        
        
        recipeTitle.resignFirstResponder()
        recipeSteps.resignFirstResponder()
        recipeIngredients.resignFirstResponder()
        
        if let title = recipeTitle.text where title != "" {
            if let ingredient = recipeIngredients.text where ingredient != ""{
                if let step = recipeSteps.text where step != ""{
                    
                    SweetAlert().showAlert("Are you sure?", subTitle: "You recipe will be added!", style: AlertStyle.warning, buttonTitle:"No", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                        if isOtherButton == true {
                            
                            SweetAlert().showAlert("Cancelled!", subTitle: "Your recipe is not added", style: AlertStyle.error)
                        }
                        else {
                            let recipe = Recipe.init(image: UIImagePNGRepresentation(self.recipeImg.image!)! as NSData, ingredients: self.recipeIngredients.text!, steps: self.recipeSteps.text!, title: title)
                            recipesCreated.append(recipe)
                            
                            SweetAlert().showAlert("Success!", subTitle: "Your recipe is added", style: AlertStyle.success)
                            
                        }
                    }
                    
            
                }else{
                    popUpError()
                }
            }else{
                popUpError()
            }
        }else{
           popUpError()
        }
      
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    func popUpError(){
        SweetAlert().showAlert("Error!", subTitle: "Please enter all details", style: AlertStyle.error)
    }
    
}

