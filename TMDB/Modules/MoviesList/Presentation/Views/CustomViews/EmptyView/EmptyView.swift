//
//  EmptyView.swift
//  TMDB
//
//  Created by Kareem Abd El Sattar on 28/01/2024.
//

import UIKit

class EmptyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibView()
    }
}
