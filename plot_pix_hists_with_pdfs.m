clear
close all
clc;

load prior
nbins=50;
x0=[];
x1=[];
for i=1:5 % Hard coded for 10 training images
    I=Sprior.snips(:,:,i);
    C0=Sprior.Ctrue(:,:,i)==0;
    C1=Sprior.Ctrue(:,:,i)==1;
    x0=[x0; log(double(I(C0)))];
    x1=[x1; log(double(I(C1)))];
end

[h0,x0bins]=hist(x0,nbins);
h0=h0/trapz(x0bins,h0);
f0=skewLogisticpdf(x0bins,Sprior.theta0(1),Sprior.theta0(2),Sprior.theta0(3));
figure(1); clf; hold on;
bar(x0bins,h0);
plot(x0bins,f0,'m*-');
xlabel('X_0')

[h1,x1bins]=hist(x1,nbins);
h1=h1/trapz(x1bins,h1);
f1=skewLogisticpdf(x1bins,Sprior.theta1(1),Sprior.theta1(2),Sprior.theta1(3));
figure(2); clf; hold on;
bar(x1bins,h1);
plot(x1bins,f1,'m*-');
xlabel('X_1')



