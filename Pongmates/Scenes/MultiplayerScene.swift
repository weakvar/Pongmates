//
//  MultiplayerScene.swift
//  Pongmates
//
//  Created by Vladislav Kulikov on 15.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class MultiplayerScene: SKScene {
    
    private var playerA: Player!
    private var playerAScoreLabel: Label!
    private var playerB: Player!
    private var playerBScoreLabel: Label!
    private var ball: Ball!
    
    private var playerAScore = 0
    private var playerBScore = 0
    
    private var entities = Set<GKEntity>()
    
}

// MARK: - Scene Events

extension MultiplayerScene {
    
    override func didMove(to view: SKView) {
        // Настраиваем параметры сцены игры
        addPhysicsEdges()
        
        // Размещаем элементы игры
        configurePlayerA()
        configurePlayerAScoreLabel()
        configurePlayerB()
        configurePlayerBScoreLabel()
        configureBall()
        
        // Запускаем мяч
        ball.applyImpulse()
    }
    
}

// MARK: - Scene Configuration

extension MultiplayerScene {
    
    private func addPhysicsEdges() {
        let physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody.friction = 0
        physicsBody.restitution = 1
        
        self.physicsBody = physicsBody
    }
    
}

// MARK: - Gameplay Methods

extension MultiplayerScene {
    
    private func configurePlayerA() {
        let size = CGSize(width: 80, height: 16)
        let color = SKColor(red: 0.91, green: 0.12, blue: 0.39, alpha: 1.00)
        
        playerA = Player(size: size, color: color)
        
        if let node = playerA.component(ofType: NodeComponent.self)?.node {
            node.position = CGPoint(x: frame.midX, y: frame.minY + 104)
            node.zPosition = 1
        }
        
        addEntity(playerA)
    }
    
    private func configurePlayerAScoreLabel() {
        playerAScoreLabel = Label(fontName: "SFProDisplay-Ultralight", fontSize: 80)
        
        if let node = playerAScoreLabel.component(ofType: NodeComponent.self)?.node {
            node.position = CGPoint(x: frame.midX, y: frame.midY - 48)
            node.zPosition = 0
            
            if let labelNode = playerAScoreLabel.component(ofType: LabelComponent.self)?.node {
                labelNode.text = String(playerAScore)
                labelNode.fontColor = SKColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.25)
            }
        }
        
        addEntity(playerAScoreLabel)
    }
    
    private func configurePlayerB() {
        let size = CGSize(width: 160, height: 16)
        let color = SKColor(red: 0.49, green: 0.30, blue: 1.00, alpha: 1.00)
        
        playerB = Player(size: size, color: color)
        
        if let node = playerB.component(ofType: NodeComponent.self)?.node {
            node.position = CGPoint(x: frame.midX, y: frame.maxY - 104)
            node.zPosition = 1
        }
        
        addEntity(playerB)
    }
    
    private func configurePlayerBScoreLabel() {
        playerBScoreLabel = Label(fontName: "SFProDisplay-Ultralight", fontSize: 80)
        
        if let node = playerBScoreLabel.component(ofType: NodeComponent.self)?.node {
            node.position = CGPoint(x: frame.midX, y: frame.midY + 48)
            node.zRotation = .pi
            node.zPosition = 0
            
            if let labelNode = playerBScoreLabel.component(ofType: LabelComponent.self)?.node {
                labelNode.text = String(playerBScore)
                labelNode.fontColor = SKColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.25)
            }
        }
        
        addEntity(playerBScoreLabel)
    }
    
    private func configureBall() {
        ball = Ball()
        
        if let node = ball.component(ofType: NodeComponent.self)?.node {
            node.position = CGPoint(x: frame.midX, y: frame.midY)
            node.zPosition = 1
        }
        
        addEntity(ball)
    }
    
}

// MARK: - Entity Methods

extension MultiplayerScene {
    
    private func addEntity(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let node = entity.component(ofType: NodeComponent.self)?.node {
            addChild(node)
        }
    }
    
    private func removeEntity(_ entity: GKEntity) {
        if let node = entity.component(ofType: NodeComponent.self)?.node {
            node.removeFromParent()
        }
        
        entities.remove(entity)
    }
    
}

// MARK: - Touch Events

extension MultiplayerScene {
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if location.y < 0 {
                playerA.move(to: location.x, withDuration: 0.05)
            } else {
                playerB.move(to: location.x, withDuration: 0.25)
            }
        }
    }
    
}
