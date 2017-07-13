# Sentiment Polarity CoreML Demo

A Demo application using `CoreML` framework for sentiment polarity analysis.

<div align="center">
<img src="https://github.com/cocoa-ai/SentimentCoreMLDemo/blob/master/Screenshot.png" alt="SentimentCoreMLDemo" width="300" height="533" />
</div>

## Model

[CoreML model](https://github.com/cocoa-ai/SentimentCoreMLDemo/blob/master/SentimentPolarity/Resources/SentimentPolarity.mlmodel)
was converted from [Scikit-learn Pipeline](http://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html)
using [coremltools](https://pypi.python.org/pypi/coremltools) python package.

The model is based on [LinearSVC](http://scikit-learn.org/stable/modules/generated/sklearn.svm.LinearSVC.html) classifier and is able to distinguish between
positive and negative sentences with best CV score = 0.801013024602. It was
trained using [Epinions.com](http://epinions.com) dataset with reviews of
products and services. Accuracy can be improved by using
[TfidfVectorizer](http://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html) for feature extraction, but it's not supported by [coremltools](https://pypi.python.org/pypi/coremltools)
at the moment.

You can find training and conversion source code [here](https://github.com/cocoa-ai/SentimentCoreMLDemo/blob/master/Convert/sentiment.py).

## Requirements

- Xcode 9
- iOS 11

## Installation

```sh
git clone https://github.com/cocoa-ai/SentimentCoreMLDemo.git
cd SentimentCoreMLDemo
open SentimentPolarity.xcodeproj/
```

Build the project and run it on a simulator or a device with iOS 11.

## Author

Vadym Markov, markov.vadym@gmail.com

## Credits

- Dataset with [Epinions.com](http://epinions.com) reviews was taken from
[HW3: Sentiment Analysis ](http://boston.lti.cs.cmu.edu/classes/95-865-K/HW/HW3/)

## References
- [scikit-learn](http://scikit-learn.org/stable/)
- [Apple Machine Learning](https://developer.apple.com/machine-learning/)
- [CoreML Framework](https://developer.apple.com/documentation/coreml)
- [coremltools](https://pypi.python.org/pypi/coremltools)
