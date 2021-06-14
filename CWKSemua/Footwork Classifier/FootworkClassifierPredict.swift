//
//  FootworkClassifierPredict.swift
//  CWKSemua
//
//  Created by Leo nardo on 11/06/21.
//

import CoreML

extension FootworkClassifier {
    func predictActionFromWindow(_ window: MLMultiArray) -> ActionPrediction {
        do {
            let output = try prediction(poses: window)
            let action = Label(output.label)
            let confidence = output.labelProbabilities[output.label]!
            
            return ActionPrediction(label: action.rawValue, confidence: confidence)
        } catch {
            fatalError("Prediction error: \(error)")
        }
    }
}

extension FootworkClassifier {
    
    func calculatePredictionWindowSize() -> Int {
        let modelDescription = model.modelDescription
        
        let modelInputs = modelDescription.inputDescriptionsByName
        assert(modelInputs.count == 1, "The model should have exactly 1 input")
        
        guard let  input = modelInputs.first?.value else {
            fatalError("The model must have at least 1 input.")
        }
        guard input.type == .multiArray else {
            fatalError("The model's input must be an `MLMultiArray`.")
        }
        guard let multiArrayConstraint = input.multiArrayConstraint else {
            fatalError("The multiarray input must have a constraint.")
        }
        let dimensions = multiArrayConstraint.shape
        guard dimensions.count == 3 else {
            fatalError("The model's input multiarray must be 3 dimensions.")
        }
        
        let windowSize = Int(truncating: dimensions.first!)
        
        //Number of samples you must merge together
        return windowSize
    }
}
