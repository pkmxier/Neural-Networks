from matplotlib import pyplot as plt
import numpy as np


def fun1(t):
    return np.sin(t ** 2 - 6 * t + 3)


def fun2(t):
    return np.sin(np.sin(t) * t * t)


def fun3(t):
    return 1 / 4 * np.sin(np.sin(t) * t * t - np.pi)


class LinearNetwork(object):
    def __init__(self, depth=5, learning_rate=0.01, epochs=50):
        self.learning_rate = learning_rate
        self.depth = depth
        self.w = np.random.rand(depth + 1)
        self.epochs = epochs

    def _predict(self, x):
        net = self.w[1:].dot(x) + self.w[0]
        return net

    def predict(self, x, mode=1):
        result = np.zeros(x.size)
        result[0:self.depth] = x[0:self.depth]
        for k in range(self.depth, x.size):
            if mode == 1:
                x_prev = x[k - self.depth:k]
            else:
                x_prev = result[k - self.depth:k]
            result[k] = self._predict(x_prev)
        return result

    def train(self, x, y):
        error = 0
        for _ in range(self.epochs):
            for k in range(self.depth, x.size):
                x_prev = y[k - self.depth:k]
                result = self._predict(x_prev)
                self.w[0] += self.learning_rate * (y[k] - result)
                self.w[1:] += self.learning_rate * (y[k] - result) * x_prev
                error += (y[k] - result) ** 2
        return error / x.size


def test_case1():
    a, b = 0, 6
    h = 0.025
    X = np.linspace(a, b, int((b - a) / h))
    y = fun1(X)
    d = 3

    model = LinearNetwork(d, 0.01, 50)
    error = model.train(X, y)
    print(error)

    plt.subplot(2, 1, 1)
    result = model.predict(y, mode=1)
    plt.plot(X, result, color='red')
    plt.plot(X, y, color='blue')

    plt.subplot(2, 1, 2)
    result = model.predict(y, mode=2)
    plt.plot(X, result, color='red')
    plt.plot(X, y, color='blue')

    plt.show()


def test_case2():
    a, b = 0, 3.5
    h = 0.01
    X = np.linspace(a, b, int((b - a) / h))
    y = fun3(X)
    d = 2

    model = LinearNetwork(d, 0.1, 600)
    error = model.train(X, y)
    print(error)

    y = fun2(X)
    result = model.predict(y, mode=1)
    plt.plot(X, result, color='red')
    plt.plot(X, y, color='blue')

    plt.show()


test_case2()
