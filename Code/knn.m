function class_score= knn(A,test_ind,train_ind,D)
% class_score = LX*LY';
    nnode = size(A,1);
    class_score = zeros(size(A));
    nvote = 10;
    S = A';
    for i = 1:test_ind
      [v, o] = sort(D(i, train_ind));
      o = o(~isinf(v));
      k = min(nvote, length(o));
      votes = sum(bsxfun(@rdivide, S(:,train_ind(o(1:k))), D(i, train_ind(o(1:k)))+0.0000001), 2);
      class_score(i,:) = votes;
    end

end