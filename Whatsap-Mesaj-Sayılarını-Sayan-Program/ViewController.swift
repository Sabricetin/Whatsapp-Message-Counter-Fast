

import UIKit
import UniformTypeIdentifiers
import ZIPFoundation

class ViewController: UIViewController, UIDocumentPickerDelegate {
        
        private let resultLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Sonuç burada görünecek"
            label.textColor = UIColor(named: "DarkGreen")
            label.font = UIFont.boldSystemFont(ofSize: 18)
            return label
        }()
    
        private let selectFileButton: UIButton = {
            let button = UIButton(type: .system)
            
            let buttonTitle = NSAttributedString(
                string: " Dosya Seç",
                attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.white]
            )
            button.setAttributedTitle(buttonTitle, for: .normal)
            
            let iconConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
            let icon = UIImage(systemName: "doc", withConfiguration: iconConfig)
            button.setImage(icon, for: .normal)
            button.tintColor = .white
            
            button.backgroundColor = UIColor(red: 0.0, green: 0.78, blue: 0.32, alpha: 1.0)
            button.layer.cornerRadius = 10
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.3
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            button.layer.shadowRadius = 5
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.imageView?.contentMode = .scaleAspectFit
            button.semanticContentAttribute = .forceLeftToRight
            return button
        }()
        
        private let activityIndicator: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .white
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.hidesWhenStopped = true
            return indicator
        }()

            // ScrollView ekleme
        private let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
                scrollView.translatesAutoresizingMaskIntoConstraints = false
         return scrollView
     }()
     
     // StackView'i ScrollView içinde kullanacağız
     private let resultsStackView: UIStackView = {
         let stackView = UIStackView()
         stackView.axis = .vertical
         stackView.spacing = 10
         stackView.alignment = .center
         stackView.translatesAutoresizingMaskIntoConstraints = false
         return stackView
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
        updateGradientBackground()
        
      
        
        // Trait değişikliklerini dinleme
        func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            
            // Karanlık/Aydınlık moda geçiş olduğunda arka planı güncelle
            if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
                updateGradientBackground()
            }
        }

        // Gradient arka planı güncelleyen fonksiyon
         func updateGradientBackground() {
            // Mevcut gradientleri kaldırıyoruz
            view.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
            
            // Modlara göre farklı renkler ayarlama
            let lightGradientColors = [UIColor(red: 0.0, green: 0.90, blue: 0.46, alpha: 1.0).cgColor,
                                       UIColor(red: 0.0, green: 0.78, blue: 0.32, alpha: 1.0).cgColor]
            
            let darkGradientColors = [UIColor(red: 0.1, green: 0.2, blue: 0.1, alpha: 1.0).cgColor,
                                      UIColor(red: 0.0, green: 0.5, blue: 0.3, alpha: 1.0).cgColor]
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? darkGradientColors : lightGradientColors
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.frame = view.bounds
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
      /*  // Karanlık mod uyumlu gradient renkler
          let lightGreen = UIColor(red: 0.0, green: 0.90, blue: 0.46, alpha: 1.0)
          let darkGreen = UIColor(red: 0.0, green: 0.78, blue: 0.32, alpha: 1.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [lightGreen.cgColor , darkGreen.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        setupUIComponents()
       */
    }
    
    private func setupUIComponents() {
        view.addSubview(selectFileButton)
        view.addSubview(resultsStackView)
        view.addSubview(activityIndicator)
        view.addSubview(resultLabel)
 // ScrollView ve StackView ekleme
 view.addSubview(scrollView)
 scrollView.addSubview(resultsStackView)
        
        NSLayoutConstraint.activate([
            selectFileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectFileButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            selectFileButton.widthAnchor.constraint(equalToConstant: 200),
            selectFileButton.heightAnchor.constraint(equalToConstant: 60),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
                    
             // ScrollView kısıtlamaları
            scrollView.topAnchor.constraint(equalTo: selectFileButton.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             
             // StackView'in ScrollView içinde konumlandırılması
            resultsStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            resultsStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            resultsStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            resultsStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            resultsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            resultLabel.topAnchor.constraint(equalTo: selectFileButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        selectFileButton.addTarget(self, action: #selector(selectFile), for: .touchUpInside)
    }
    
    @objc private func showPermissionAlert() {
        let alertController = UIAlertController(
            title: "Dosya Erişimi İzni",
            message: "Bu uygulama, seçilen dosyayı analiz etmek için dosya erişimi izni gerektirir. Lütfen dosya seçmek için izin verin.",
            preferredStyle: .alert
        )
        
        let allowAction = UIAlertAction(title: "İzin Ver", style: .default) { [weak self] _ in
            self?.selectFile()
        }
        let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
        
        alertController.addAction(allowAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
   @objc private func selectFile() {
        
        // Butona basıldığında animasyon ekleme
           UIView.animate(withDuration: 0.1,
                          animations: {
                              self.selectFileButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                          },
                          completion: { _ in
                              UIView.animate(withDuration: 0.1) {
                                  self.selectFileButton.transform = CGAffineTransform.identity
                              }
                          })
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.zip])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    private func processZipFile(at zipFileURL: URL) {
        do {
            let fileManager = FileManager()
            let tempDirectoryURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
            try fileManager.createDirectory(at: tempDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            
            try fileManager.unzipItem(at: zipFileURL, to: tempDirectoryURL)
            
            let extractedFiles = try fileManager.contentsOfDirectory(at: tempDirectoryURL, includingPropertiesForKeys: nil)
            for fileURL in extractedFiles {
                if fileURL.pathExtension == "txt" {
                    performCalculation(from: fileURL)
                    break
                }
            }
        } catch {
            print("Zip dosyası işleme hatası: \(error.localizedDescription)")
            resultLabel.text = "Zip dosyası işlenemedi."
        }
    }
    
    private func performCalculation(from fileURL: URL) {
        do {
            let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
            let messageCounts = countMessages(from: fileContent)
            
            displayResults(results: messageCounts)
        } catch {
            resultLabel.text = "Dosya okunamadı."
        }
    }
    
    
    private func displayResults(results: [String: Int]) {
        resultLabel.isHidden = true
        activityIndicator.stopAnimating()
        selectFileButton.isEnabled = true
        
        // StackView'i temizleme
        resultsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Her kart için animasyonlu ekleme
        for (index, (user, count)) in results.enumerated() {
            let cardView = createCardView(user: user, count: count)
            resultsStackView.addArrangedSubview(cardView)
            
            // Kartı başlangıçta görünmez yap
            cardView.alpha = 0
            cardView.transform = CGAffineTransform(translationX: 0, y: 30) // Başlangıçta hafif aşağıda
            
            // Animasyonu başlat
            UIView.animate(
                withDuration: 0.4,
                delay: Double(index) * 0.2,
                options: [.curveEaseInOut],
                animations: {
                    cardView.alpha = 2
                    cardView.transform = .identity // Kartı orijinal konumuna getir
                },
                completion: nil
            )
        }
    }

    private func createCardView(user: String, count: Int) -> UIView {
        let cardView = UIView()
        
        // Dinamik kart rengi
        let cardBackgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(white: 0.2, alpha: 0.3) : UIColor(white: 1.0, alpha: 0.1)
        }
        cardView.backgroundColor = cardBackgroundColor
        
        cardView.layer.cornerRadius = 15
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "\(user): \(count) mesaj"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        // Dinamik metin rengi
        label.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 300),
            cardView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return cardView
    }
   /*
    private func createCardView(user: String, count: Int) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        cardView.layer.cornerRadius = 15
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "\(user): \(count) mesaj"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 300),
            cardView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return cardView
    } */
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        
        if selectedFileURL.startAccessingSecurityScopedResource() {
            defer { selectedFileURL.stopAccessingSecurityScopedResource() }
            
            processZipFile(at: selectedFileURL)
        }
    }
    
    private func countMessages(from content: String) -> [String: Int] {
        var userMessages = [String: Int]()
        
        let lines = content.components(separatedBy: .newlines)
        let messagePattern = #"^\[\d{1,2}\.\d{1,2}\.\d{4} \d{2}:\d{2}:\d{2}\] "#
        
        for line in lines {
            if line.isEmpty { continue }
            
            if let range = line.range(of: messagePattern, options: .regularExpression) {
                let messagePart = String(line[range.upperBound...]).trimmingCharacters(in: .whitespaces)
                
                let userAndMessage = messagePart.components(separatedBy: ":")
                if userAndMessage.count > 1 {
                    let user = userAndMessage[0].trimmingCharacters(in: .whitespaces)
                    userMessages[user, default: 0] += 1
                }
            }
        }
        
        return userMessages
    }
}


