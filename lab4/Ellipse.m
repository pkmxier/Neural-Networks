function [x, y] = Ellipse(a, b, alpha, x0, y0, h)
	t = 0 : h : 2 * pi;
	x = x0 + a * cos(t) * cos(alpha) - b * sin(t) * sin(alpha);
	y = y0 + a * cos(t) * sin(alpha) + b * sin(t) * cos(alpha);
end