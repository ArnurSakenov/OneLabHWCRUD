//
//  ViewController.swift
//  OneLabHW3
//
//  Created by Arnur Sakenov on 04.04.2023.
//

//
//  ViewController.swift
//  OneLabHW3
//
//  Created by Arnur Sakenov on 04.04.2023.
//

import UIKit
import SnapKit
import Alamofire
import FirebaseStorage
class ViewController: UIViewController {
    var posts: [Note] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        setConstraints()
        fetchData()

    }
    
    private var tableView:UITableView!
    private var newPostButton: UIButton!

    @objc private func newPostButtonTapped() {
        let alertController = UIAlertController(title: "New Post", message: "Enter the title and description", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Title"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Description"
        }
        
        let postAction = UIAlertAction(title: "Post", style: .default) { _ in
            guard let title = alertController.textFields?[0].text,
                  let description = alertController.textFields?[1].text else { return }
            
            self.createNewPost(title: title, description: description)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(postAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    private func setupNewPostButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("New Post", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemOrange
        button.addTarget(self, action: #selector(newPostButtonTapped), for: .touchUpInside)
        return button
    }

    private func setConstraints() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "Cell")
        newPostButton = setupNewPostButton()
           view.addSubview(newPostButton)
        view.addSubview(tableView)
        newPostButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-60)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(60)
            make.height.equalTo(70)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(newPostButton.snp.bottom).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    func fetchData() {
           NetworkManager.shared.fetchPosts { fetchedPosts in
               self.posts = fetchedPosts
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
       }
       func deletePost(withId postId: String, at indexPath: IndexPath) {
           NetworkManager.shared.deletePost(withId: postId) {
               self.posts.remove(at: indexPath.row)
               DispatchQueue.main.async {
                   self.tableView.deleteRows(at: [indexPath], with: .automatic)
               }
           }
       }
    func createNewPost(title: String, description: String) {
         NetworkManager.shared.createPost(title: title, description: description) {
             self.fetchData()
         }
     }

     func updatePost(postId: String, title: String, description: String) {
         NetworkManager.shared.updatePost(postID: postId, title: title, description: description) {
             self.fetchData()
         }
     }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.configure(with: post)
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://onelabhw-b6289.appspot.com/5.jpg.webp")
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }

            if let imageData = data {
                let image = UIImage(data: imageData)
                cell.imageview.image = image
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              let postToDelete = posts[indexPath.row]
              deletePost(withId: postToDelete.postId, at: indexPath)
          }
      }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Изменить") { (action, view, completionHandler) in
            // Добавьте код, который должен выполняться при свайпе вправо
            let postToEdit = self.posts[indexPath.row]
            let alertController = UIAlertController(title: "Изменить запись", message: nil, preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.text = postToEdit.title
                textField.placeholder = "Заголовок"
            }
            alertController.addTextField { (textField) in
                textField.text = postToEdit.description
                textField.placeholder = "Описание"
            }
            let saveAction = UIAlertAction(title: "Сохранить", style: .default) { (action) in
                guard let titleTextField = alertController.textFields?[0],
                      let descriptionTextField = alertController.textFields?[1],
                      let title = titleTextField.text,
                      let description = descriptionTextField.text else { return }
                self.updatePost(postId: postToEdit.postId, title: title, description: description)
            }
            alertController.addAction(saveAction)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated:true, completion: nil)
        }
        editAction.backgroundColor = .blue
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        return configuration
    }
}
