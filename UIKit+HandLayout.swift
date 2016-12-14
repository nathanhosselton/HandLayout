import UIKit

extension CGRect {
    public init(square length: CGFloat) {
        self.init(size: CGSize(square: length))
    }

    public init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }

    public init(width: CGFloat, height: CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }

    public var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension CGSize {
    public init(square length: CGFloat) {
        self.init(width: length, height: length)
    }

    public static var max: CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    }
}

private var defaultLabelFont: UIFont { return UIFont(size: UIFont.labelFontSize) }

extension UILabel {
    
    /// this variant does not apply Handmade defaults TODO: FIXME: ANDTHAT
    public convenience init(text: NSAttributedString) {
        self.init(frame: .zero)
        attributedText = text
        sizeToFit()
    }

    public convenience init(text string: String, font: FontConvertible = defaultLabelFont, color: UIColor = UIColorTextDefault, kerning: CGFloat? = UIKerningDefault) {
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
    
    public convenience init(lines: [String], font: FontConvertible = defaultLabelFont, kerning: CGFloat? = UIKerningDefault) {
        let string = lines.joined(separator: "\n")

        self.init(frame: .zero)

        if let kerning = kerning {
            attributedText = NSAttributedString(string: string, font: font, kerning: kerning)
        } else {
            text = string
            self.font = font.font
            textColor = UIColorTextDefault
        }
        numberOfLines = lines.count
        sizeToFit()
    }
}


extension UIView {
    public convenience init(width: CGFloat = UIScreen.main.bounds.width, height: CGFloat) {
        self.init(frame: CGRect(width: width, height: height))
    }

    public convenience init(color: UIColor) {
        self.init(frame: .zero)
        backgroundColor = color
    }

    public var width: CGFloat {
        get { return bounds.width }
        set { bounds.size.width = newValue }
    }
    public var height: CGFloat {
        get { return bounds.height }
        set { bounds.size.height = newValue }
    }

    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    /// *does not* adjust height
    public var maxY: CGFloat {
        get {
            return frame.maxY
        }
        set {
            y = newValue - height
        }
    }
    /// *does not* adjust width
    public var maxX: CGFloat {
        get {
            return frame.maxX
        }
        set {
            x = newValue - width
        }
    }
    public var size: CGSize {
        get {
            return bounds.size
        }
        set {
            bounds.size = newValue
        }
    }

    public var origin: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }

    public var viewController: UIViewController? {
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
    public func clamp(to template: UIView, margin: CGFloat = 0) {
        let maxW = template.width - margin * 2
        let maxH = template.height - margin * 2
        if width > maxW { width = maxW }
        if height > maxH { height = maxH }
    }
}

extension Int {
    public var f: CGFloat { return CGFloat(self) }
}

extension UInt32 {
    public var f: CGFloat { return CGFloat(self) }
}

public let ⅓ = 1.f / 3.f
public let ⅔ = 2.f / 3.f

extension UIImage {
    public func size(forHeight newHeight: CGFloat) -> CGSize {
        var sz = size
        sz.width = (newHeight / sz.height) * sz.width
        sz.height = newHeight
        return sz
    }
    public func size(forWidth newWidth: CGFloat) -> CGSize {
        var sz = size
        sz.height = (newWidth / sz.width) * sz.height
        sz.width = newWidth
        return sz
    }
}

extension UIImageView {
    public func size(forHeight newHeight: CGFloat) -> CGSize {
        return image?.size(forHeight: newHeight) ?? .zero
    }
    public func size(forWidth newWidth: CGFloat) -> CGSize {
        return image?.size(forWidth: newWidth) ?? .zero
    }
}

extension UIViewController {
    public var width: CGFloat { return view.width }
    public var height: CGFloat { return view.height }

    public var insets: UIEdgeInsets {
        return UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
    }

