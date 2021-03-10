function Curve = big_contour(img)
imgn = clear_background(img);
C = contourc(double(imgn));
S = contourdata(C);
a = find([S.numel] == max([S.numel]));
x = S(a).xdata;
y = S(a).ydata;
Curve = [x y];
