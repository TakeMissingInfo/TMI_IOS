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
    var isNear = false
    
    var mapPoint1: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    
    let session: URLSession = URLSession.shared
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    var allCircle = [MTMapCircle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        // 지도 불러오기
        mapView = MTMapView(frame: subView.frame)
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            
            // 현재 위치 트래킹
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  latitude, longitude: longitude)), zoomLevel: 5, animated: true)
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
        isNear = false
        getCall()
        makeMarker(code: 0)
    }
    @IBAction func nearView(_ sender: Any) {
        //        resultList = [Place]()
        //mapView?.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  resultList[0].x, longitude: resultList[0].y)), zoomLevel: 5, animated: true)
        isNear = true
        getCall()
        makeMarker(code: 1)
    }
    
    func getCall() {
        resultList = [Place]()
        var subUrl = "api/v1/cafeteria/\(latitude)/\(longitude)"
        print("URL : " + subUrl)
        var cnt = 0
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
                                cnt += 1
                                if cnt == 30 {
                                    break
                                }
                        
                            }
                        }
                    }
                }
                catch {
                    print("JSON 파상 에러")
                    
                }
                print("JSON 파싱 완료")
            }
            DispatchQueue.main.async {
                var code = 0
                if self.isNear {
                    code = 1
                }
                self.makeMarker(code: code)
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //getCall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
    }
    
    
    func makeMarker(code : Int){
        print("코드 : \(code)")
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
        
    }
    
    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
    }
}
