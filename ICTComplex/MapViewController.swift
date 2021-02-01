import UIKit
import Alamofire
import SwiftyJSON

public struct Place{
    let placeName :String
    let x:Double
    let y:Double
    let address:String
    let number: String
    let time: String
    let date: String
}

public let DEFAULT_POSITION = MTMapPointGeo(latitude: 37.576568, longitude: 127.029148)
class MapViewController: UIViewController, MTMapViewDelegate {
    
    @IBOutlet var subView: UIView!
    var mapView: MTMapView?
    
    var resultList=[Place]()
    
    var mapPoint1: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    
    let session: URLSession = URLSession.shared
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    var allCircle = [MTMapCircle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도 불러오기
        mapView = MTMapView(frame: subView.frame)
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            
            // 현재 위치 트래킹
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            //            mapView.addPOIItems([poiItem1,poiItem2]
            //            mapView.fitAreaToShowAllPOIItems()
            self.view.addSubview(mapView)
        }
    }
    
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        let index = poiItem.tag
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let popUp = storyboard.instantiateViewController(identifier: "detailViewController")
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.modalTransitionStyle = .crossDissolve
        print(resultList[index].placeName)
        
        let temp = popUp as? detailViewController
        temp?.addressStr = resultList[index].address
        temp?.getX = poiItem.mapPoint.mapPointGeo().latitude
        temp?.getY = poiItem.mapPoint.mapPointGeo().longitude
        temp?.dateStr = resultList[index].date
        temp?.timeStr = resultList[index].time
        temp?.getName = resultList[index].placeName
        temp?.numberStr = resultList[index].number
        self.present(popUp, animated: true, completion: nil)
    }
    
    @IBAction func allView(_ sender: Any) {
        mapView?.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  resultList[0].x, longitude: resultList[0].y)), zoomLevel: 5, animated: true)
        makeMarker(code: 0)
    }
    @IBAction func nearView(_ sender: Any) {
        //        resultList = [Place]()
        mapView?.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  resultList[0].x, longitude: resultList[0].y)), zoomLevel: 5, animated: true)
        makeMarker(code: 1)
    }
    
    func getCall() {
        resultList = [Place]()
        var subUrl = "api/v1/cafeteria/\(37.44960865487391)/\(126.73233856426081)"
        print("x : \(longitude) y : \(latitude)")
        //        if selectCode == 0 {
        //            subUrl = ""
        //        }
        //        else {
        //            subUrl = ""
        //        }
        let task = URLSession.shared.dataTask(with: URL(string: NetworkController.baseUrl + subUrl)!) { (data, response, error) in
            print("연결!")
            if let dataJson = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        if let temp = json["data"] as? NSArray {
                            var placeName : String?
                            var xValue : Double?
                            var yValue : Double?
                            var placeAddress : String?
                            var placeNumber = "정보 없음"
                            var date = "정보 없음"
                            var time = "정보 없음"
                            for i in temp {
                                if let nameStr = i as? [String:Any] {
                                    placeName = nameStr["facilityName"] as! String
                                }
                                if let x = i as? [String:Any] {
                                    xValue = x["latitude"] as! Double
                                }
                                if let y = i as? [String:Any] {
                                    yValue = y["longitude"] as! Double
                                }
                                if let addressStr = i as? [String:Any] {
                                    placeAddress = addressStr["address"] as! String
                                }
                                if let numberStr = i as? [String:Any] {
                                    if let nS = numberStr["phoneNumber"] as? String {
                                        placeNumber = nS
                                    }
                                }
                                if let operatingDateStr = i as? [String : Any] {
                                    if let nS = operatingDateStr["operatingDate"] as? String {
                                        date = nS
                                    }
                                }
                                if let timeStr = i as? [String : Any] {
                                    if let nS = timeStr["operatingTime"] as? String {
                                        time = nS
                                    }
                                }
                                self.resultList.append(Place(placeName: placeName!, x: xValue!, y: yValue!, address: placeAddress!, number: placeNumber, time: time, date: date))
                            }
                        }
                    }
                }
                catch {
                    print("JSON 파상 에러")
                    
                }
                print("JSON 파싱 완료")
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
    }
    
    
    func makeMarker(code : Int){
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
        var cnt = 0
        for item in resultList {
            if code == 1 && cnt == 5 {
                break
            }
            self.mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.x, longitude: item.y
            ))
            poiItem1 = MTMapPOIItem()
            poiItem1?.markerType = MTMapPOIItemMarkerType.redPin
            poiItem1?.mapPoint = mapPoint1
            poiItem1?.itemName = item.placeName
            poiItem1?.tag = cnt
            mapView!.add(poiItem1)
            cnt += 1
        }
    }
    
    
    // Custom: 현 위치 트래킹 함수
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude.magnitude, let longitude = currentLocation?.longitude.magnitude{
            self.latitude = latitude
            self.longitude = longitude
            
        }
        // 지도 중심점, 레벨
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  37.44960865487391, longitude: 126.73233856426081)), zoomLevel: 5, animated: true)
        
    }
    
    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
    }
}
