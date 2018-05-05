//
//  GameScene.swift
//  Little Coral
//
//  Created by YOUWEI WANG on 2018/5/1.
//  Copyright © 2018 YOUWEI WANG. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreData

class GameScene: SKScene {
    
    private var coral : SKSpriteNode!
    private var score = 0
    private var level = 0
    private var scoreLabel : SKLabelNode!
    private var levelLabel : SKLabelNode!
    private var finishedLabel: SKLabelNode!
    private let scoreSet = [10, 20, 30, 40, 50]
    private var max = false
    
    override func didMove(to view: SKView) {
        // Set background image
        let bg = SKSpriteNode(imageNamed: "background.jpg")
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        bg.size = CGSize(width: size.width, height: size.height)
        
        // Set coral
        self.coral = SKSpriteNode(imageNamed: "1.png")
        self.coral.position = CGPoint(x: size.width/2, y:110)
        self.coral.size = CGSize(width:size.width/2, height:size.width/2)
        
        // Set cloud
        let cloud = SKSpriteNode(imageNamed: "cloud.png")
        cloud.position = CGPoint(x:size.width/4, y:size.height - 75)
        cloud.size = CGSize(width:size.width/3, height:size.height/6)
        
        let cloud2 = cloud.copy() as! SKSpriteNode
        cloud2.position = CGPoint(x:size.width/4*3, y:size.height - 75)
        
        // Set score label
        self.scoreLabel = SKLabelNode(text: String(self.score))
        self.scoreLabel.position = CGPoint(x: size.width / 4,
                                 y: size.height - 100)
        self.scoreLabel.fontColor = SKColor.black
        
        // Set level score label
        self.levelLabel = SKLabelNode(text: String(self.scoreSet[self.level]))
        self.levelLabel.position = CGPoint(x: size.width / 4 * 3,
                                           y: size.height - 100)
        self.levelLabel.fontColor = SKColor.black
        
        // Init finished label
        self.finishedLabel = SKLabelNode(text: "Max Level")
        self.finishedLabel.fontSize = 65
        self.finishedLabel.fontColor = SKColor.black
        self.finishedLabel.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        
        // Add nodes to scene
        addChild(bg)
        addChild(self.coral)
        addChild(cloud)
        addChild(cloud2)
        addChild(self.scoreLabel)
        addChild(self.levelLabel)
    }
    
    func update() {
        if let i = self.scoreSet.index(of: score) {
            self.level = i + 1
        }
        
        let levelMax = self.level >= self.scoreSet.count
        
        if !levelMax {
            self.updateLevel(level: self.level)
        }
        
        if levelMax && score == self.scoreSet[self.level - 1] {
            self.max = true
            self.finished()
        }
        
        self.updateScore(score: self.score)
    }
    
    func updateScore(score : Int) {
        self.scoreLabel.text = String(String(score))
    }
    
    func finished() {
        self.addChild(self.finishedLabel)
    }
    
    func updateLevel(level: Int) {
        self.levelLabel.text = String(self.scoreSet[self.level])
        self.coral.texture = SKTexture(imageNamed: String(level+1) + ".png")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if !self.max {
                self.score += 1
                
                self.update()
            } else {
                let location = t.location(in: self)
                
                if self.finishedLabel.contains(location) {
                    self.level = 0
                    self.score = 0
                    self.max = false
                    self.update()
                    self.finishedLabel.removeFromParent()
                }
            }
        }
    }
}
