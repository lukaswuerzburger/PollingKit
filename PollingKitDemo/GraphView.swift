//
//  GraphView.swift
//  PollingKitDemo
//
//  Created by Lukas Würzburger on 8/15/20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import UIKit

class GraphView: UIView {

    var points: [Float] = [] {
        didSet { setNeedsDisplay() }
    }

    var max: Int = 1 {
        didSet { setNeedsDisplay() }
    }

    var pointWidth: CGFloat = 5 {
        didSet { setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        let path = UIBezierPath()
        path.lineWidth = 1
        let numberOfPoints = points.count
        let graphWidth: CGFloat = CGFloat(numberOfPoints) * pointWidth
        let verticalBottom = rect.maxY - 10
        let pointHeight: CGFloat = (rect.height - 20) / CGFloat(max)
        let startX = rect.maxX - graphWidth
        points.enumerated().forEach({ index, point in
            let coordinate = CGPoint(
                x: startX + (CGFloat(index) * pointWidth),
                y: verticalBottom - (CGFloat(point) * pointHeight)
            )
            if index == 0 {
                path.move(to: coordinate)
            } else {
                path.addLine(to: coordinate)
            }
        })
        path.stroke()
    }
}
