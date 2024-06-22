//
//  DownloadImageViewModel.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/21.
//

import Foundation
import UIKit

class DownloadImageViewModel: NSObject {
    func downloadImage(iv: UIImageView, urlStr: String) {
        let params = FileParams_file(url: urlStr)
        let loader = GenericSingleDataLoader(dataLoader: ImageLoader())
        loader.loadData(params: params, completion: { [weak self] result in
//            guard let self = self else { return }
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    iv.image = image
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    iv.image = nil
                }
            }
        })
    }
}
