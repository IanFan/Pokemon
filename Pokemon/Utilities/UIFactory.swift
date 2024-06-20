//
//  UIFactory.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit

class UIFactory {
    static func getScale() -> CGFloat {
        return getWindowSize().width / 375
    }

    static func getWindowSize() -> CGSize {
        return UIApplication.shared.keyWindow?.bounds.size ?? UIScreen.main.bounds.size
    }

    static func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }

    static func createImage(name: String, tintColor: UIColor? = nil, corner: CGFloat = 0) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.image = getImage(named: name)
        
        if let tintColor = tintColor {
            imageView.tintColor = tintColor
        }
        
        if corner > 0 {
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = corner
        }

        return imageView
    }

    static func createLabel(size: CGFloat, text: String, color: UIColor, font: FontEnum, textAlignment: NSTextAlignment = .natural, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = color
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        if font == .DEFAULT {
            label.font = UIFont.systemFont(ofSize: size)
        } else {
            label.font = UIFont(name: font.rawValue, size: size)
        }

        return label
    }

    static func createScrollView(color: UIColor, corner: CGFloat = 0) -> UIScrollView {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        
        if corner > 0 {
            view.layer.cornerRadius = corner
            view.clipsToBounds = true
        }
        
        return view
    }

    static func createProgressView(colorStart: UIColor, colorEnd: UIColor, width: CGFloat, height: CGFloat, corner: CGFloat, isLeftToRight: Bool = false) -> UIProgressView {
        let progressUpload = UIProgressView()
        progressUpload.translatesAutoresizingMaskIntoConstraints = false
        progressUpload.isUserInteractionEnabled = false
        
        if corner > 0 {
            progressUpload.layer.cornerRadius = corner
            progressUpload.clipsToBounds = true
        }
        
        let progressImage = UIImage.gradientImage(colorStart: colorStart, colorEnd: colorEnd, width: width, height: height, corner: corner, isLeftToRight: isLeftToRight)
        progressUpload.progressImage = progressImage
        
        progressUpload.setProgress(0, animated: false)
        return progressUpload
    }

    static func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Picture"
        return searchBar
    }

    static func getFont(font: FontEnum = .DEFAULT, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func createTextView(size: CGFloat, text: String, color: UIColor, bgColor: UIColor = .clear, font: FontEnum = .DEFAULT, corner: CGFloat = 0) -> UITextView {
        let textView = UITextView()
        setupTextView(textView: textView, size: size, text: text, color: color, bgColor: bgColor, font: font, corner: corner)
        return textView
    }

    static func setupTextView(textView: UITextView, size: CGFloat, text: String, color: UIColor, bgColor: UIColor = .clear, font: FontEnum = .DEFAULT, corner: CGFloat = 0) {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = text
        textView.textColor = color
        textView.backgroundColor = bgColor

        if font == .DEFAULT {
            textView.font = UIFont.systemFont(ofSize: size)
        } else {
            textView.font = UIFont(name: font.rawValue, size: size)
        }
        
        if corner > 0 {
            textView.layer.cornerRadius = corner
        }

        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
    }

    static func createTextView(size: CGFloat, text: String, color: UIColor, font: FontEnum) -> UITextView {
        let customFont: UIFont
        if font == .DEFAULT {
            customFont = UIFont.systemFont(ofSize: size)
        } else {
            customFont = UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = text
        textView.textColor = color
        textView.backgroundColor = UIColor.clear
        textView.font = customFont
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        
        return textView
    }

    static func createTextField(size: CGFloat, text: String, placeholderText: String, color: UIColor, placeholderColor: UIColor, bgColor: UIColor, font: FontEnum, alignment: NSTextAlignment = .left, corner: CGFloat = 0) -> UITextField {
        let paragraphStyle =  NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let customFont: UIFont
        if font == .DEFAULT {
            customFont = UIFont.systemFont(ofSize: size)
        } else {
            customFont = UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = text
        textField.textColor = color
        textField.backgroundColor = bgColor
        textField.font = customFont
        textField.textAlignment = alignment
        
        let attributes = [
            NSAttributedString.Key.font: customFont,
            NSAttributedString.Key.foregroundColor: placeholderColor,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        if corner > 0 {
            textField.layer.cornerRadius = corner
        }
        
        return textField
    }

    static func createSearchBar(barStyle: UIBarStyle, size: CGFloat, text: String, placeholderText: String, color: UIColor, textfieldColor: UIColor, placeholderColor: UIColor, bgColor: UIColor, glassColor: UIColor? = nil , font: FontEnum, alignment: NSTextAlignment = .left, corner: CGFloat = 0) -> UISearchBar {
        let paragraphStyle =  NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let customFont: UIFont
        if font == .DEFAULT {
            customFont = UIFont.systemFont(ofSize: size)
        } else {
            customFont = UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.barStyle = barStyle
        searchBar.backgroundColor = bgColor
        
        if let textField = searchBar.textField {
            textField.frame = CGRect(x: 0, y: 0, width: searchBar.frame.width, height: searchBar.frame.height)
            
            textField.text = text
            textField.textColor = color
            textField.backgroundColor = textfieldColor
            textField.font = customFont
            textField.textAlignment = alignment
            
            let attributes = [
                NSAttributedString.Key.font: customFont,
                NSAttributedString.Key.foregroundColor: placeholderColor,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
            
            if let glassColor = glassColor {
                let glassIconView = textField.leftView as? UIImageView
                glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
                glassIconView?.tintColor = glassColor
            }
        }
        
        if corner > 0 {
            searchBar.layer.cornerRadius = corner
        }
        
        return searchBar
    }

    static func createView(color: UIColor) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }

    static func createView(color: UIColor, corner: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.layer.cornerRadius = corner
        if borderWidth != 0 {
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = borderColor.cgColor
        }
        return view
    }

    static func createImageButton(name: String, tintColor: UIColor? = nil, contentmode: UIView.ContentMode? = .scaleAspectFit, autoConstraint: Bool = false, corner: CGFloat = 0) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = autoConstraint
        
        if let tintColor = tintColor {
            if let tintedImage = getImage(named: name)?.withRenderingMode(.alwaysTemplate) {
                button.setBackgroundImage(tintedImage, for: .normal)
            }
            button.tintColor = tintColor
        } else {
            button.setBackgroundImage(getImage(named: name), for: .normal)
        }
        if let contentmode = contentmode {
            button.imageView?.contentMode = contentmode
        }
        
        if corner > 0 {
            button.imageView?.layer.cornerRadius = corner
        }

        return button
    }

    static func createImageButton(image: UIImage) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(image, for: .normal)

        return button
    }

    static func getImage(named: String) -> UIImage? {
        guard named.count > 0 else {
            return nil
        }
        
        if let image = UIImage(named: named) {
            return image
        } else if let image = UIImage(systemName: named) {
            return image
        } else {
            return nil
        }
    }

    static func createTextButton(size: CGFloat, text: String, textColor: UIColor, bgColor: UIColor, font: FontEnum, uppercased: Bool = false) -> UIButton {
        let systemDefaultBtn: UIButton = UIButton(type: UIButton.ButtonType.system)
        systemDefaultBtn.translatesAutoresizingMaskIntoConstraints = false
        systemDefaultBtn.backgroundColor = bgColor

        systemDefaultBtn.setTitleColor(textColor, for: UIControl.State.normal)

        if uppercased {
            systemDefaultBtn.setTitle(text.uppercased(), for: UIControl.State.normal)
        } else {
            systemDefaultBtn.setTitle(text, for: UIControl.State.normal)
        }

        if font == .DEFAULT {
            systemDefaultBtn.titleLabel?.font = UIFont.systemFont(ofSize: size)
        } else {
            systemDefaultBtn.titleLabel?.font = UIFont(name: font.rawValue, size: size)
        }

        return systemDefaultBtn
    }

    static func createTextButton(type: UIButton.ButtonType = .system, size: CGFloat, text: String, textColor: UIColor, bgColor: UIColor, font: FontEnum = .DEFAULT, corner: CGFloat = 0) -> UIButton {
        let systemDefaultBtn: UIButton = UIButton(type: type)
        systemDefaultBtn.translatesAutoresizingMaskIntoConstraints = false
        systemDefaultBtn.backgroundColor = bgColor
        systemDefaultBtn.setTitle(text, for: UIControl.State.normal)
        systemDefaultBtn.setTitleColor(textColor, for: UIControl.State.normal)
        systemDefaultBtn.layer.cornerRadius = corner
        if font == .DEFAULT {
            systemDefaultBtn.titleLabel?.font = UIFont.systemFont(ofSize: size)
        } else {
            systemDefaultBtn.titleLabel?.font = UIFont(name: font.rawValue, size: size)
        }
        return systemDefaultBtn
    }

    static func addShadow(view: UIView, width: CGFloat, height: CGFloat, shadowOpacity: Float = 0.18, shadowRadius: CGFloat = 2.0, shadowColor: UIColor = UIColor.black) {
        view.layer.shadowOffset = CGSize(width: width, height: height)
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowColor = shadowColor.cgColor
    }

    static func createSegment(items: [String], selectedColor: UIColor, selectedTextColor: UIColor = .black, corner: CGFloat = 0) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentTintColor = selectedColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedTextColor], for: .selected)
        segmentedControl.layer.cornerRadius = corner
        return segmentedControl
    }

    static func createSwitch(color: UIColor) -> UISwitch {
        let switchView = UISwitch(frame: .zero)
        switchView.onTintColor = color.withAlphaComponent(0.5)
        switchView.thumbTintColor = color
        return switchView
    }

    static func createSwitch(onTintColor: UIColor, thumbTintColor: UIColor) -> UISwitch {
        let switchView = UISwitch(frame: .zero)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.onTintColor = onTintColor
        switchView.thumbTintColor = thumbTintColor
        return switchView
    }

    static func combineToAttText(texts: [String], sizes: [CGFloat], colors: [UIColor], fonts: [FontEnum]) -> NSAttributedString {
        let combination = NSMutableAttributedString()

        guard texts.count > 0,
            texts.count == sizes.count,
            texts.count == colors.count,
            texts.count == fonts.count else {
            print("combineText count Error")
            return combination
        }

        for i in 0 ..< texts.count {
            let text: String = texts[i]
            let size: CGFloat = sizes[i]
            let color: UIColor = colors[i]
            let f: FontEnum = fonts[i]
            if let font: UIFont = (f == FontEnum.DEFAULT) ? UIFont.systemFont(ofSize: size) : UIFont(name: f.rawValue, size: size) {
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: color,
                    .font: font,
                ]
                let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
                combination.append(attributedString)
            } else {
                print("combineText font Error")
            }
        }

        return combination
    }
    
    static func addGradient(view: UIView, colorStart: UIColor, colorEnd: UIColor, width: CGFloat, height: CGFloat, corner: CGFloat, isLeftToRight: Bool = false) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientLayer"
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.colors = [colorStart.cgColor, colorEnd.cgColor]
        if isLeftToRight {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        gradientLayer.cornerRadius = corner
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    static func addTopGradient(view: UIView, colorStart: UIColor, colorEnd: UIColor, width: CGFloat, height: CGFloat, corner: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradient.colors = [colorStart.cgColor, colorEnd.cgColor]
        gradient.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        gradient.cornerRadius = corner
        view.layer.insertSublayer(gradient, at: 0)
    }

    static func addGradient(view: UIView, c1: UIColor, c2: UIColor, c3: UIColor, width: CGFloat, height: CGFloat, corner: CGFloat, isLeftToRight: Bool = true) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientLayer"
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)

        gradientLayer.colors = [c1.cgColor, c2.cgColor, c3.cgColor]
        gradientLayer.locations = [0, 0.5, 1]

        if isLeftToRight {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }

        gradientLayer.cornerRadius = corner
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    static func addGradient(view: UIView, colorStart: UIColor, colorEnd: UIColor, width: CGFloat, height: CGFloat, startPoint: CGPoint, endPoint: CGPoint, corner: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.name = "gradientLayer"
        gradient.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradient.colors = [colorStart.cgColor, colorEnd.cgColor]

        gradient.startPoint = startPoint
        gradient.endPoint = endPoint

        gradient.cornerRadius = corner
        view.layer.insertSublayer(gradient, at: 0)
    }

    static func addBorderGradient(view: UIView, colorStart: UIColor, colorEnd: UIColor, width: CGFloat, height: CGFloat, corner: CGFloat, borderWidth: CGFloat, strokeColor: UIColor = .black) {
        let gradient = CAGradientLayer()
        gradient.name = "gradientLayer"
        gradient.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
        gradient.colors = [colorStart.cgColor, colorEnd.cgColor]

        let shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)), cornerRadius: corner).cgPath
        shape.lineWidth = borderWidth
        shape.strokeColor = strokeColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        view.layer.addSublayer(gradient)
    }

    static func roundCorners(view: UIView, cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))

        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
    
    static func getNotchTop() -> CGFloat {
        let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        return topPadding
    }

    static func getSafeAreaTop() -> CGFloat {
        let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        return topPadding
    }

    static func getSafeAreaBottom() -> CGFloat {
        let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottomPadding
    }

    static func addBorder(view: UIView, color: Int, borderWidth: CGFloat, corner: CGFloat) {
        view.layer.cornerRadius = corner
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = UIColor(rgb: color).cgColor
    }
    
    static func shadow(layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false
    }

    static func createCollectionView(isHorizontal: Bool = true, headerHeight: CGFloat = 0, showScrollBar: Bool = false, corner: CGFloat = 0) -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        if isHorizontal {
            flowLayout.scrollDirection = .horizontal

        } else {
            flowLayout.scrollDirection = .vertical
        }

        if headerHeight > 0 {
            flowLayout.headerReferenceSize = CGSize(width: getWindowSize().width, height: headerHeight)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.scrollsToTop = true
        collectionView.showsVerticalScrollIndicator = showScrollBar
        collectionView.showsHorizontalScrollIndicator = showScrollBar
        
        if corner > 0 {
            collectionView.layer.cornerRadius = corner
        }
        
        return collectionView
    }

    static func getStringWidth(_ string: String, fontSize: CGFloat, fontEnum: FontEnum) -> CGFloat {
        let font: UIFont = UIFont(name: fontEnum.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        
        let attributes = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: string, attributes: attributes)
            
        let maxWidth = CGFloat.greatestFiniteMagnitude
        let maxSize = CGSize(width: maxWidth, height: font.lineHeight)
        let boundingRect = attributedText.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        return boundingRect.width
        
    //    let fontAttributes = [NSAttributedString.Key.font: font]
    //    let size = (string as NSString).size(withAttributes: fontAttributes)
    //    return size.width
    }

    static func getTextRectSize(text: String, fontEnum: FontEnum, fontSize: CGFloat, fixedWidth: CGFloat) -> CGSize {
        let font = UIFont(name: fontEnum.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let maxSize = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = [NSAttributedString.Key.font: font]

        let boundingRect = NSString(string: text).boundingRect(with: maxSize, options: options, attributes: attributes, context: nil)
        let rectSize = boundingRect.size
        return rectSize
    }

    static func getFullscreenFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: getWindowSize().width, height: getWindowSize().height)
    }
    
    static func createCombineImage(named: String, x: CGFloat = 0, y: CGFloat = 0, w: CGFloat = 0, h: CGFloat = 0) -> NSAttributedString {
        let image = NSTextAttachment()
        image.image = getImage(named: named)
        image.bounds = CGRect(x: x, y: y, width: w, height: h)
        return NSAttributedString(attachment: image)
    }

    static func createCombineText(text: String, color: UIColor, size: CGFloat, font: FontEnum, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        let attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: getFont(font: font, size: size),
            .paragraphStyle: paragraph
        ]
        let result = NSMutableAttributedString(string: text, attributes: attributes1)
        return result
    }

    static func createCombineText(text: String, color: UIColor, size: CGFloat, font: FontEnum, strokeWidth: CGFloat, strokeColor: UIColor) -> NSMutableAttributedString {
        let attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: getFont(font: font, size: size),
            .strokeWidth: strokeWidth,
            .strokeColor: strokeColor,
        ]
        let result = NSMutableAttributedString(string: text, attributes: attributes1)
        return result
    }

    static func drawDashLine(lineView: UIView, lineLength: CGFloat, lineSpacing: CGFloat, lineColor: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = lineView.bounds
        //        只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        //        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = lineColor.cgColor

        shapeLayer.lineWidth = lineView.frame.size.height
        shapeLayer.lineJoin = .round

        shapeLayer.lineDashPattern = [NSNumber(value: Int(lineLength)), NSNumber(value: Int(lineSpacing))]

        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: lineView.frame.size.width, y: 0))

        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
    }

    static func createIndicator(style: UIActivityIndicatorView.Style = .medium, color: UIColor? = nil) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        if let color = color {
            indicator.color = color
        }
        return indicator
    }

    static func removeGradient(view: UIView) {
        view.layer.sublayers?.forEach {
            if $0.name == "gradientLayer" {
                $0.removeFromSuperlayer()
            }
        }
    }

    static func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    static func getSafeAreaHeight(view: UIView) -> CGFloat {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        print("safe Height = \(height)")
        return height
    }

    static func getSafeAreaTop(view: UIView) -> CGFloat {
        let guide = view.safeAreaLayoutGuide
        let top = guide.layoutFrame.origin.y
        print("safe top = \(top)")
        return top
    }

    static func isPad() -> Bool{
        if(UIDevice.current.userInterfaceIdiom == .pad){
            return true
        }
        return false
    }

    static func isShortScreen() -> Bool { // protrait only
        let isShortScreen = isPad() || (getWindowSize().width / getWindowSize().height) >= 0.55
        // screen w/h
        // ip8  0.562
        // ip12 0.46
        // ipad 0.74
        
        return isShortScreen
    }

    static func isRightToLeftUI() -> Bool {
        let isRightToLeft: Bool = UIApplication.shared.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.rightToLeft
        return isRightToLeft
    }

    static func getWindow() -> UIWindow? {
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            return window
        }
        return nil
    }

    static func getCustomFontNames(fontFileNames: [String]) -> [String : String] {
        var dic: [String : String] = Dictionary()
        
        for fontFileName in fontFileNames {
            if let fonstScriptName = handleGetFontName(fontFileName: fontFileName, fontType: "ttf") {
                dic[fontFileName] = fonstScriptName
            } else if let fonstScriptName = handleGetFontName(fontFileName: fontFileName, fontType: "otf") {
                dic[fontFileName] = fonstScriptName
            }
        }
        
        return dic
    }

    static func handleGetFontName(fontFileName: String, fontType: String = "ttf") -> String? {
        if let urlpath = Bundle.main.path(forResource: fontFileName, ofType: fontType) {
            let url = NSURL.fileURL(withPath: urlpath)
            if let dataProvider = CGDataProvider(url: url as CFURL),
                let cgFont = CGFont(dataProvider),
                let cgFontScriptName = cgFont.postScriptName {
                let fonstScriptName = String(cgFontScriptName as NSString)
                
                var error: Unmanaged<CFError>?
                if CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) == true {
                    return fonstScriptName
                } else {
                    if let _ = UIFont(name: fonstScriptName, size: 10) {
                        return fonstScriptName
                    } else {
                        print("*** Error getCustomFontNames:\(fontFileName)")
                    }
                }
            }
        }
        return nil
    }

    static func imageFromLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage ?? UIImage()
    }

    static func applyGradientOnView(view: UIView, colors: [UIColor], direction: String, size: CGSize) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientLayer"
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        var cgColors = [CGColor]()
        colors.forEach {
            cgColors.append($0.cgColor)
        }
        gradientLayer.colors = cgColors
        gradientLayer.locations = [0, 0.5, 1]

        switch direction {
        case "上-下":
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        case "左-右":
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case "左上-右下":
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        default:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        }
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

class TopCornerImageView: UIImageView {
    var radius: CGFloat = 0.0
    init(image: UIImage?, radius: CGFloat) {
        super.init(image: image)
        self.radius = radius
        self.image = image
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: radius)
    }
}

class TopCornerView: UIView {
    var radius: CGFloat = 0.0

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: radius)
    }
}

class CornerTextView: UITextView {
    var radius: CGFloat = 0.0
    var rectCorner: UIRectCorner = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: rectCorner, radius: radius)
    }
}

class BottomCornerView: UIView {
    var radius: CGFloat = 0.0

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomLeft, .bottomRight], radius: radius)
    }
}

class LeftCornerView: UIView {
    var radius: CGFloat = 0.0

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .bottomLeft], radius: radius)
    }
}

class BottomRightCornerView: UIView {
    var radius: CGFloat = 0.0

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomRight], radius: radius)
    }
}

class TopRightCornerView: UIView {
    var radius: CGFloat = 0.0

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topRight], radius: radius)
    }
}

class UpperLeftCornerView: UIView {
    var radius: CGFloat = 0.0

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft], radius: radius)
    }
}