    public var activeViewController: UIViewController {
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

    public var bounds: CGRect {
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
    public init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    public init(bottom: CGFloat) {
        self.init(top: 0, left: 0, bottom: bottom, right: 0)
    }

    public init(top: CGFloat) {
        self.init(top: top, left: 0, bottom: 0, right: 0)
    }

    public init(dx: CGFloat, dy: CGFloat) {
        self.init(top: dy, left: dx, bottom: -dy, right: -dx)
    }
    
    public init(dy: CGFloat) {
        self.init(dx: 0, dy: dy)
    }

    public init(dx: CGFloat) {
        self.init(dx: dx, dy: 0)
    }
}


extension CALayer {
    public var x: CGFloat {
        get { return frame.origin.x }
        set { frame.origin.x = newValue }
    }
    public var y: CGFloat {
        get { return frame.origin.y }
        set { frame.origin.y = newValue }
    }
    public var width: CGFloat {
        get { return bounds.size.width }
        set { bounds.size.width = newValue }
    }
}


public enum Shape: ExpressibleByIntegerLiteral {
    case square
    case curved(CornerRadius)

    public enum CornerRadius {
        case auto
        case value(CGFloat)
    }

    public init(integerLiteral value: Int) {
        self = .curved(.value(CGFloat(value)))
    }
}


extension UIButton {
    public convenience init(title: String, font: FontConvertible = UIFont(size: UIFont.buttonFontSize), titleColor fg: UIColor? = nil, backgroundColor bg: UIColor, shape: Shape = .curved(.auto), kerning: CGFloat? = UIKerningDefault)
    {
        self.init()

        setTitleColor(fg, for: .normal)
        setAttributedTitle(NSAttributedString(string: title, font: font, kerning: kerning), for: .normal)
        sizeToFit()
        
        bounds.size.width += 20  //FIXME arbituary
        
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
    public convenience init(color: UIColor) {
        self.init(color: color, size: CGSize(square: 1))
    }

    public convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContext(size)
        guard let ctx = UIGraphicsGetCurrentContext() else { fatalError() }
        ctx.setFillColor(color.cgColor)
        ctx.fill(CGRect(size: size))

        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = img?.cgImage else { fatalError() }
        
        self.init(cgImage: cgImage)
    }

    public static func make(color: UIColor, cornerRadius: CGFloat) -> UIImage {
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


public class UIInsetter: UIView {
    private let subview: UIView
    private let insets: UIEdgeInsets

    public convenience init(wrap gift: UIView, margin: CGFloat) {
        self.init(wrap: gift, insets: UIEdgeInsets(margin))
    }

    public init(wrap subview: UIView, insets: UIEdgeInsets) {
        self.subview = subview
        self.insets = insets
        super.init(frame: UIEdgeInsetsInsetRect(subview.frame, insets))
        addSubview(subview)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        subview.frame = UIEdgeInsetsInsetRect(bounds, insets)
    }

    public override func becomeFirstResponder() -> Bool {
        return subview.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        return subview.resignFirstResponder()
    }
}


extension CGRect {
    /// because we provide a convertible for UIEdgeInsets you can do eg: `rect.inset(by: 10)`
    public func inset(by insets: UIEdgeInsets) -> CGRect {
        return UIEdgeInsetsInsetRect(self, insets)
    }

    public func inset(_ edges: UIRectEdge, by: CGFloat) -> CGRect {
        var insets = UIEdgeInsets()
        if edges.contains(.top) { insets.top = by }
        if edges.contains(.bottom) { insets.bottom = by }
        if edges.contains(.left) { insets.left = by }
        if edges.contains(.right) { insets.right = by }
        return UIEdgeInsetsInsetRect(self, insets)
    }
}


extension CGAffineTransform {
    public init(translation pt: CGPoint) {
        self.init(translationX: pt.x, y: pt.y)
    }
}


extension UIView {
    public func autoCoverSuperView() {
        guard let superview = self.superview else { return }

        // otherwise we will get crashy-conflicts
        translatesAutoresizingMaskIntoConstraints = false

        let constraints = [NSLayoutAttribute.left, .right, .top, .bottom].map {
            NSLayoutConstraint(item: self, attribute: $0, relatedBy: .equal, toItem: superview, attribute: $0, multiplier: 1, constant: 0)
        }
        superview.addConstraints(constraints)
    }
}


public func *(size: CGSize, factor: CGFloat) -> CGSize {
    return CGSize(width: size.width * factor, height: size.height * factor)
}

public func *=(lhs: inout CGSize, rhs: CGFloat) {
    lhs = lhs * rhs
}

public func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let rv = NSMutableAttributedString(attributedString: lhs)
    rv.append(rhs)
    return rv
}

public func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func -=(lhs: inout CGPoint, rhs: CGPoint) {
    lhs = lhs - rhs
}



extension NSAttributedString {
    public convenience init(string: String, font: FontConvertible = UIFont(), color: UIColor = UIColorTextDefault, kerning: CGFloat? = UIKerningDefault) {
        var attrs: [String: Any] = [
            NSFontAttributeName: font.font,
            NSForegroundColorAttributeName: color
        ]
        attrs[NSKernAttributeName] = kerning
        self.init(string: string, attributes: attrs)
    }
}


extension UIDevice {
    public enum Model {
        case classic  // original iPhone until iPhone 5
        case SE       // iPhone 5
        case normal   // iPhone 6
        case plus
        case unknown  // TEH FUTURE
    }

    public class var model: Model {
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
    public func size(forHeight newHeight: CGFloat) -> CGSize {
        fatalError()
    }

    public func size(forWidth newWidth: CGFloat) -> CGSize {
        guard let str = attributedText else { fatalError("Unsupported code path, please fork and implement") }
        let size = CGSize(width: newWidth, height: 10_000)
        let opts: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect = str.boundingRect(with: size, options: opts, context: nil)
        return rect.size
    }
}


extension UIFont {
    public func size(forWidth width: CGFloat, text: String) -> CGSize {
        let bounds = CGSize(width: width, height: 100_000)
        return text.boundingRect(with: bounds, options: .usesLineFragmentOrigin, attributes: [
            NSFontAttributeName: self
        ], context: nil).size
    }
}


//MARK: Defaults

public var UIColorTextDefault: UIColor!
public var UIFontWeightDefault: UIFont.Weight = .medium
public var UIFontNameForWeight: (UIFont.Weight) -> String = { _ in UIFont.systemFont(ofSize: 13).fontName }
public var UIKerningDefault: CGFloat?

extension UIFont {
    public enum Weight {
        case light, medium, heavy, black
    }
    
    public convenience init(size: CGFloat = UIFont.systemFontSize, weight: Weight = UIFontWeightDefault) {
        self.init(name: UIFontNameForWeight(weight), size: size)!
    }
}



public protocol FontConvertible {
    var font: UIFont { get }
}

extension Double: FontConvertible {
    public var font: UIFont { return UIFont(size: CGFloat(self)) }
}

extension CGFloat: FontConvertible {
    public var font: UIFont { return UIFont(size: self) }
}

extension UIFont: FontConvertible {
    public var font: UIFont { return self }
}

extension Int: FontConvertible {
    public var font: UIFont { return UIFont(size: CGFloat(self)) }
}



extension UIColor {
    public func adjusted(alpha: CGFloat) -> UIColor {
        var (r, g, b) = (0.f, 0.f, 0.f)
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}



extension NSCoder {
    public static var null: NSCoder {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.finishEncoding()
        return NSKeyedUnarchiver(forReadingWith: data as Data)
    }
}

