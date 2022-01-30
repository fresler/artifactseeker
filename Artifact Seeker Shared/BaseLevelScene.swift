//
//  BaseLevelScene.swift
//  Artifact Seeker
//
//

import GlideEngine

enum ArtifactSeekerZPositionContainer: String, ZPositionContainer, CaseIterable {
    case background
    case player
}

class BaseLevelScene: GlideScene {
    
    let tileMaps: SceneTileMaps
    
    init(tileMaps: SceneTileMaps) {
        self.tileMaps = tileMaps
        super.init(
            collisionTileMapNode: tileMaps.collisionTileMap,
            zPositionContainers: ArtifactSeekerZPositionContainer.allCases
        )
        
        // Remove comment to be able to debug collision tile map from the level file.
        // isDebuggingCollisionTileMapNode = true
        shouldPauseWhenAppIsInBackground = false
    }
    
    override func setupScene() {
        super.setupScene()
        
        ColliderComponent.isDebugEnabled = true
        
        cameraEntity.component(ofType: CameraComponent.self)?.configuration.fieldOfViewWidth = 8000
        
        let groundBackground = tileMaps.decorationTileMaps[0]
        groundBackground.position = collisionTileMapNode?.position ?? .zero
        addChild(
            groundBackground,
            in: ArtifactSeekerZPositionContainer.background
        )
        
        let characterEntity = CharacterEntity(
            initialNodePosition:
                TiledPoint(8, 7).point(with: .init(width: 16, height: 16))
        )
        addEntity(characterEntity, in: ArtifactSeekerZPositionContainer.player)
    }
}
