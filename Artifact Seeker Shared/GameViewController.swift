//
//  GameViewController.swift
//  Artifact Seeker
//
//  Created by Floyd Resler on 6/8/21.
//

import GlideEngine
import SpriteKit

class GameViewController: ViewControllerType {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let scene = Scene(collisionTileMapNode: nil, zPositionContainers: [])
        let decorationAtlas = SKTextureAtlas(named: "Decorations")
        let loader = TiledMapEditorSceneLoader(
            fileName: "Level 1",
            bundle: Bundle.main,
            collisionTilesTextureAtlas: nil,
            decorationTilesTextureAtlas: decorationAtlas
        )
        guard let sceneTileMaps = loader.tileMaps else {
            fatalError("Couldn't load the level file")
        }

        // Create your scene
        let scene = Scene(
            tileMaps: sceneTileMaps
        )
        
        scene.scaleMode = .resizeFill
        
        /// Add your decoration tile maps in appropriate z position container nodes.
        (view as? SKView)?.presentScene(scene)
    }
}


