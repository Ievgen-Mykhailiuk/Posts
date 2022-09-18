//
//  CollectionCell.swift
//  Posts
//
//  Created by Евгений  on 15/09/2022.
//

import UIKit

final class CollectionCell: BaseCollectionViewCell, PostListCell {
    
    //MARK: - Outlets
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    //MARK: - Properties
    weak var delegate: CellStateDelegate?
    var postId: Int = .zero
    let collapsedLinesCount: Int = 4
    let expandedLinesCount: Int = .zero
    let collapsedButtonTitle: String = "Read more"
    let expandedButtonTitle: String = "Read less"
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initialButtonSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        readMoreButton.isHidden = false
    }
   
    //MARK: - Action
    @IBAction func readMoreButtonTapped(_ sender: UIButton) {
        delegate?.readMoreButtonTapped(postId)
    }
    
    func getCellWidth() -> CGFloat {
        return self.frame.width
    }
}

