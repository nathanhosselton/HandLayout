import UIKit

extension CGRect {
    init(square length: CGFloat) {
        self.init(size: CGSize(square: length))
    }

    init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }

    init(width: CGFloat, height: CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }

    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension CGSize {
    init(square length: CGFloat) {
        self.init(width: length, height: length)
    }
}

private var defaultLabelFont: UIFont { return UIFont(size: UIFont.labelFontSize) }

extension UILabel {
    
    /// this variant does not apply Handmade defaults as yet
    convenience init(text: NSAttributedString) {
        self.init(frame: .zero)
        attributedText = text
        sizeToFit()
    }

    convenience init(text string: String, font: FontConvertible = defaultLabelFont, color: UIColor = UIColorTextDefault, kerning: CGFloat? = nil) {
        if kerning == nil {         // avoid using attributedStrings if possible
            self.init(frame: .zero) // since it is a blackbox of who knows what
            text = string
            self.font = font.font
            textColor = color
            sizeToFit()
        } else {
            var attrs: [String: Any] = [:]
            attrs[NSKernAttributeName] = kerning
            attrs[NSFontAttributeName] = font.font
            attrs[NSForegroundColorAttributeName] = color
            self.init(text: NSAttributedString(string: string, attributes: attrs))
        }
    }
    
    convenience init(lines: [String], font: FontConvertible = defaultLabelFont) {
        self.init(frame: .zero)
        text = lines.joined(separator: "\n")
        self.font = font.font
        textColor = UIColorTextDefault
        numberOfLines = lines.count
        sizeToFit()
    }
}


extension UIView {
    convenience init(color: UIColor) {
        self.init(frame: .zero)
        backgroundColor = color
    }

    var width: CGFloat {
        get { return bounds.width }
        set { bounds.size.width = newValue }
    }
    var height: CGFloat {
        get { return bounds.height }
        set { bounds.size.height = newValue }
    }

    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    /// *does not* adjust height
    var maxY: CGFloat {
        get {
            return frame.maxY
        }
        set {
            y = newValue - height
        }
    }
    /// *does not* adjust width
    var maxX: CGFloat {
        get {
            return frame.maxX
        }
        set {
            x = newValue - width
        }
    }
    var size: CGSize {
        get {
            return bounds.size
        }
        set {
            bounds.size = newValue
        }
    }

    var origin: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }

    var viewController: UIViewController? {
        var vc: UIResponder! = next
        while vc != nil {
            vc = vc.next
            if let vc = vc as? UIViewController {
                return vc
            }
        }
        return nil
    }

    /// forces a view to not exceed the limits of another view with an optional margin
    func clamp(to template: UIView, margin: CGFloat = 0) {
        let maxW = template.width - margin * 2
        let maxH = template.height - margin * 2
        if width > maxW { width = maxW }
        if height > maxH { height = maxH }
    }
}

extension Int {
    var f: CGFloat { return CGFloat(self) }
}

extension UInt32 {
    var f: CGFloat { return CGFloat(self) }
}

let ⅓ = 1.f / 3.f
let ⅔ = 2.f / 3.f

extension UIImage {
    func size(forHeight newHeight: CGFloat) -> CGSize {
        var sz = size
        sz.width = (newHeight / sz.height) * sz.width
        sz.height = newHeight
        return sz
    }
    func size(forWidth newWidth: CGFloat) -> CGSize {
        var sz = size
        sz.height = (newWidth / sz.width) * sz.height
        sz.width = newWidth
        return sz
    }
}

extension UIImageView {
    func size(forHeight newHeight: CGFloat) -> CGSize {
        return image?.size(forHeight: newHeight) ?? .zero
    }
    func size(forWidth newWidth: CGFloat) -> CGSize {
        return image?.size(forWidth: newWidth) ?? .zero
    }
}

