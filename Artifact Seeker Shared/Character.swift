//
//  Character.swift
//  GoK
//
//  Created by Floyd Resler on 5/21/21.
//

import GlideEngine
import SpriteKit
import GameplayKit

class CharacterEntity: GlideEntity {
    
    override func setup() {
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 64, height: 64))
        spriteNodeComponent.offset = .init(x: 0, y: 5)
        spriteNodeComponent.zPositionContainer = ArtifactSeekerZPositionContainer.player
        addComponent(spriteNodeComponent)
        
        let playerComponent = SimplePlayerComponent()
        addComponent(playerComponent)
        
        let kinematicsBodyComponent = KinematicsBodyComponent()
        addComponent(kinematicsBodyComponent)
        
        let colliderComponent = ColliderComponent(
            categoryMask: GlideCategoryMask.none,
            size: CGSize(width: 24, height: 48),
            offset: .zero,
            leftHitPointsOffsets: (10, 10),
            rightHitPointsOffsets: (10, 10),
            topHitPointsOffsets: (5, 5),
            bottomHitPointsOffsets: (5, 5)
        )
        addComponent(colliderComponent)
        
        let colliderTileHolderComponent = ColliderTileHolderComponent()
        addComponent(colliderTileHolderComponent)
        
        // Make character be able to move horizontally.
        var config = HorizontalMovementComponent.sharedConfiguration
        // Set character's fixed velocity to 30.0.
        config.fixedVelocity = 20.0
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .fixedVelocity, configuration: config)
        addComponent(horizontalMovementComponent)
        
        // Make character controllable via input handling.
        // `playerIndex` parameter is actually the mapping to input handling.
        let playableCharacterComponent = PlayableCharacterComponent(playerIndex: 0)
        addComponent(playableCharacterComponent)
        // Make the character jump.
        var jumpConfiguration = JumpComponent.sharedConfiguration
        // Set the character's jumping speed.
        jumpConfiguration.jumpingVelocity = 20.0
        let jumpComponent = JumpComponent(configuration: jumpConfiguration)
        addComponent(jumpComponent)



        setupTextureAnimations()
    }
    
    func setupTextureAnimations() {
        let timePerFrame: TimeInterval = 0.15
        let animationSize = CGSize(width: 64, height: 64)
        let animationOffset = CGPoint(x: 0, y: 0)
        
        // Idle animation
        let idleAction = TextureAnimation.Action(textureFormat: "idle%d",
                                                 numberOfFrames: 3,
                                                 timePerFrame: timePerFrame)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: animationOffset,
                                             size: animationSize,
                                             action: idleAction,
                                             loops: true)
        
        // Add an animator component to our character
        // with idle animation playing by default
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        
        
        // Walk animation
        let walkAction = TextureAnimation.Action(textureFormat: "walk%d",
                                                 numberOfFrames: 7,
                                                 timePerFrame: timePerFrame)
        let walkAnimation = TextureAnimation(triggerName: "Walk",
                                             offset: animationOffset,
                                             size: animationSize,
                                             action: walkAction,
                                             loops: true)
        animatorComponent.addAnimation(walkAnimation)
        
        // Jump animation
        let jumpAction = TextureAnimation.Action(textureFormat: "jump%d",
                                                 numberOfFrames: 5,
                                                 timePerFrame: timePerFrame)
        let jumpAnimation = TextureAnimation(triggerName: "Jump",
                                             offset: animationOffset,
                                             size: animationSize,
                                             action: jumpAction,
                                             loops: true)
        animatorComponent.addAnimation(jumpAnimation)
        addComponent(animatorComponent)
    }
}

class SimplePlayerComponent: GKComponent, GlideComponent {
    
    func didUpdate(deltaTime seconds: TimeInterval) {
        let textureAnimatorComponent = entity?.component(ofType: TextureAnimatorComponent.self)
        
        let collider = entity?.component(ofType: ColliderComponent.self)
        let jumpComponent = entity?.component(ofType: JumpComponent.self)
        let horizontalMovementComponent = entity?.component(ofType: HorizontalMovementComponent.self)
        
        if collider?.isOnAir == false &&
            horizontalMovementComponent?.movementDirection == .stationary &&
            jumpComponent?.jumps == false {
            textureAnimatorComponent?.enableAnimation(with: "Idle")
        }
        
        if collider?.isOnAir == false &&
            horizontalMovementComponent?.movementDirection != .stationary &&
            jumpComponent?.jumps == false {
            textureAnimatorComponent?.enableAnimation(with: "Walk")
        }
        
        if jumpComponent?.jumps == true {
            textureAnimatorComponent?.enableAnimation(with: "Jump")
        }
    }
}
