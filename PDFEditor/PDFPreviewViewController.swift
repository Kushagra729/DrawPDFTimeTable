//
//  ViewController.swift
//  PDFEditor
//
//  Created by Kushagra on 2/2/22.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
  public var documentData: Data?
  @IBOutlet weak var pdfView: PDFView!
    var pdfEditor : [PdfRawDataModel]?
    
    override func viewDidLoad() {
    super.viewDidLoad()
      let pdfCreator = PDFCreator(title: "iOS Developer", body: "Software Developer",
                                  image: UIImage(named: "logo")!, contact: "contact")
      fireAPI()
      documentData = pdfCreator.createFlyer()
    
    if let data = documentData {
      pdfView.document = PDFDocument(data: data)
      pdfView.autoScales = true
    }
  }
    func fireAPI(){
        ClassesModel.pdfMethod { [self] success, errMsg, erorCode in
            if let success = success {
                pdfEditor = success
                print(pdfEditor)
            }else{
                print(errMsg)
                print(erorCode)
            }
        }
    }
}
