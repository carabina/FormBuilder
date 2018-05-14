//
//  OptionSetField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class OptionSetField: InputField
{
    private var _optionSet:FBOptionSet?
    override var optionSet:FBOptionSet?
        {
        get
        {
            return _optionSet
        }
        set(newValue)
        {
            _optionSet = newValue
        }
    }
    
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        let file = self.line!.section!.form!.file!
        var i:Int = lines.0
        
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
            case FBKeyWord.Value:
                self.data = Int(file.lines[i].value.description)
                i += 1
                
                break
            case FBKeyWord.OptionSet:
                if (file.lines[i].value != "")
                {
                    self.optionSet = FBSettings.sharedInstance.optionSet[file.lines[i].value]
                    self.optionSet?.field = self
                }
                else
                {
                    let indentLevel:Int = file.lines[i].indentLevel
                    let spaceLevel:Int = file.lines[i].spaceLevel
                    i += 1
                    var optionRange = (i, i)
                    while (i <= lines.1)
                    {
                        if ((file.lines[i].indentLevel > indentLevel) ||
                            (file.lines[i].spaceLevel > spaceLevel))
                        {
                            i += 1
                        }
                        else
                        {
                            break
                        }
                    }
                    optionRange.1 = i - 1
                    self.optionSet = FBOptionSet(field: self, file: file, lines: optionRange)
                }
                i += 1
                
                break
            default:
                i += 1
                
                break
            }
        }
    }

    var viewName:String
    {
        get
        {
            return self.style!.viewFor(type: self.fieldType)
        }
    }
    
    override var labelHeight:CGFloat
    {
        get
        {
            return self.caption!.height(withConstrainedWidth:
                self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth),
                                        font: self.style!.font)
        }
    }

}
