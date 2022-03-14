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
    public var pdfCreator = PDFCreator()
    @IBOutlet weak var pdfView: PDFView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fireAPI()
        
    }
    
    func fireAPI(){
        PdfRawDataModel.pdfMethod { [self] success, errMsg, erorCode in
            if let success = success {
                documentData = pdfCreator.createFlyer(pdfeditor: success)
                if let data = documentData {
                    pdfView.document = PDFDocument(data: data)
                    pdfView.autoScales = true
                }
            }else{
                print(errMsg)
                print(erorCode)
            }
        }
    }
}
