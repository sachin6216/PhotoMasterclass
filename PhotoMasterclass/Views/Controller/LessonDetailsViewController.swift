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
    
    let avPlayerView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 180).isActive = true
        view.backgroundColor = .red
        return view
    }()
    
    let briefView: UIView = {
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
    // MARK: - Variables
    var lessonsList = [LessonsItem]()
    var currentLesson: LessonsItem?

    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUI()
        self.nextButton.addTarget(self, action: #selector(btnNextAct), for: .touchUpInside)
        
        let btn1 = UIButton()
        btn1.setImage(UIImage.init(systemName: "chevron.left"), for: .normal)
        btn1.frame = CGRectMake(0, 0, 30, 30)
        btn1.setTitle(" Lessons", for: .normal)
        btn1.setTitleColor(.systemBlue, for: .normal)
        btn1.addTarget(self, action: #selector(btnBack), for: .touchUpInside)
        btn1.titleLabel?.font = .systemFont(ofSize: 15)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn1)
        
        
        
        let btn2 = UIButton()
        btn2.setImage(UIImage.init(systemName: "icloud.and.arrow.down"), for: .normal)
        btn2.frame = CGRectMake(0, 0, 30, 30)
        btn2.setTitle(" Download", for: .normal)
        btn2.setTitleColor(.systemBlue, for: .normal)
        btn2.titleLabel?.font = .systemFont(ofSize: 15)
        btn2.addTarget(self, action: #selector(btnDownloadAct), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn2)
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
    @objc func btnDownloadAct() {
        guard let item = self.currentLesson else { return }
        ItemCache.shared.cache(item, for: item.id)
        
        if let item = ItemCache.shared.getItem(for: item.id) {
            self.currentLesson = item
            let btn2 = UIButton()
            btn2.setImage(UIImage.init(systemName: "icloud.and.arrow.down"), for: .normal)
            btn2.frame = CGRectMake(0, 0, 30, 30)
            btn2.setTitle(" Saved", for: .normal)
            btn2.setTitleColor(.systemBlue, for: .normal)
            btn2.titleLabel?.font = .systemFont(ofSize: 15)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn2)
        } else {
            let btn2 = UIButton()
            btn2.setImage(UIImage.init(systemName: "icloud.and.arrow.down"), for: .normal)
            btn2.frame = CGRectMake(0, 0, 30, 30)
            btn2.setTitle(" Download", for: .normal)
            btn2.setTitleColor(.systemBlue, for: .normal)
            btn2.titleLabel?.font = .systemFont(ofSize: 15)
            btn2.addTarget(self, action: #selector(btnDownloadAct), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn2)
        }
    }
    
    @objc func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Extra Methods
    fileprivate func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(avPlayerView)
        scrollViewContainer.addArrangedSubview(briefView)
        
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
        playerViewController.view.frame = self.avPlayerView.bounds
        playerViewController.player = player
        
        self.addChild(playerViewController)
        self.avPlayerView.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)
    }
    func setupTitleViews(){
        self.titleLabel.text = self.currentLesson?.name
        self.subtitleLabel.text = self.currentLesson?.description
        
        self.briefView.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.briefView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.briefView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.briefView.trailingAnchor, constant: -20).isActive = true
        
        self.briefView.addSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: self.briefView.leadingAnchor, constant: 20).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: self.briefView.trailingAnchor, constant: -20).isActive = true
        
        self.briefView.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: briefView.trailingAnchor, constant: -15).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.briefView.bottomAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.nextButton.addSubview(nextImg)
        self.nextImg.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor, constant: 0).isActive = true
        self.nextImg.trailingAnchor.constraint(equalTo: briefView.trailingAnchor, constant: -20).isActive = true
        
        
    }
    // MARK: - APIs
}
// MARK: - Extensions
