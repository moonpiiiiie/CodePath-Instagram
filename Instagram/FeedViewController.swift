//
//  FeedViewController.swift
//  Instagram
//
//  Created by Cheng Xue on 10/6/22.
//

import UIKit
import Parse
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

    
    
    var posts = [PFObject]()
    
    var refreshControl: UIRefreshControl!
    
    let commentBar = MessageInputBar()
    
    var showsCommentsBar = false
    
    var selectedPost: PFObject!
    
    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = loginViewController
    }
    @IBOutlet weak var tableView: UITableView!
    
    @objc func onRefresh(){
        loadPosts()
        self.refreshControl.endRefreshing()
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentsBar
    }
    
    func loadPosts(){
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground{ (posts, error) in
            if ((posts) != nil) {
                self.posts = posts!
                self.tableView.reloadData()
            } else {
                print("Error: \(error)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")  as! PostCell
            
            let user = post["author"] as! PFUser
            cell.postAuthor.text = user.username
            
            cell.postCaption.text = post["caption"] as! String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            cell.postImage.af.setImage(withURL: url)
            
            if (user["image"] != nil) {
                let authorImageFile = user["image"] as! PFFileObject
                let authorImageUrlString = authorImageFile.url!
                let authorImageUrl = URL(string: authorImageUrlString)!
                cell.authorImage.af.setImage(withURL: authorImageUrl)
            } else {
                cell.authorImage.image = UIImage(named: "image_placeholder")
            }
            
            return cell
            
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row-1]
            
            cell.commentContent.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.commentAuthor.text = user.username
            
            if (user["image"] != nil) {
                let authorImageFile = user["image"] as! PFFileObject
                let authorImageUrlString = authorImageFile.url!
                let authorImageUrl = URL(string: authorImageUrlString)!
                cell.commentProfile.af.setImage(withURL: authorImageUrl)
            } else {
                cell.commentProfile.image = UIImage(named: "image_placeholder")
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
        
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        let center  = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["author"] = PFUser.current()
        comment["post"] = selectedPost
        
        selectedPost.add(comment, forKey:"comments")
        selectedPost.saveInBackground{ (success, error) in
            if (success) {
                print("Comment saved")
            } else {
                print("Error: \(error)")
            }
            
        }
        tableView.reloadData()
        // clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        showsCommentsBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
//    func messageInputBar(_ inputBar: MessageInputBar, didChangeIntrinsicContentTo size: CGSize) {
//        <#code#>
//    }
//
//    func messageInputBar(_ inputBar: MessageInputBar, textViewTextDidChangeTo text: String) {
//        <#code#>
//    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentsBar = false
        becomeFirstResponder()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            self.showsCommentsBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post
        }
        
    }


}
