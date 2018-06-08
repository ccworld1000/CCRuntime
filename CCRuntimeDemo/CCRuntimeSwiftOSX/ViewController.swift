//
//  ViewController.swift
//  CCRuntimeSwiftOSX
//
//  Created by dengyouhua on 2018/6/8.
//  Copyright © 2018 cc | ccworld1000@gmail.com. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CCRuntimeTest.classQuerying()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

