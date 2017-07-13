import UIKit

final class ViewController: UIViewController {
  private lazy var textView: UITextView = self.makeTextView()
  private lazy var accessoryView = UIView()
  private lazy var resultLabel: UILabel = self.makeResultLabel()
  private lazy var clearButton: UIButton = self.makeClearButton()

  private let padding = CGFloat(16)
  private var textViewBottomConstraint: NSLayoutConstraint?

  private let classificationService = ClassificationService()


  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Sentiment Analysis".uppercased()
    view.backgroundColor = UIColor(named: "BackgroundColor")
    view.addSubview(textView)

    accessoryView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
    accessoryView.addSubview(resultLabel)
    accessoryView.addSubview(clearButton)
    textView.inputAccessoryView = accessoryView

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardDidShow(notification:)),
      name: .UIKeyboardDidShow,
      object: nil
    )

    setupConstraints()
    show(sentiment: .neutral)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textView.becomeFirstResponder()
  }

  // MARK: - Data

  private func show(sentiment: Sentiment) {
    accessoryView.backgroundColor = sentiment.color
    resultLabel.text = sentiment.emoji
  }

  // MARK: - Actions

  @objc private func keyboardDidShow(notification: NSNotification) {
    let frameObject = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject
    if let keyboardRect = frameObject.cgRectValue {
      textViewBottomConstraint?.constant = -keyboardRect.size.height - padding
      view.layoutIfNeeded()
    }
  }

  @objc private func clearButtonDidTouchUpInside() {
    textView.text = ""
  }
}

// MARK: - Factory

private extension ViewController {
  func makeTextView() -> UITextView {
    let textView = UITextView()
    textView.layer.cornerRadius = 8
    textView.backgroundColor = .white
    textView.font = UIFont.systemFont(ofSize: 24)
    textView.autocorrectionType = .no
    textView.delegate = self
    return textView
  }

  func makeResultLabel() -> UILabel {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 30)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }

  func makeClearButton() -> UIButton {
    let button = UIButton()
    button.setTitle("Clear", for: .normal)
    button.addTarget(self, action: #selector(clearButtonDidTouchUpInside), for: .touchUpInside)
    button.setTitleColor(UIColor.white, for: .normal)
    button.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .highlighted)
    return button
  }
}

// MARK: - Layout

private extension ViewController {
  func setupConstraints() {
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
    textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
    textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true

    textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    textViewBottomConstraint?.isActive = true

    resultLabel.translatesAutoresizingMaskIntoConstraints = false
    resultLabel.centerXAnchor.constraint(equalTo: accessoryView.centerXAnchor).isActive = true
    resultLabel.centerYAnchor.constraint(equalTo: accessoryView.centerYAnchor).isActive = true

    clearButton.translatesAutoresizingMaskIntoConstraints = false
    clearButton.trailingAnchor.constraint(
      equalTo: accessoryView.trailingAnchor,
      constant: -padding
      ).isActive = true
    clearButton.centerYAnchor.constraint(equalTo: accessoryView.centerYAnchor).isActive = true
  }
}

// MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    guard let text = textView.text else {
      return
    }

    let sentiment = classificationService.predictSentiment(from: text)
    show(sentiment: sentiment)
  }
}
