function plot_pairwise(X,name)
n = size(X,2);
r = n - 1;
c = round(n*(n-1)/2/r);
k = 0;

for i=1:n
    for j=(i+1):n
        k = k+1;
        subplot(r,c,k);
        plot(X(:,i),X(:,j),'o');
        xlabel(name{i})
        ylabel(name{j})
        [rho,p]=corr(X(:,i),X(:,j),'type','Spearman');
        title(['{\rho}=' num2str(rho) ', p=' num2str(p)]);
    end
end