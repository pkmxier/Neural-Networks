function point = Polar(h)
	phi = 0 : h : 2 * pi;
	r = phi .* phi;
    point = [r .* cos(phi); r .* sin(phi); phi];
end