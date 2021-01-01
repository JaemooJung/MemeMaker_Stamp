//
//  ViewController.swift
//  MemeMaker
//
//  Created by JaemooJung on 2021/01/01.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var memeView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePickerController = UIImagePickerController()
    

    @IBOutlet var stampLabels: [UILabel]!
    
    @IBOutlet weak var stampContentTextField: UITextField!
    
    var stampContent:String = ""
    
    //__________________
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleLabel.font = UIFont(name: "BMEuljiro10yearslaterOTF", size: 75)
        
        
        imagePickerController.delegate = self
        setStampLabelFont()
    }

    //__________________
    
    func setStampLabelFont() {
        for i in 0...3 {
            stampLabels[i].font = UIFont(name: "BMEuljiro10yearslaterOTF", size: 80)
        }
        
        
    }

    // 버튼을 누르면 텍스트 필드 안에 있는 글자를 도장으로 만들어 사진 위에 표시
    @IBAction func submitStampContent(_ sender: UIButton) {
        var alertTitle = ""
        var alertMessage = ""
        if stampContentTextField.text?.isEmpty == true {
            alertTitle = "글자 없음"
            alertMessage = "글자가 없어요!"
            showAlert(alertTitle: alertTitle, alertMessage: alertMessage)
            return
        } else if stampContentTextField.text!.count > 4 {
            stampContentTextField.text = nil
            alertTitle = "글자 수 초과"
            alertMessage = "네 글자 이하로 입력해주세요!"
            showAlert(alertTitle: alertTitle, alertMessage: alertMessage)
        } else {
            stampContent = stampContentTextField.text!
            setStampLabelText()

        }
        
    }
    
    //도장에 들어갈 글자 설정. 4글자보다 적으면 앞에 공백 추가
    func setStampLabelText() {
        if stampContent.count < 4 {
            stampContent = String(repeating: " ", count: 4 - stampContent.count) + stampContent
        }
        
        for i in 0...3 {
            let contentIndex = stampContent.index(stampContent.startIndex, offsetBy: i)
            stampLabels[i].text = String(stampContent[contentIndex])
        }
    }
    
    
    
    // 조건 미충족시 경고창 띄우는 함수
    func showAlert(alertTitle:String, alertMessage:String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //---- 이 아래로 앨범에서 이미지 가져오는 함수
    @IBAction func importImage(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any])  {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //----- 이미지 저장 함수
    
    //memeView(UIview)를 UIimage로 변환
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: memeView.bounds.size)
        let image = renderer.image {
            ctx in memeView.drawHierarchy(in: memeView.bounds, afterScreenUpdates: true)
        }
        print("convert finished")
        return image
    }
    
    //저장버튼 누르면 앨범에 이미지 저장 되도록...
    @IBAction func saveMemeToPhotos(_ sender: Any) {
        
        var alertTitle:String
        var alertMessage:String
        
        if imageView.image == nil {
            alertTitle = "이미지가 없습니다!"
            alertMessage = "이미지를 추가해주세요 :)"
            
            showAlert(alertTitle: alertTitle, alertMessage: alertMessage)
            return
        } else {
            let finalImage = asImage()
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            alertTitle = "저장 완료!"
            alertMessage = "저장이 완료되었습니다 :)"
            showAlert(alertTitle: alertTitle, alertMessage: alertMessage)
        }
    }
    
    // ----------- textField 키보드 관련 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    

}

