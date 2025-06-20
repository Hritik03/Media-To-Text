//
//  UtilityClass.swift
//  PHpicker
//
//  Created by hb on 25/02/22.
//

import UIKit
import PhotosUI
import UniformTypeIdentifiers
  @objc  protocol ImageGet{
      func setImg(image:UIImage? , url:URL? , name : String? , type:String?)
      @objc optional  func getAudioName(Name: String)
}

class UtilityClass: NSObject, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate , UIDocumentPickerDelegate ,UINavigationControllerDelegate {
    var delegate : ImageGet?
    var obj : MediaViewController?
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self){
                result.itemProvider.loadObject(ofClass: UIImage.self){ (image,error) in
                    guard let image = image as? UIImage else {return}
                    
                    DispatchQueue.main.async {
                        self.delegate?.setImg(image: image, url: nil, name: nil, type: "image")
                        
                    }
                }
            } else {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let url = url else {
                        return
                    }
                    let filename = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
                    var obj = Media()
                    let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + filename)
                    try? FileManager.default.copyItem(at: url, to: newUrl)
                   
                    let name =  url.lastPathComponent
                    print(name)
                    print(url)
                    print(url.absoluteURL)
                    print(url.path)
                    let videoThumb = self.generateThumbnail(url: newUrl)
                    obj.thumb = videoThumb
                    DispatchQueue.main.async {
                        print(videoThumb)
                        self.delegate?.setImg(image: videoThumb!, url: newUrl, name: name, type: "video")
                    }
                }
            }
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let selectedVideo : URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            let videoThumb = generateThumbnail(url: selectedVideo)
           
            var obj = Media()
            obj.url = selectedVideo
            obj.thumb = videoThumb
            let name = selectedVideo.lastPathComponent
            DispatchQueue.main.async {
                self.delegate?.setImg(image: videoThumb!, url: selectedVideo, name: name, type: "video")
            }
            
            
        }else{
            guard let image = info[.editedImage] as? UIImage else {
                print("No image found")
                return
            }
            // print out the image size as a test
            DispatchQueue.main.async {
                print(image)
                self.delegate?.setImg(image: image, url: nil, name: nil, type: "image")
            }
        }
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let filename = "\(Int(Date().timeIntervalSince1970)).\(urls.description)"
        let file = urls.last?.lastPathComponent
        self.delegate?.setImg(image: nil, url: urls.first, name: file, type: "Audio")
        self.delegate?.getAudioName?(Name: file!)
    }
    //MARK: ActionSheet
    
    
    
    
    
    
    func ImageGet() {
        let alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Audio", style: .default, handler: { action in
            self.presentDocumentView()

        })
        alert.addAction(camera)
        let library = UIAlertAction(title: "Video", style: .default, handler: { action in
            self.presentPHPickerView()
        })
        alert.addAction(library)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in})
        alert.addAction(cancel)
        obj?.present(alert, animated: true, completion: nil)
    }
    func alert(key:String){
        
        let alertController = UIAlertController(title: "Alert", message: "can't allow Camera", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        alertController.addAction(OKAction)
        self.obj?.present(alertController, animated: true, completion: nil)
    }
    
    func presentPHPickerView(){
        
        var configuration:PHPickerConfiguration = PHPickerConfiguration()
        configuration.filter = .videos
        configuration.selectionLimit = 0
        var picker:PHPickerViewController = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        obj?.present(picker,animated: true, completion: nil)
    }
    
    
    func presentDocumentView(){
        let supportedType : [UTType] = [UTType.audio]
        let pickerContoller = UIDocumentPickerViewController(forOpeningContentTypes: supportedType, asCopy: true)
        pickerContoller.delegate = self
        pickerContoller.shouldShowFileExtensions = true
        obj?.present(pickerContoller, animated: true, completion: nil)
    }
    
    
    func generateThumbnail(url : URL) -> UIImage? {
        do{
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
            
            return UIImage(cgImage: cgImage)
        } catch{
            print(error.localizedDescription)
            
            return nil
        }
    }
    
    func cameraAccess()
    {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        obj?.present(vc, animated: true)
        
    }
    
}
struct Media {
    var image : UIImage?
    var url : URL?
    var thumb : UIImage?
    var type : MediaType?
    var data : Data?
}

enum MediaType {
    case Image
    case Video
}