extension UIViewController {
    var width: CGFloat { return view.width }
    var height: CGFloat { return view.height }

    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
    }

    var activeViewController: UIViewController {
        switch self {
        case let nc as UINavigationController:
            if let vc = nc.visibleViewController {
                return vc.activeViewController
            } else {
                return nc
            }
        case let tbc as UITabBarController:
            if let vc = tbc.selectedViewController {
                return vc.activeViewController
            } else {
                return tbc
            }
        default:
            if let pvc = presentedViewController {
                return pvc.activeViewController
            } else {
                return self
            }
        }
    }

    var bounds: CGRect {
        return view.bounds
    }
}

extension UIEdgeInsets: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = UIEdgeInsets(CGFloat(value))
    }
}

extension UIEdgeInsets: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Float) {
        self = UIEdgeInsets(CGFloat(value))
    }
}

extension UIEdgeInsets {
    init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    init(bottom: CGFloat) {
        self.init(top: 0, left: 0, bottom: bottom, right: 0)
    }

    init(dx: CGFloat, dy: CGFloat) {
        self.init(top: dy, left: dx, bottom: -dy, right: -dx)
    }

    
    init(dy: CGFloat) {
        self.init(dx: 0, dy: dy)
    }

    init(dx: CGFloat) {
        self.init(dx: dx, dy: 0)
    }
}


extension CALayer {
    var x: CGFloat {
        get { return frame.origin.x }
        set { frame.origin.x = newValue }
    }
    var y: CGFloat {
        get { return frame.origin.y }
        set { frame.origin.y = newValue }
    }
}


enum Shape: ExpressibleByIntegerLiteral {
    case square
    case curved(CornerRadius)

    enum CornerRadius {
        case auto
        case value(CGFloat)
    }

    init(integerLiteral value: Int) {
        self = .curved(.value(CGFloat(value)))
    }
}


extension UIButton {
    convenience init(title: String, font: FontConvertible = UIFont(size: UIFont.buttonFontSize), tintColor fg: UIColor? = nil, backgroundColor bg: UIColor, shape: Shape = .curved(.auto)) {
        self.init()
        
        setTitle(title, for: .normal)
        tintColor = fg
        titleLabel?.font = font.font
        
        sizeToFit()
        
        bounds.size.width += 20
        
        switch shape {
        case .square:
            // we still set an image as otherwise you don't get automatic touch-highlights
            setBackgroundImage(UIImage(color: bg), for: .normal)
        case .curved(.auto):
            let radius = min(height, width) / 2
            setBackgroundImage(UIImage.make(color: bg, cornerRadius: radius), for: .normal)
        case .curved(.value(let radius)):
            setBackgroundImage(UIImage.make(color: bg, cornerRadius: radius), for: .normal)
        }
    }
}


extension UIImage {
    convenience init(color: UIColor) {
        self.init(color: color, size: CGSize(square: 1))
    }

    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContext(size)
        guard let ctx = UIGraphicsGetCurrentContext() else { fatalError() }
        ctx.setFillColor(color.cgColor)
        ctx.fill(CGRect(size: size))

        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = img?.cgImage else { fatalError() }
        
        self.init(cgImage: cgImage)
    }

    static func make(color: UIColor, cornerRadius: CGFloat) -> UIImage {
        let minEdgeSize = cornerRadius * 2 + 1
        let rect = CGRect(square: minEdgeSize)

        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        roundedRect.lineWidth = 0

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.f);
        color.setFill()
        roundedRect.fill()
        roundedRect.stroke()
        roundedRect.addClip()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let img = img {
            return img.resizableImage(withCapInsets: UIEdgeInsets(cornerRadius))
        } else {
            return UIImage()
        }
    }
}


class UIInsetter: UIView {
    let insets: UIEdgeInsets

    convenience init(wrap gift: UIView, margin: CGFloat) {
        self.init(wrap: gift, insets: UIEdgeInsets(margin))
    }

    init(wrap gift: UIView, insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: UIEdgeInsetsInsetRect(gift.frame, insets))
        addSubview(gift)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        for view in subviews {
            view.frame = UIEdgeInsetsInsetRect(bounds, insets)
        }
    }
}


