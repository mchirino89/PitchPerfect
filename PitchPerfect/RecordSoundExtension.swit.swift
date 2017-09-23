//
//  RecordSoundExtension.swit.swift
//  PitchPerfect
//
//  Created by Mauricio Chirino on 10/10/16.
//  Copyright © 2016 Mauricio Chirino. All rights reserved.
//

import Foundation
import UIKit

extension RecordSoundsController {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error during last operation", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oops!", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
