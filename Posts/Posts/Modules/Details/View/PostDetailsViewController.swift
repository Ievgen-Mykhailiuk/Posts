//
//  PostDetailsViewController.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import UIKit

protocol PostDetailsView: AnyObject {
    func showDetails(for post: PostDetailsModel)
    func showAlert(error: String)
}

final class PostDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var postTitleLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var postTextLabel: UILabel!
    @IBOutlet private weak var postLikesCountLabel: UILabel!
    @IBOutlet private weak var postDateLabel: UILabel!
    
    //MARK: - Properties
    var presenter: PostDetailsViewPresenter!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchPostDetails()
    }
    
    //MARK: - Configuration method
    private func configureScreen(with post: PostDetailsModel) {
        self.postTitleLabel.text = post.title
        self.postImageView.setImage(imageUrl: post.imageUrl)
        self.postTextLabel.text = post.text
        self.postLikesCountLabel.text = String(post.likesCount)
        self.postDateLabel.text = Date.timeAgo(from: post.timeShamp)
    }
}

//MARK: - PostDetailsViewProtocol
extension PostDetailsViewController: PostDetailsView  {
    func showDetails(for post: PostDetailsModel) {
        DispatchQueue.main.async {
            self.configureScreen(with: post)
        }
    }
    
    func showAlert(error: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Error", message: error)
        }
    }
}
