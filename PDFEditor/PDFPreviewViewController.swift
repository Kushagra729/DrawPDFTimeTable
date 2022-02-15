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
    
  override func viewDidLoad() {
    super.viewDidLoad()
      let pdfCreator = PDFCreator(title: "iOS Developer", body: "Software Developer",
                                  image: UIImage(named: "logo")!, contact: "contact")
      documentData = pdfCreator.createFlyer()
    
    if let data = documentData {
      pdfView.document = PDFDocument(data: data)
      pdfView.autoScales = true
    }
  }
}
