from matplotlib import pyplot as plt
import numpy as np


def fun(t):
    return np.sin(t ** 2 - 6 * t + 3)


class LinearNetwork(object):
    def __init__(self, depth=5, learning_rate=0.01, epochs=50):
        self.learning_rate = learning_rate
        self.depth = depth
        self.w = np.random.rand(depth + 1)
        self.epochs = epochs

    def predict(self, x):
        net = self.w[1:].dot(x) + self.w[0]
        return net

    def train(self, x, y):
        result = np.zeros(x.size)
        error = 0
        result[0:self.depth] = fun(x[0:self.depth])
        for _ in range(self.epochs):
            for k in range(self.depth, x.size):
                x_prev = y[k - self.depth:k]
                result[k] = self.predict(x_prev)
                self.w[0] += self.learning_rate * (y[k] - result[k])
                self.w[1:] += self.learning_rate * (y[k] - result[k]) * x_prev
                error += (y[k] - result[k]) ** 2
        return result, error


a, b = 0, 5
h = 0.025
X = np.linspace(0, 5, int((b - a) / h))
y = fun(X)
d = 5

model = LinearNetwork(d, 0.01, 50)
result, error = model.train(X, y)

plt.plot(X, result, color='red')
plt.plot(X, y, color='blue')
print(error)
plt.show()

