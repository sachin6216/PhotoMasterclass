//
//  LessonDetailsViewController.swift
//  PhotoMasterclass
//
//  Created by Sachin on 26/03/23.
//

import UIKit
import AVFoundation
import AVKit
import SwiftUI

class LessonDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    var rightBarBtn = UIButton()
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
        view.heightAnchor.constraint(equalToConstant: 210).isActive = true
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
    var isDownloading = false
    var playerViewController = AVPlayerViewController()

    
    // MARK: - Life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUI()
        self.nextButton.addTarget(self, action: #selector(btnNextAct), for: .touchUpInside)
        self.rightBarBtn.addTarget(self, action: #selector(btnDownloadAct), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUIForOffline()
    }
    override func viewWillDisappear(_ animated: Bool) {
        playerViewController.player?.pause()
        self.rightBarBtn.isHidden = true
    }
    // MARK: - IBOutlets Action
    @objc func btnNextAct() {
        let index = self.lessonsList.firstIndex(where: {$0.id == self.currentLesson?.id})
        guard index != self.lessonsList.count - 1 else {
            return
        }
        self.currentLesson = self.lessonsList[(index ?? 0) + 1]
        self.setUI()
        self.setUIForOffline()
    }
    
    @objc func btnDownloadAct() {
//        if self.isDownloading == false {
//            self.rightBarBtn.isHidden = true
//        } else {
//            self.setRightNavBarBtn(title: "Cancel", systemNameIcon: "xmark.circle")
//        }
//
        
        if self.isDownloading {
            self.isDownloading = false
            self.cancel()
        } else {
            guard let item = self.currentLesson else { return }
            guard let urlResquest = URL.init(string: item.video_url) else { return }
            self.setRightNavBarBtn(title: "Cancel", systemNameIcon: "xmark.circle")
            self.isDownloading = true
            downloadFileAsync(url: urlResquest, item: item, completionHanlder: { (pathUrl, item) in
                self.isDownloading = false
                self.saveToOffline(pathUrl, item: item)
            })
        }
        
    }
    // MARK: - Extra Methods
    /// Set scroll and sub-view programmatically
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
    
    /// Set AVPlayer and Play video  programmatically
    fileprivate func setUIAvPlayer() {
        guard let videoUrl = URL.init(string: self.currentLesson?.video_url ?? "") else {
            print("Link failed!")
            return }
        
        let player = AVPlayer(url: videoUrl)
        playerViewController.view.frame = self.avPlayerView.bounds
        playerViewController.player = player
        
        self.addChild(playerViewController)
        self.avPlayerView.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)
    }
    
    /// Set  title and tesciption of the video programmatically
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
    /// Set  right navigation bar item programmatically
    fileprivate func setRightNavBarBtn(title: String, systemNameIcon: String) {
        self.rightBarBtn.setImage(UIImage.init(systemName: systemNameIcon), for: .normal)
        self.rightBarBtn.setTitle(" \(title)", for: .normal)
        self.rightBarBtn.setTitleColor(.systemBlue, for: .normal)
        self.rightBarBtn.titleLabel?.font = .systemFont(ofSize: 15)
        rightBarBtn.translatesAutoresizingMaskIntoConstraints = false
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(self.rightBarBtn)
        self.rightBarBtn.isHidden = false
        
        rightBarBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        rightBarBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: -30).isActive = true
        
    }
    
    /// Handling UI for right navigation bar item programmatically
    fileprivate func setUIForOffline() {
        DispatchQueue.main.async {
            if DatabaseHelper.shareInstance.getLessonData().count == 0 {
                self.setRightNavBarBtn(title: "Download", systemNameIcon: "icloud.and.arrow.down")
            } else {
                DatabaseHelper.shareInstance.getLessonData().forEach { item in
                    if item.id == "\(self.currentLesson?.id ?? -1)" {
                        self.currentLesson?.video_url = item.videoUrl ?? ""
                        self.currentLesson?.thumbnail = item.thumbnail ?? ""
                        self.currentLesson?.name = item.name ?? ""
                        self.currentLesson?.description = item.lessonsDescription ?? ""
                        self.currentLesson?.id = Int(item.id ?? "-2") ?? -2
                        self.setUI()
                        self.rightBarBtn.isHidden = true
                    } else {
                        self.setRightNavBarBtn(title: "Download", systemNameIcon: "icloud.and.arrow.down")
                    }
                }
            }
        }
    }
    // MARK: - APIs
    /// Cancel video API
    func cancel() {
        task?.cancel()
        self.setRightNavBarBtn(title: "Download", systemNameIcon: "icloud.and.arrow.down")
    }
    
    /// Save video in database
    fileprivate func saveToOffline(_ urlPath: String?, item: LessonsItem) {
        let dict = ["id" : "\(item.id)",
                    "name" : item.name,
                    "lessonsDescription" : item.description,
                    "thumbnail" : item.thumbnail,
                    "videoUrl" : item.video_url
        ]
        DatabaseHelper.shareInstance.save(object: dict)
        self.setUIForOffline()
    }
}
// MARK: - Extensions
