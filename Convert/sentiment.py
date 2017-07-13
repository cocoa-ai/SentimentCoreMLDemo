import re
import coremltools
import pandas as pd
import numpy as np
from nltk.corpus import stopwords
from nltk import word_tokenize
from string import punctuation
from sklearn.feature_extraction import DictVectorizer
from sklearn.pipeline import Pipeline
from sklearn.svm import LinearSVC
from sklearn.model_selection import GridSearchCV

# Read reviews from CSV
reviews = pd.read_csv('epinions.csv')
reviews = reviews.as_matrix()[:, :]
print "%d reviews in dataset" % len(reviews)

# Create features
def features(sentence):
    stop_words = stopwords.words('english') + list(punctuation)
    words = word_tokenize(sentence)
    words = [w.lower() for w in words]
    filtered = [w for w in words if w not in stop_words and not w.isdigit()]
    words = {}
    for word in filtered:
        if word in words:
            words[word] += 1.0
        else:
            words[word] = 1.0
    return words

# Vectorize the features function
features = np.vectorize(features)
# Extract the features for the whole dataset
X = features(reviews[:, 1])
# Set the targets
y = reviews[:, 0]

# Create grid search
clf = Pipeline([("dct", DictVectorizer()), ("svc", LinearSVC())])
params = {
    "svc__C": [1e15, 1e13, 1e11, 1e9, 1e7, 1e5, 1e3, 1e1, 1e-1, 1e-3, 1e-5]
}
gs = GridSearchCV(clf, params, cv=10, verbose=2, n_jobs=-1)
gs.fit(X, y)
model = gs.best_estimator_

# Print results
print model.score(X, y)
print "Optimized parameters: ", model
print "Best CV score: ", gs.best_score_

# Convert to CoreML model
coreml_model = coremltools.converters.sklearn.convert(model)
coreml_model.author = 'Vadym Markov'
coreml_model.license = 'MIT'
coreml_model.short_description = 'Sentiment polarity LinearSVC.'
coreml_model.input_description['input'] = 'Features extracted from the text.'
coreml_model.output_description['classLabel'] = 'The most likely polarity (positive or negative), for the given input.'
coreml_model.output_description['classProbability'] = 'The probabilities for each class label, for the given input.'
coreml_model.save('SentimentPolarity.mlmodel')
