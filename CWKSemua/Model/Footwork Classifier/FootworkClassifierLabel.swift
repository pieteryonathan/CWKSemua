//
//  FootworkClassifier.swift
//  CWKSemua
//
//  Created by Leo nardo on 11/06/21.
//

import CoreML

extension FootworkClassifier {
    /// Creates a shared Exercise Classifier instance for the app at launch.
    static let shared: FootworkClassifier = {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        // Create an Exercise Classifier instance.
        guard let footworkClassifier = try? FootworkClassifier(configuration: defaultConfig) else {
            // The app requires the action classifier to function.
            fatalError("Footwork Classifier failed to initialize.")
        }

        // Ensure the Exercise Classifier.Label cases match the model's classes.
        footworkClassifier.checkLabels()

        return footworkClassifier
    }()
}

extension FootworkClassifier {
    /// Label Model
    enum Label: String, CaseIterable {
        case lunge_front_right = "lunge-front-right"
        case lunge_front_left = "lunge-front-left"
        case lunge_right = "lunge-right"
        case lunge_left = "lunge-left"
        case others = "others"

        init(_ string: String) {
            guard let label = Label(rawValue: string) else {
                let typeName = String(reflecting: Label.self)
                fatalError("Add `\(string)` to `\(typeName)` type.")
            }

            self = label
        }
    }
}

extension FootworkClassifier {
    
    func checkLabels() {
        let metadata = model.modelDescription.metadata
        guard let classLabels = model.modelDescription.classLabels else {
            fatalError("The model doesn't appear to be a classifier.")
        }

        print("Checking the class labels in `\(Self.self)` model:")

        if let author = metadata[.author] {
            print("\tAuthor: \(author)")
        }

        if let description = metadata[.description] {
            print("\tDescription: \(description)")
        }

        if let version = metadata[.versionString] {
            print("\tVersion: \(version)")
        }

        if let license = metadata[.license] {
            print("\tLicense: \(license)")
        }

        
        //print labels
        print("Labels:")
        for (number, modelLabel) in classLabels.enumerated() {
            guard let modelLabelString = modelLabel as? String else {
                print("The label `\(modelLabel)` is not a string.")
                fatalError("Action classifier labels should be strings.")
            }

            let label = Label(modelLabelString)
            print("  \(number): \(label.rawValue)")
        }

        if Label.allCases.count != classLabels.count {
            let difference = Label.allCases.count - classLabels.count
            print("Warning: \(Label.self) contains \(difference) extra class labels.")
        }
    }
}
