//
//  FeedViewController.swift
//  InstaPic
//
//  Created by My Mac on 3/9/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet weak var tableView: UITableView!
    
    //variales
    var posts = [PFObject]()
    var refreshControl : UIRefreshControl!
    var numberOfPosts : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
    }
    
    //load post from the server
    @objc func loadPosts(){
        numberOfPosts = 20;
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = numberOfPosts
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }else{
                print("error fetching data : \(error!.localizedDescription)")
            }
        }
    }
    
    func loadMorePosts(){
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        numberOfPosts += 1
        query.limit = numberOfPosts
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }else{
                print("error fetching data : \(error!.localizedDescription)")
            }
        }
    }
    
    
    
    @IBAction func onBack(_ sender: Any) {
        UserDefaults.standard.setValue(false, forKey: "userLoggedIn")
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        
        let user = post["author"] as? PFUser
        let captions = post["captions"] as? String
        
        cell.captionLabel.text = captions
        cell.userNameLabel.text = user?.username
        
        //image
        let imageFile = post["image"] as! PFFileObject
        let imageUrl = imageFile.url!
        let url = URL(string: imageUrl)!
        
        cell.photoView.af.setImage(withURL: url)
        
        
        return cell
    }
    
    //for loading post when scrolled
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count{
            loadMorePosts()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
