//
//  PokemonDetailModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation

struct PokemonDetailModel: Codable {
    let abilities: [AbilityInfo]?
    let base_experience: Int?
    let cries: Cries?
    let forms: [PokemonForm]?
    let game_indices: [GameIndex]?
    let height: Int?
    let held_items: [String]?
    let id: Int
    let is_default: Bool?
    let location_area_encounters: String?
    let moves: [Move]?
    let name: String?
    let order: Int?
    let past_abilities: [String]?
    let past_types: [String]?
    let species: Species?
    let sprites: Sprites?
    let stats: [Stat]?
    let types: [PokemonType]?
    let weight: Int?
}

struct AbilityInfo: Codable {
    let ability: Ability
    let is_hidden: Bool?
    let slot: Int?
}

struct Ability: Codable {
    let name: String?
    let url: String?
}

struct Cries: Codable {
    let latest: String?
    let legacy: String?
}

struct PokemonForm: Codable {
    let name: String?
    let url: String?
}

struct GameIndex: Codable {
    let game_index: Int?
    let version: Version?
}

struct Version: Codable {
    let name: String?
    let url: String?
}

struct Move: Codable {
    let move: MoveInfo
    let version_group_details: [VersionGroupDetail]?
}

struct MoveInfo: Codable {
    let name: String?
    let url: String?
}

struct VersionGroupDetail: Codable {
    let level_learned_at: Int?
    let move_learn_method: MoveLearnMethod?
    let version_group: VersionGroup?
}

struct MoveLearnMethod: Codable {
    let name: String?
    let url: String?
}

struct VersionGroup: Codable {
    let name: String?
    let url: String?
}

struct Species: Codable {
    let name: String?
    let url: String?
}

struct Sprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
    let other: OtherSprites?
    let versions: GenerationSprites?
}

struct OtherSprites: Codable {
    let dream_world: DreamWorldSprites?
    let home: HomeSprites?
    let official_artwork: OfficialArtworkSprites?
    let showdown: ShowdownSprites?
}

struct DreamWorldSprites: Codable {
    let front_default: String?
    let front_female: String?
}

struct HomeSprites: Codable {
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct OfficialArtworkSprites: Codable {
    let front_default: String?
    let front_shiny: String?
}

struct ShowdownSprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct GenerationSprites: Codable {
    let generation_i: GenerationISprites?
    let generation_ii: GenerationIISprites?
    let generation_iii: GenerationIIISprites?
    let generation_iv: GenerationIVSprites?
    let generation_v: GenerationVSprites?
    let generation_vi: GenerationVISprites?
    let generation_vii: GenerationVIISprites?
    let generation_viii: GenerationVIIISprites?
}

struct GenerationISprites: Codable {
    let red_blue: RedBlueSprites?
    let yellow: YellowSprites?
}

struct RedBlueSprites: Codable {
    let back_default: String?
    let back_gray: String?
    let back_transparent: String?
    let front_default: String?
    let front_gray: String?
    let front_transparent: String?
}

struct YellowSprites: Codable {
    let back_default: String?
    let back_gray: String?
    let back_transparent: String?
    let front_default: String?
    let front_gray: String?
    let front_transparent: String?
}

struct GenerationIISprites: Codable {
    let crystal: CrystalSprites?
    let gold: GoldSprites?
    let silver: SilverSprites?
}

struct CrystalSprites: Codable {
    let back_default: String?
    let back_shiny: String?
    let back_shiny_transparent: String?
    let back_transparent: String?
    let front_default: String?
    let front_shiny: String?
    let front_shiny_transparent: String?
    let front_transparent: String?
}

struct GoldSprites: Codable {
    let back_default: String?
    let back_shiny: String?
    let front_default: String?
    let front_shiny: String?
    let front_transparent: String?
}

struct SilverSprites: Codable {
    let back_default: String?
    let back_shiny: String?
    let front_default: String?
    let front_shiny: String?
    let front_transparent: String?
}

struct GenerationIIISprites: Codable {
    let emerald: EmeraldSprites?
    let firered_leafgreen: FireRedLeafGreenSprites?
    let ruby_sapphire: RubySapphireSprites?
}

struct EmeraldSprites: Codable {
    let front_default: String?
    let front_shiny: String?
}

struct FireRedLeafGreenSprites: Codable {
    let back_default: String?
    let back_shiny: String?
    let front_default: String?
    let front_shiny: String?
}

struct RubySapphireSprites: Codable {
    let back_default: String?
    let back_shiny: String?
    let front_default: String?
    let front_shiny: String?
}

struct GenerationIVSprites: Codable {
    let diamond_pearl: DiamondPearlSprites?
    let heartgold_soulsilver: HeartGoldSoulSilverSprites?
    let platinum: PlatinumSprites?
}

struct DiamondPearlSprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct HeartGoldSoulSilverSprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct PlatinumSprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct GenerationVSprites: Codable {
    let black_white: BlackWhiteSprites?
}

struct BlackWhiteSprites: Codable {
    let animated: AnimatedSprites?
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct AnimatedSprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct GenerationVISprites: Codable {
    let omegaruby_alphasapphire: OmegaRubyAlphaSapphireSprites?
    let x_y: XYGenerationSprites?
}

struct OmegaRubyAlphaSapphireSprites: Codable {
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct XYGenerationSprites: Codable {
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct GenerationVIISprites: Codable {
    let icons: IconsSprites?
    let ultra_sun_ultra_moon: UltraSunUltraMoonSprites?
}

struct IconsSprites: Codable {
    let front_default: String?
    let front_female: String?
}

struct UltraSunUltraMoonSprites: Codable {
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

struct GenerationVIIISprites: Codable {
    let icons: IconsSprites?
}

struct Stat: Codable {
    let base_stat: Int?
    let effort: Int?
    let stat: StatInfo?
}

struct StatInfo: Codable {
    let name: String?
    let url: String?
}

struct PokemonType: Codable {
    let slot: Int?
    let type: TypeInfo?
}

struct TypeInfo: Codable {
    let name: String?
    let url: String?
}



