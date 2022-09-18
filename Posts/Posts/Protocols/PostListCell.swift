//
//  PostListCell.swift
//  Posts
//
//  Created by Евгений  on 18/09/2022.
//

import UIKit

protocol PostListCell: AnyObject {
    var postTitleLabel: UILabel! { get set }
    var postTextLabel: UILabel! { get set }
    var heartImageView: UIImageView! { get set }
    var likesCountLabel: UILabel! { get set }
    var dateLabel: UILabel! { get set }
    var readMoreButton: UIButton! { get set }
    var delegate: CellStateDelegate? { get set }
    var postId: Int { get set }
    var collapsedLinesCount: Int { get }
    var expandedLinesCount: Int { get }
    var collapsedButtonTitle: String { get }
    var expandedButtonTitle: String { get }
    func readMoreButtonTapped(_ sender: UIButton)
    func configure(post: PostListModel, isExpanded: Bool)
    func makeExpanded()
    func makeCollapsed()
    func initialButtonSetup()
    func setupButton(isExpanded: Bool)
    func checkTextLabelHeight()
    func getCellWidth() -> CGFloat
}

extension PostListCell {
    func configure(post: PostListModel, isExpanded: Bool) {
        postId = post.id
        postTitleLabel.text = post.title
        postTextLabel.text = post.previewText
        likesCountLabel.text = String(post.likesCount)
        dateLabel.text = Date.timeAgo(from: post.timeShamp)
        setupButton(isExpanded: isExpanded)
    }
    
    func makeExpanded() {
        postTextLabel.numberOfLines = expandedLinesCount
        readMoreButton.setTitle(expandedButtonTitle, for: .normal)
    }
    
    func makeCollapsed() {
        postTextLabel.numberOfLines = collapsedLinesCount
        readMoreButton.setTitle(collapsedButtonTitle, for: .normal)
    }
    
    func initialButtonSetup() {
        readMoreButton.makeRounded()
        readMoreButton.layer.borderWidth = 1
        readMoreButton.layer.borderColor = UIColor.black.cgColor
        readMoreButton.setTitleColor(.black, for: .normal)
    }
    
    func setupButton(isExpanded: Bool) {
        checkTextLabelHeight()
        isExpanded ? makeExpanded() : makeCollapsed()
    }
    
    func checkTextLabelHeight() {
        let width = getCellWidth()
        guard let text = postTextLabel.text else { return }
        let height = text.rectHeight(with: width)
        let visibleHeihgt = text.visibleRectHeight(numberOfLines: collapsedLinesCount)
        if height <= visibleHeihgt {
            readMoreButton.isHidden = true
        }
    }
}
