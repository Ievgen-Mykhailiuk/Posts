//
//  PostListCell.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import UIKit

//MARK: - Protocols
protocol CellStateDelegate: AnyObject {
    func readMoreButtonTapped(_ postId: Int)
}

final class PostListCell: BaseTableViewCell {
    
    //MARK: - Outlets
    @IBOutlet private weak var postTitleLabel: UILabel!
    @IBOutlet private weak var postTextLabel: UILabel!
    @IBOutlet private weak var heartImageView: UIImageView!
    @IBOutlet private weak var likesCountLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    //MARK: - Properties
    weak var delegate: CellStateDelegate?
    private var postId: Int = .zero
    private let collapsedLinesCount: Int = 2
    private let expandedLinesCount: Int = .zero
    private let collapsedButtonTitle: String = "Read more"
    private let expandedButtonTitle: String = "Read less"
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initialButtonSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        readMoreButton.isHidden = false
    }
    
    //MARK: - Actions
    @IBAction func readMoreButtonTapped(_ sender: UIButton) {
        delegate?.readMoreButtonTapped(postId)
    }
    
    //MARK: - View configuration
    func configure(post: PostListModel, isExpanded: Bool) {
        postId = post.id
        postTitleLabel.text = post.title
        postTextLabel.text = post.previewText
        likesCountLabel.text = String(post.likesCount)
        dateLabel.text = Date.timeAgo(from: post.timeShamp)
        setupButton(isExpanded: isExpanded)
    }
    
    //MARK: - Button configuration
    private func makeExpanded() {
        postTextLabel.numberOfLines = expandedLinesCount
        readMoreButton.setTitle(expandedButtonTitle, for: .normal)
    }
    
    private func makeCollapsed() {
        postTextLabel.numberOfLines = collapsedLinesCount
        readMoreButton.setTitle(collapsedButtonTitle, for: .normal)
    }
    
    private func initialButtonSetup() {
        readMoreButton.layer.cornerRadius = 11
        readMoreButton.layer.borderWidth = 1
        readMoreButton.layer.borderColor = UIColor.black.cgColor
        readMoreButton.setTitleColor(.black, for: .normal)
    }
    
    private func setupButton(isExpanded: Bool) {
        checkTextLabelHeight()
        isExpanded ? makeExpanded() : makeCollapsed()
    }
    
    private func checkTextLabelHeight() {
        let width = postTextLabel.frame.width
        guard let text = postTextLabel.text else { return }
        let height = text.rectHeight(with: width)
        let visibleHeihgt = text.visibleRectHeight(numberOfLines: collapsedLinesCount)
        if height <= visibleHeihgt {
            readMoreButton.isHidden = true
        }
    }
}
