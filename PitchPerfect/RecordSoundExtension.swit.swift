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
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error during last operation", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Oops!", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}