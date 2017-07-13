import UIKit

enum Sentiment {
  case neutral
  case positive
  case negative

  var emoji: String {
    switch self {
    case .neutral:
      return "😐"
    case .positive:
      return "😃"
    case .negative:
      return "😔"
    }
  }

  var color: UIColor? {
    switch self {
    case .neutral:
      return UIColor(named: "NeutralColor")
    case .positive:
      return UIColor(named: "PositiveColor")
    case .negative:
      return UIColor(named: "NegativeColor")
    }
  }
}
