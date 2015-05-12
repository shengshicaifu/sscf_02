
import Foundation

protocol HttpProtocol{
    func didRecieveResult(result: NSDictionary)
}
class HttpController: NSObject{
    
    var delegate: HttpProtocol?
    
    //json get方法
    func get(url: String,view :UIView,callback : () -> Void){
        var nsUrl: NSURL = NSURL(string: url)!
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
        var errorMessage = String()
        request.timeoutInterval = 10
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!)->Void in
            if(error == nil){
//                println(data)
//                println(NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil))
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                self.delegate?.didRecieveResult(jsonResult)
                
            }else{
                //报错弹窗
                println(error.localizedDescription)
                AlertView.showMsg(error.localizedDescription, parentView: view)
            }
            callback()

        
        })
            }
    //json post方法
    func post(url: String ,params: NSDictionary,view:UIView,callback: (NSDictionary) -> Void) {
        var nsUrl: NSURL = NSURL(string: url)!
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
        request.timeoutInterval = 10
        request.HTTPMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var objStr = ""
        for(key, value) in params as NSDictionary{
            if(objStr == ""){
                objStr += "\(key)=\(value)"
            }else{
                objStr += "&\(key)=\(value)"
            }
        }
        let data: NSData = objStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        request.HTTPBody = data
//        println(request)
//        println(data)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!)->Void in
            if(error == nil){
//                println(data)
//                println(NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil))
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                self.delegate?.didRecieveResult(jsonResult)
                callback(jsonResult)
            }else{
                println(error)
                AlertView.showMsg(error.localizedDescription, parentView: view)
            }
        })
    }
//    func testInternet(view :UIViewController) -> Bool{
//        var reach = Reachability(hostName: Constant().ServerHost)
//        reach.unreachableBlock = {(r:Reachability!) -> Void in
//            dispatch_async(dispatch_get_main_queue(), {
//                let alert = UIAlertController(title: "提示", message: "网络连接有问题，请检查手机网络", preferredStyle: .Alert)
//                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
//                view.presentViewController(alert, animated: true, completion: nil)
//            })
//        }
//        
//        reach.startNotifier()
//    }
}