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
          let api_url_base = "https://iphonephotographyschool.com/test-api/lessons"
         guard let url = URL(string: "\(api_url_base)") else { return }
         var urlRequest = URLRequest(url: url)
         urlRequest.cachePolicy = .returnCacheDataElseLoad
         
         URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
             XCTAssertNil(error == nil) // error should be nil - Positive case
         }.resume()
         
    }
    
    
    func testAPICallFailed(){
        let api_url_base = "https://iphonephotographyschool.com/test-api/lesso"
       guard let url = URL(string: "\(api_url_base)") else { return }
       var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
       
       URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
           XCTAssertTrue(error != nil) // error should not be nil - negetive case
       }.resume()
        
    }
    
    
    func testDownloadLinkValid(){
        let data = LessonsItem.init(id: 1, name: "test1", description: "lorem", thumbnail: "", video_url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
      
        XCTAssertTrue((data.video_url).canOpenURL() == true) // Url is valid - Positive case
        guard let urlResquest = URL.init(string: data.video_url) else { return }
        downloadFileAsync(url: urlResquest, item: data, completionHanlder: { _,_ in
            
        })
        
        
    }
    
    func testDownloadLinkNotValid(){
        let data = LessonsItem.init(id: 1, name: "test1", description: "lorem", thumbnail: "", video_url: "sdf")
      
        XCTAssertTrue((data.video_url).canOpenURL() == false) // Url is valid - negetive case
        guard let urlResquest = URL.init(string: data.video_url) else { return }
        downloadFileAsync(url: urlResquest, item: data, completionHanlder: { _,_ in
            
        })
    }
    

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
