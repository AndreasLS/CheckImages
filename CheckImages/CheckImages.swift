//
//  CheckImages.swift
//  CheckImages
//
//  Created by Andre Salla on 08/03/17.
//  Copyright © 2017 Andre Salla. All rights reserved.
//

import Foundation

class CheckImages {
    
    func check(filePathEnum: String, filePathAssets: String, filePath: String) {
        guard let file = FileHandle.init(forReadingAtPath: filePathEnum) else {
            exit(EXIT_FAILURE)
        }
        let data = file.readDataToEndOfFile()
        guard let fileText = String.init(data: data, encoding: .utf8) else {
            exit(EXIT_FAILURE)
        }
        
        file.closeFile()
        
        let components = fileText.components(separatedBy: CharacterSet.newlines)
        
        var valuesUsed = matches(components)
        valuesUsed.append(contentsOf: interface(filePath))
        let valuesAssets = assets(filePathAssets)
        
        printResult(onlyEnum: valuesUsed.filter{!valuesAssets.contains($0)}
            , onlyAssets: valuesAssets.filter{!valuesUsed.contains($0)})
        
    }
    
    private func matches(_ strings: [String]) -> [String] {
        var array: [String] = []
        for value in strings {
            if value.lowercased().contains("case") {
                do {
                    let regular = try NSRegularExpression.init(pattern: "\"(.*?)\"", options: .caseInsensitive)
                    let matches = regular.matches(in: value, options: .withTransparentBounds, range: NSRange.init(location: 0, length: value.characters.count))
                    let values = matches.map{(value as NSString).substring(with: $0.range)}.map{$0.replacingOccurrences(of: "\"", with: "")}.filter{$0 != ""}
                    array.append(contentsOf:values)
                    
                } catch {
                    exit(EXIT_FAILURE)
                }
                
            }
        }
        return array
    }
    
    private func interface(_ location: String) -> [String] {
        var arrayImages : [String] = []
        do {
            let contents =  try FileManager.default.contentsOfDirectory(atPath: location)
            for names in contents {
                let components = names.components(separatedBy: ".")
                if components.count >= 2 && (components[1].lowercased() == "xib" || components[1].lowercased() == "storyboard") {
                    arrayImages.append(contentsOf:readInterface(path:location, name: names))
                }
            }
        } catch {
            exit(EXIT_FAILURE)
        }
        return arrayImages
    }
    
    private func readInterface(path: String, name: String) -> [String] {
        guard let file = FileHandle.init(forReadingAtPath: path + "/" + name) else {
            exit(EXIT_FAILURE)
        }
        let data = file.readDataToEndOfFile()
        guard let fileText = String.init(data: data, encoding: .utf8) else {
            exit(EXIT_FAILURE)
        }
        
        file.closeFile()
        
        let components = fileText.components(separatedBy: CharacterSet.newlines)
        
        var array: [String] = []
        
        for linha in components {
            
            do {
                let regular = try NSRegularExpression.init(pattern: " image=\"(.*?)\"", options: .caseInsensitive)
                let matches = regular.matches(in: linha, options: .withTransparentBounds, range: NSRange.init(location: 0, length: linha.characters.count))
                let values = matches.map{(linha as NSString).substring(with: $0.range)}.filter{$0 != ""}.map{$0.replacingOccurrences(of: "\"", with: "")}.map{$0.replacingOccurrences(of: " image=", with: "")}
                array.append(contentsOf:values)
            } catch {
                exit(EXIT_FAILURE)
            }
            
        }
        
        return array
        
    }
    
    private func assets(_ location: String) -> [String] {
        var arrayImages : [String] = []
        do {
            let contents =  try FileManager.default.contentsOfDirectory(atPath: location)
            for names in contents {
                let components = names.components(separatedBy: ".")
                if components.count >= 2 && components[1].lowercased() == "imageset" {
                    arrayImages.append(components[0])
                }
            }
        } catch {
            exit(EXIT_FAILURE)
        }
        return arrayImages
    }
    
    private func printResult(onlyEnum: [String], onlyAssets: [String]) {
        print("###########################################################")
        print("#                    ASSETS VALIDATE                      #")
        print("###########################################################")
        if onlyEnum.count > 0 {
            print("#                                                         #")
            print("# SOMENTE NOS ARQUIVOS (FALTA ADD NO ASSETS)              #")
            print("# ** NÃO CONSEGUE NÉ MOISES **                            #")
            print("#                                                         #")
            for value in onlyEnum {
                print("# " + value + fillSpace(alreadyIncluded: value.characters.count) + " #")
            }
            print("#                                                         #")
            print("###########################################################")
        }
        if onlyAssets.count > 0 {
            print("#                                                         #")
            print("# SOMENTE NO ASSETS (REMOVER DO ENUM)                     #")
            print("# ** NÃO TEM PROBLEMA **                                  #")
            print("#                                                         #")
            for value in onlyAssets {
                print("# " + value + fillSpace(alreadyIncluded: value.characters.count) + " #")
            }
            print("#                                                         #")
            print("###########################################################")
        }
        if onlyEnum.count == 0 && onlyAssets.count == 0 {
            print("#                                                         #")
            print("# VALIDATION OK                                           #")
            print("# ** TOMA AQUI 50 REAIS **                                #")
            print("#                                                         #")
            print("###########################################################")
        } else {
            exit(EXIT_FAILURE)
        }
    }
    
    private func fillSpace(alreadyIncluded: Int) -> String{
        if alreadyIncluded > 54 {
            return ""
        }
        var value : [Character] = []
        for _ in 0...54 - alreadyIncluded {
            value.append(" ")
        }
        return String(value)
    }

    private func cutString(string: String) -> String {
        if string.characters.count <= 54 {
            return string
        } else {
            return string.substring(to: string.index(string.startIndex, offsetBy: 54))
        }
    }
}
