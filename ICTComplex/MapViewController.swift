import UIKit
import Alamofire
import SwiftyJSON

public struct Place{
        let placeName :String
        let longitudeX:Double
        let latitudeY:Double
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
            
            // 지도 중심점, 레벨
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  37.443948814883925, longitude: 126.73770385857193)), zoomLevel: 1, animated: true)
            
            // 현재 위치 트래킹
            //mapView.currentLocationTrackingMode = .onWithoutHeading
            //mapView.showCurrentLocationMarker = true
            
            
            
            self.view.addSubview(mapView)

            let url: URL = URL(string: "https://dapi.kakao.com/v2/local/search/address")!

            let body: NSMutableDictionary = NSMutableDictionary()

            body.setValue("value", forKey: "key")
        }
    }
    
    @IBAction func allView(_ sender: Any) {
        resultList = [Place]()
        resultList.append(Place(placeName: "신한은행", longitudeX: 37.445962310370994, latitudeY: 126.73758382147876))
        resultList.append(Place(placeName: "하나로마트", longitudeX: 37.445327528137, latitudeY: 126.735755325721))
        resultList.append(Place(placeName: "남동아파트", longitudeX: 37.445360325548606, latitudeY: 126.7343087206416))
        //getCall(selectCode: 0)
        makeMarker()
    }
    @IBAction func nearView(_ sender: Any) {
        resultList = [Place]()
        resultList.append(Place(placeName: "대동아파트", longitudeX: 37.44429779992755, latitudeY: 126.73460629193703))
        //getCall(selectCode: 1)
        makeMarker()
    }
    
    func getCall(selectCode : Int) {
        resultList = [Place]()
        var subUrl = ""
        if selectCode == 0 {
            subUrl = ""
        }
        else {
            subUrl = ""
        }
        let task = URLSession.shared.dataTask(with: URL(string: NetworkController.baseUrl + subUrl)!) { (data, response, error) in
            print("연결!")
            if let dataJson = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: dataJson, options: .allowFragments) as? [String: AnyObject]
                    {
                        print(json)
                        //print(json["data"] as? [String:Any])
                        if let temp = json["data"] as? [String:Any] {
                            if let temp2 = temp["orderFindResponses"] as? NSArray {
                                for i in temp2 {
                                    var placeName : String?
                                    var xValue : Double?
                                    var yValue : Double?
                                   
                                    if let placeNameStr = temp["placeName"] as? [String:Any] {
                                        placeName = placeNameStr as! String
                                    }
                                    if let xValueStr = temp["competentInstitution"] as? [String:Any] {
                                        xValue = xValueStr as! Double
                                    }
                                    if let yValueStr = temp["supportForm"] as? [String:Any] {
                                        yValue = yValueStr as! Double
                                    }
                                    self.resultList.append(Place(placeName: placeName!, longitudeX: xValue!, latitudeY: yValue!))
                                    
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
        }
        task.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let userCircle = circle(latitude: latitude, longitude: longitude)
        for item in allCircle {
            mapView!.removeCircle(item)
        }
        
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
        makeMarker()
    }
    
    
    func makeMarker(){
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
        for item in resultList {
            self.mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.longitudeX, longitude: item.latitudeY
            ))
            poiItem1 = MTMapPOIItem()
            poiItem1?.markerType = MTMapPOIItemMarkerType.redPin
            poiItem1?.mapPoint = mapPoint1
            poiItem1?.itemName = item.placeName
            mapView!.add(poiItem1)
        }
    }
    
    func circle(latitude:Double, longitude:Double) -> MTMapCircle {
        let circ = MTMapCircle()
        circ.circleCenterPoint = MTMapPoint(geoCoord:
                                                MTMapPointGeo(latitude: latitude.magnitude, longitude: longitude.magnitude)
        )
        circ.circleRadius = Float(50)
        circ.circleLineColor = UIColor.red
        circ.circleLineWidth = 5
        circ.circleFillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        circ.tag = 1
        
        return circ
    }
    
    
    // Custom: 현 위치 트래킹 함수
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude.magnitude, let longitude = currentLocation?.longitude.magnitude{
            print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
            self.latitude = latitude
            self.longitude = longitude
            let userCircle = circle(latitude: latitude, longitude: longitude)
            for item in allCircle {
                mapView.removeCircle(item)
            }
            allCircle = [MTMapCircle]()
            allCircle.append(circle(latitude: latitude, longitude: longitude))
            mapView.addCircle(allCircle[0])
        }
        
    }
    
    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
    }
}
