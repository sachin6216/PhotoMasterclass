//
//  PhotoMasterclassTests.swift
//  PhotoMasterclassTests
//
//  Created by Sachin on 26/03/23.
//

import XCTest
@testable import PhotoMasterclass

final class PhotoMasterclassTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class. 
    }
    
    
     func testAPICallSucess() {
         // Success test case for Get All lesson API URL working or not correct
          let api_url_base = "https://iphonephotographyschool.com/test-api/lessons"
         guard let url = URL(string: "\(api_url_base)") else { return }
         var urlRequest = URLRequest(url: url)
         urlRequest.cachePolicy = .returnCacheDataElseLoad
         
         URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
             XCTAssertTrue(error == nil) // error should be nil - Positive case
         }.resume()
         
    }
    
    
    func testAPICallFailed(){
        // Failed test case for Get All lesson API URL working or not correct
        let api_url_base = "https://iphonephotographyschool.com/test-api/lesso"
       guard let url = URL(string: "\(api_url_base)") else { return }
       var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
       
       URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
           XCTAssertTrue(error != nil) // error should not be nil - negetive case
       }.resume()
        
    }
    
    
    func testDownloadLinkValid(){
        // Success test case for check download hanling and URL is working correct or not
        let data = LessonsItem.init(id: 1, name: "test1", description: "lorem", thumbnail: "", video_url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
      
        XCTAssertTrue((data.video_url).canOpenURL() == true) // Url is valid - Positive case
        guard let urlResquest = URL.init(string: data.video_url) else { return }
        downloadFileAsync(url: urlResquest, item: data, completionHanlder: { _,_ in
            
        })
        
        
    }
    
    func testDownloadLinkNotValid(){
        // Failed test case for check download hanling and URL is working correct or not
        let data = LessonsItem.init(id: 1, name: "test1", description: "lorem", thumbnail: "", video_url: "sdf")
      
        XCTAssertTrue((data.video_url).canOpenURL() == false) // Url is valid - negetive case
        guard let urlResquest = URL.init(string: data.video_url) else { return }
        downloadFileAsync(url: urlResquest, item: data, completionHanlder: { _,_ in
            
        })
    }

}