extension CGRect {
    /// because we provide a convertible for UIEdgeInsets you can do eg: `rect.inset(by: 10)`
    func inset(by insets: UIEdgeInsets) -> CGRect {
        return UIEdgeInsetsInsetRect(self, insets)
    }
}


extension CGAffineTransform {
    init(translation pt: CGPoint) {
        self.init(translationX: pt.x, y: pt.y)
    }
}


extension UIView {
    func autoCoverSuperView() {
        guard let superview = self.superview else { return }

        // otherwise we will get crashy-conflicts
        translatesAutoresizingMaskIntoConstraints = false

        let constraints = [NSLayoutAttribute.left, .right, .top, .bottom].map {
            NSLayoutConstraint(item: self, attribute: $0, relatedBy: .equal, toItem: superview, attribute: $0, multiplier: 1, constant: 0)
        }
        superview.addConstraints(constraints)
    }
}


func *(size: CGSize, factor: CGFloat) -> CGSize {
    return CGSize(width: size.width * factor, height: size.height * factor)
}

func *=(lhs: inout CGSize, rhs: CGFloat) {
    lhs = lhs * rhs
}

func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let rv = NSMutableAttributedString(attributedString: lhs)
    rv.append(rhs)
    return rv
}


extension NSAttributedString {
    convenience init(string: String, font: FontConvertible = UIFont(), color: UIColor = UIColorTextDefault, kerning: CGFloat? = nil) {
        var attrs: [String: Any] = [
            NSFontAttributeName: font.font,
            NSForegroundColorAttributeName: color
        ]
        attrs[NSKernAttributeName] = kerning
        self.init(string: string, attributes: attrs)
    }
}


extension UIDevice {
    enum Model {
        case classic  // original iPhone until iPhone 5
        case SE       // iPhone 5
        case normal   // iPhone 6
        case plus
        case unknown  // TEH FUTURE
    }

    class var model: Model {
        let sz = UIScreen.main.bounds.size
        switch (sz.width, sz.height) {
        case (320, 480): return .classic
        case (320, 568): return .SE
        case (375, 667): return .normal
        case (414, 736): return .plus
        default:
            return .unknown
        }
    }
}


extension UILabel {
    func size(forHeight newHeight: CGFloat) -> CGSize {
        fatalError()
    }

    func size(forWidth newWidth: CGFloat) -> CGSize {
        guard let str = attributedText else { fatalError("Unsupported code path, please fork and implement") }
        let size = CGSize(width: newWidth, height: 10_000)
        let opts: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect = str.boundingRect(with: size, options: opts, context: nil)
        return rect.size
    }
}


extension UIFont {
    func size(forWidth width: CGFloat, text: String) -> CGSize {
        let bounds = CGSize(width: width, height: 100_000)
        return text.boundingRect(with: bounds, options: .usesLineFragmentOrigin, attributes: [
            NSFontAttributeName: self
        ], context: nil).size
    }
}


//MARK: Defaults

var UIColorTextDefault: UIColor!
var UIFontWeightDefault: UIFont.Weight = .medium
var UIFontNameForWeight: (UIFont.Weight) -> String = { _ in UIFont.systemFont(ofSize: 13).fontName }

extension UIFont {
    enum Weight {
        case light, medium, heavy, black
    }
    
    convenience init(size: CGFloat = UIFont.systemFontSize, weight: Weight = UIFontWeightDefault) {
        self.init(name: UIFontNameForWeight(weight), size: size)!
    }
}



protocol FontConvertible {
    var font: UIFont { get }
}

extension Double: FontConvertible {
    var font: UIFont { return UIFont(size: CGFloat(self)) }
}

extension CGFloat: FontConvertible {
    var font: UIFont { return UIFont(size: self) }
}

extension UIFont: FontConvertible {
    var font: UIFont { return self }
}

extension Int: FontConvertible {
    var font: UIFont { return UIFont(size: CGFloat(self)) }
}



extension UIColor {
    func adjusted(alpha: CGFloat) -> UIColor {
        var (r, g, b) = (0.f, 0.f, 0.f)
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
