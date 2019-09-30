import matplotlib.pyplot as plt
import numpy as np


class Perceptron(object):
    def __init__(self, n_features, learning_rate=0.01, epochs=50):
        self.learning_rate = learning_rate
        self.w = np.random.random(n_features + 1)
        self.epochs = epochs

    def predict(self, data):
        sum = data.dot(self.w[1:]) + self.w[0]
        if float(sum) > 0:
            res = 1
        else:
            res = 0
        return res


class Perceptrons(object):
    def __init__(self, n_neurons, n_features, learning_rate=0.01, epochs=50):
        self.learning_rate = learning_rate
        self.epochs = epochs
        self.neurons = [Perceptron(n_features, learning_rate, epochs) for _ in range(n_neurons)]

    def predict(self, data):
        return [neuron.predict(data) for neuron in self.neurons]

    def train(self, data, labels):
        for epoch in range(self.epochs):
            for x, y in zip(data, labels):
                for i in range(len(self.neurons)):
                    pred = self.predict(x)
                    self.neurons[i].w[0] += self.learning_rate * (y[i] - pred[i])
                    self.neurons[i].w[1:] += self.learning_rate * (y[i] - pred[i]) * x

    def get_lines(self, x):
        lines = []
        for neuron in self.neurons:
            lines.append(-(neuron.w[0] + neuron.w[1] * x) / neuron.w[2])
        return lines


def convert(pred):
    res = 0
    for x in pred:
        res = res * 2 + x
    return res


def generate_test(a, b, n):
    return [a + np.random.rand(1, 2).reshape(-1) * (b - a) for _ in range(n)]


def test_case(train_data, train_labels, n_neurons):
    model = Perceptrons(n_neurons, len(train_data[0]), learning_rate=0.01, epochs=50)
    model.train(train_data, train_labels)

    a, b = -3, 3
    test_data = generate_test(a, b, 100)
    pred = [model.predict(x) for x in test_data]

    plt.scatter([x[0] for x in test_data], [x[1] for x in test_data], c=[convert(x) for x in pred])

    x = np.array([a, b])
    lines = model.get_lines(x)
    for line in lines:
        plt.plot(x, line)

    plt.show()


train_data = np.array([[-2.8, 1.4], [-0.2, -3.5], [2.8, -4],
                       [-2.1, -2.7], [0.3, -4.1], [-1, -4]])
train_labels = np.array([[0], [1], [1], [0], [1], [0]])
test_case(train_data, train_labels, 1)

train_data = np.array([[1.7, 3.3], [4.7, -4.5], [-0.5, 0.8], [1.8, 2.1],
                       [1.5, 2.2],[-1.3, 0.8], [-3.9, -4.5], [4.7, -2.2]])
train_labels = [[1, 1], [0, 1], [1, 0], [1, 1], [1, 1], [1, 0], [0, 0], [0, 1]]
test_case(train_data, train_labels, 2)

