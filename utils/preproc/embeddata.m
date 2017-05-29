function [data,T] = embeddata(data,T,embeddedlags)
tp_less = max(embeddedlags) + max(-embeddedlags);
if isstruct(data)
    ndim = size(data.X,2);
    C = zeros(sum(T-tp_less),size(data.C,2));
else % just a matrix
    ndim = size(data,2);
end
X = zeros(sum(T-tp_less),ndim*length(embeddedlags));
acc = 0;
for n=1:length(T)
    if isstruct(data)
        [x,ind] = embedx(data.X(sum(T(1:n-1))+1:sum(T(1:n)),:),embeddedlags);
        c = data.C( sum(T(1:n-1))+1: sum(T(1:n)) , : ); c = c(ind,:);
        C(acc+(1:T(n)-tp_less),:) = c;
    else
        [x,ind] = embedx(data(sum(T(1:n-1))+1:sum(T(1:n)),:),embeddedlags);
    end
    X(acc+(1:T(n)-tp_less),:) = x;
    acc = acc + sum(ind);
end
T = T-tp_less;
if isstruct(data)
    data.X = X; data.C = C;
else
    data = X;
end
end