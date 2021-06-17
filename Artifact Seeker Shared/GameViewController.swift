//
//  GameViewController.swift
//  Artifact Seeker
//
//  Created by Floyd Resler on 6/8/21.
//

import GlideEngine
import SpriteKit

enum ArtifactSeekerZPositionContainer: String, ZPositionContainer, CaseIterable {
    case background
    case player
}

class GameViewController: ViewControllerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let decorationTilesAtlas = SKTextureAtlas(named: "Blue")
        let colliderTilesAtlas = SKTextureAtlas(named: "Collider")
        
        SKTextureAtlas.preloadTextureAtlases([decorationTilesAtlas, colliderTilesAtlas]) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let loader = TiledMapEditorSceneLoader(
                    fileName: "Level 1",
                    bundle: Bundle.main,
                    collisionTilesTextureAtlas: colliderTilesAtlas,
                    decorationTilesTextureAtlas: decorationTilesAtlas
                )
                guard let sceneTileMaps = loader.tileMaps else {
                    fatalError("Couldn't load the level file")
                }

                // Create your scene
                let scene = BaseLevelScene(
                    tileMaps: sceneTileMaps
                )
                
                scene.scaleMode = .resizeFill
                (self.view as? SKView)?.ignoresSiblingOrder = true
                
                /// Add your decoration tile maps in appropriate z position container nodes.
                (self.view as? SKView)?.presentScene(scene)
            }
        }
    }
}


class BaseLevelScene: GlideScene {
    
    let tileMaps: SceneTileMaps
    
    init(tileMaps: SceneTileMaps) {
        self.tileMaps = tileMaps
        super.init(
            collisionTileMapNode: tileMaps.collisionTileMap,
            zPositionContainers: ArtifactSeekerZPositionContainer.allCases
        )
        
        shouldPauseWhenAppIsInBackground = false
    }
    
    override func setupScene() {
        super.setupScene()
        
        ColliderComponent.isDebugEnabled = true
        
        cameraEntity.component(ofType: CameraComponent.self)?.configuration.fieldOfViewWidth = 5000
        
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
        addEntity(characterEntity)
    }
}
