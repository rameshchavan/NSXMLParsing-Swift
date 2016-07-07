

import UIKit

class ViewController: UIViewController, NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource
{
    var objNSXMLParser = NSXMLParser()
    var objPostArray = NSMutableArray()
    var objPostDictionary = NSMutableDictionary()
    var objDataString = NSString()
    var objDataTitle = NSMutableString()
    var objDataDate = NSMutableString()
    
    @IBOutlet weak var tblNews: UITableView!
    
//     MARK: - View Life Cycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.startParsing()
    }
    
//     MARK: - NSXMLParserDelegate Methods
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
    {
        objDataString = elementName
        
        if (elementName as NSString).isEqualToString("item") {
            objPostDictionary = NSMutableDictionary.alloc()
            objPostDictionary = [:]
            
            objDataTitle = NSMutableString.alloc()
            objDataTitle = ""
            
            objDataDate = NSMutableString.alloc()
            objDataDate = ""
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("item") {
            
            if !objDataTitle.isEqual(NSNull) {
                objPostDictionary.setObject(objDataTitle, forKey: "title")
            }
            
            if !objDataDate.isEqual(NSNull) {
                objPostDictionary.setObject(objDataDate, forKey: "date")
            }
            
            objPostArray.addObject(objPostDictionary)
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?)
    {
        if objDataString.isEqualToString("title") {
            objDataTitle.appendString(string!)
        } else if objDataString.isEqualToString("pubDate") {
            objDataDate.appendString(string!)
        }
    }
    
//    MARK: - UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return objPostArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        if(cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed("Cell", owner: self, options: nil)[0] as! UITableViewCell;
        }
        cell.textLabel?.text = objPostArray.objectAtIndex(indexPath.row).valueForKey("title") as! NSString as String
        cell.detailTextLabel?.text = objPostArray.objectAtIndex(indexPath.row).valueForKey("date") as! NSString as String
        
        return cell as UITableViewCell
    }
    
//    MARK: - Other Methods
    
    func startParsing()
    {
        objPostArray = []
        objNSXMLParser = NSXMLParser(contentsOfURL: NSURL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss"))!
        objNSXMLParser.delegate = self
        objNSXMLParser.parse()
        
        tblNews.reloadData()
    }

}

