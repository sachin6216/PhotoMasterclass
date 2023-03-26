//
//  LessonDetailsViewController.swift
//  PhotoMasterclass
//
//  Created by Sachin on 26/03/23.
//

import UIKit
import AVFoundation
import AVKit

class LessonDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    // MARK: - Variables
    var lessonsList = [LessonsItem]()
    var currentLesson: LessonsItem?
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 0
        view.distribution = .fill
        view.alignment = .fill
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let redView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 180).isActive = true
        view.backgroundColor = .red
        return view
    }()
    
    let blueView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let nextButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitle("Next lesson", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let nextImg: UIImageView = {
        let img = UIImageView()
        img.frame = .init(x: 0, y: 0, width: 15, height: 15)
        img.image = UIImage.init(systemName: "chevron.right")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUI()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.showsLargeContentViewer = false
        self.nextButton.addTarget(self, action: #selector(btnNextAct), for: .touchUpInside)
        
    }
    
    // MARK: - IBOutlets Action
    @objc func btnNextAct() {
        let index = self.lessonsList.firstIndex(where: {$0.id == self.currentLesson?.id})
        guard index != self.lessonsList.count - 1 else {
            return
        }
        self.currentLesson = self.lessonsList[(index ?? 0) + 1]
        self.setUI()
    }
    // MARK: - Extra Methods
    fileprivate func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(redView)
        scrollViewContainer.addArrangedSubview(blueView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        self.setUIAvPlayer()
        self.setupTitleViews()
        
    }
    fileprivate func setUIAvPlayer() {
        guard let videoUrl = URL.init(string: self.currentLesson?.video_url ?? "") else {
            print("Link failed!")
            return }
        
        let player = AVPlayer(url: videoUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.view.frame = self.redView.bounds
        playerViewController.player = player
        
        self.addChild(playerViewController)
        self.redView.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)
    }
    func setupTitleViews(){
        self.titleLabel.text = self.currentLesson?.name
        self.subtitleLabel.text = self.currentLesson?.description
        self.blueView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.blueView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.blueView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.blueView.trailingAnchor, constant: -20).isActive = true
        
        self.blueView.addSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: self.blueView.leadingAnchor, constant: 20).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: self.blueView.trailingAnchor, constant: -20).isActive = true
        
        self.blueView.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -15).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.blueView.bottomAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.nextButton.addSubview(nextImg)
        self.nextImg.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor, constant: 0).isActive = true
        self.nextImg.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -20).isActive = true
        
        
    }
    // MARK: - APIs
}
// MARK: - Extensions
