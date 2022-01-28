//
//  Scene.swift
//  Artifact Seeker
//
//  Created by Floyd Resler on 6/8/21.
//

import GlideEngine
import SpriteKit

class Scene:GlideScene {
    let tileMaps: SceneTileMaps
    
    init(tileMaps: SceneTileMaps) {
        self.tileMaps = tileMaps
        super.init(
            collisionTileMapNode: tileMaps.collisionTileMap,
            zPositionContainers: []
        )
        shouldPauseWhenAppIsInBackground = false
        // Remove comment for debugging collision tile map node.
        //isDebuggingCollisionTileMapNode = true
    }
    
    override func setupScene() {
        
        cameraEntity.component(ofType: CameraComponent.self)?.configuration.fieldOfViewWidth = 5000
        
        let groundBackground = tileMaps.decorationTileMaps[0]
        groundBackground.position = collisionTileMapNode?.position ?? .zero
        addChild(groundBackground)
        let characterEntity = CharacterEntity(initialNodePosition: CGPoint(x: 200, y: 80))
        addEntity(characterEntity)
    }
    
}
