//
//  UsefulFunctions.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 11/13/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit

class UsefulFunctions
{
    
    
    
    static func fitFontToSize(size:CGSize, fontName:String, text:String, var minFontSize:CGFloat, var maxFontSize:CGFloat) -> CGFloat
    {
        let label = UILabel(frame: CGRectMake(0, 0, size.width, size.height))
        label.text = text
        
        while maxFontSize - minFontSize > 0.1
        {
            let average = (maxFontSize + minFontSize)/2
            
            label.font = UIFont(name: fontName, size: average)
            label.sizeToFit()
            
            if label.frame.height <= size.height && label.frame.width <= size.width
            {
                minFontSize = average
            }
            else
            {
                maxFontSize = average
            }
        }
        
        return minFontSize
    }
    
    /**
     Permutes the objects inside the array
     - parameter vet: The array to be permuted (Must have exactly 2 elements)
     - parameter checkValue: when checkValue is 0 no permutations are made
     */
    static private func permuteTwo( inout vet:[Int], inout checkValue:UInt64)
    {
        if vet.count != 2
        {
            print("vet does not have 2 elements!!!")
            return
        }
        
        let auxilary = vet[0]
        
        vet[0] = vet[1]
        vet[1] = auxilary
        
        checkValue--
        return
    }
    
    /**
     Permutes an object lexicographically (if in proper order)
     
     - parameter vet: The array to be permuted
     - parameter checkValue: How many permutations are to be made
     
     */
    static private func lex(inout vet:[Int], inout checkValue:UInt64)
    {
        if vet.count == 2
        {
            permuteTwo(&vet, checkValue: &checkValue)
            return
        }
        
        var j:Int = vet.count - 1
        for i in 0..<(vet.count-1)
        {
            var slice = Array(vet[1...(vet.count-1)])
            
            lex(&slice, checkValue: &checkValue )
            
            if checkValue == 0
            {
                return
            }
            
            
            let auxiliary = vet[0]
            vet[0] = vet[j]
            vet[j] = auxiliary
            j--
            
            
            if i < vet.count - 1
            {
                vet[1...(vet.count-1)].sortInPlace()
            }
            
            checkValue--
            
            if checkValue == 0
            {
                return
            }
        }
        
        var slice = Array(vet[1...(vet.count-1)])
        lex(&slice, checkValue: &checkValue)
        
    }
    
    
    /**
     Returns a sequence of CGPoints that makes the view move randomly around it's center point. Try not to put a high value in number of Steps, it makes it quite slow.
     
     - Parameters:
     - withNumberOfSteps: Number of steps taken in each path
     - withNumberOfPaths: How many paths to and fro the origin.
     - range: Range of steps, must be a positive value
     
     - Returns:
     - A sequence of points for view to go up/down left/right and perform randomWalk movement around it's center point
     */
    static func randomWalk(withNumberOfSteps numberOfSteps:Int, withNumberOfPaths numberOfPaths:Int, xRange: Int, yRange:Int) -> [CGPoint]
    {
        // returns empty in case of invalid range
        if xRange <= 0 || yRange <= 0
        {
            return []
        }
        
        /// Important Variables
        // sequence of Actions to be returned
        var sequenceOfActions:[CGPoint] = []
        
        // number of paths (always twice the numberOfPaths, one to go from point A to B, another to go from B to A)
        var paths:[[Int]] = []
        
        // memory of movement along the way to be referenced later on
        var memory:[CGPoint] = []
        
        
        /// Algorithm Starts
        
        // randomly gets points p and q from interval: [-range, range]
        // to move object up/down by p and left/right by q units
        srandom(UInt32(time(nil)))
        for _ in 0..<numberOfSteps
        {
            let p = CGFloat(random()%(2*xRange) - xRange )
            let q = CGFloat(random()%(2*yRange) - yRange )
            
            let newPoint:CGPoint = CGPoint(x: p, y: q)
            
            //saves point in memory
            memory.append(newPoint)
            
            sequenceOfActions.append(newPoint)
        }
        
        
        /// re-orders memory 2 x numberOfPaths - 1 times to create new paths from it. (the first path has already been decided at this point)
        var vet = [Int]()
        vet += 0..<memory.count
        
        // sets upper limit on number of permutations
        var check:UInt64 = 1
        for index in vet
        {
            check = check*(UInt64(index)+1)
        }
        
        for _ in 0..<(2*numberOfPaths-1)
        {
            var stop:UInt64 = 0
            
            // gets a random number between 0 and stop
            arc4random_buf(&stop, sizeofValue(check))
            stop = stop%check
//            print(stop)
            
            var vetAuxiliar:[Int] = vet
            
            //permutes vetAuxiliar stop number of times
            if stop != 0
            {
                lex(&vetAuxiliar, checkValue: &stop)
            }
            
            paths.append(vetAuxiliar)
        }
        
        // adds paths to sequenceOfAction, a -1 in case its coming back to origin, and 1 in case its going away
        var movingAwayFromOrigin:CGFloat = -1
        for path in paths
        {
            for step in path
            {
                let newPoint = CGPoint(x: movingAwayFromOrigin * memory[step].x, y: movingAwayFromOrigin * memory[step].y)
                sequenceOfActions.append(newPoint)
            }
            movingAwayFromOrigin = -1 * movingAwayFromOrigin
        }
        
        return sequenceOfActions
    }
    
}





