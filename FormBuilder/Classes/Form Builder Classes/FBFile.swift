//
//  FBFile.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 5/3/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public class FBFile: NSObject
{
    public var lines:Array<FBFileLine> = Array<FBFileLine>()
    
    public override init()
    {
        super.init()

    }
    
    public init(file:String)
    {
        super.init()
        self.load(file: file)
    }
    
    public func load(file: String)
    {
        let podBundle = Bundle.init(for: self.classForCoder)
        guard let path = podBundle.url(forResource: file, withExtension: "spec")
            else {
            return
        }
        do {
            let content:String = try String(contentsOf: path, encoding: String.Encoding.utf8)
            var textlines = content.split(separator: "\n")
            var continued:Bool = false
            while (textlines.count > 0)
            {
                let line:FBFileLine = FBFileLine.init(line: (textlines.first?.description)!, continued: continued)
                continued = line.continued
                lines.append(line)
                textlines.removeFirst()
            }
        } catch _ as NSError {
            return
        }
        
    }
}
