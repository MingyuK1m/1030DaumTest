//
//  BookTableViewController.swift
//  BookFinder
//
//  Created by D7702_10 on 2017. 10. 30..
//  Copyright © 2017년 D7702_10. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController, XMLParserDelegate, UISearchBarDelegate {

    //api를 사용하기 위한 개인 키
    let apikey = "12e019b25265e571f9c178f4d9e4540d"
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var currentElement:String = ""
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "책검색기"
        searchbar.delegate = self
    }
    
    //시작하는 지점을 찾는다
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //태그를 저장한다 키로 사용하기 위해서
        currentElement = elementName
        
        //아이템을 처음 만나을 때 딕셔너리를 다시만든다
        if currentElement == "item" {
            item = [:]
        }
    }
    
    //키를 이용하여 데이터를 찾아 넣는다.
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        item[currentElement] = string
    }

    //파싱이 끝나서 배열에 집어넣는다.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            items.append(item)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(query: searchBar.text!, pageno: 1)
    }
    
    
    //검색소스
    func search(query:String, pageno:Int){
        //NSString 좀 더 좋은 스트링
        let str = "https://apis.daum.net/search/book?apikey=\(apikey)&output=xml&q=\(query)&pageno=\(pageno)&result=20" as NSString
        //한글이나 특수문자를 코드로 바꿔주는 코드
        let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print(strURL ?? "url is error") //에러 확인
        
        //url을 테스트하여 작동이 되는 지 확인하는 동작
        //옵셔널 확인 , URL전환, xml파싱을 하는 코드
        if let strURL = strURL, let url = URL(string:strURL), let parser = XMLParser(contentsOf: url){
            parser.delegate = self
            
            let success = parser.parse()
            if success {
                print("parse sucess!")
                print(items)
                tableView.reloadData()
            } else {
                print("parse failure!")
            }
        }

    }
        
        
    
   override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let book = items[indexPath.row]
        
        return cell
    }
    


}
