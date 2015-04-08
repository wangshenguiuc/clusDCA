% [Input]
% A: adjacency matrix (could be weighted)
% method: 'personalized-pagerank' or 'self-diffusion'
% aux: auxiliary parameters, such as max number of iterations and
%      restart probability 
%
% [Output]
% Q: diffusion state matrix. i-th column represents the diffusion
%    state of the i-th node. 
%
function [Q] = run_diffusion(A, method, aux)
    n = size(A, 1);

    renorm = @(M) bsxfun(@rdivide, M, sum(M));

    A = A + diag(sum(A) == 0); % Add self-edges to isolated nodes
    P = renorm(A);
    fprintf('rsp=%f\n',aux.reset_prob);
    if strcmp(method, 'personalized-pagerank')
      assert(isfield(aux, 'maxiter'))
      assert(isfield(aux, 'reset_prob'))
      
      reset = eye(n);
      Q = reset;
      for i = 1:aux.maxiter
        Q_new = aux.reset_prob * reset + (1 - aux.reset_prob) * P * Q;
        delta = norm(Q - Q_new, 'fro');
         fprintf('Iter %d. Frobenius norm: %f\n', i, delta);
        Q = Q_new;
        if delta < 1e-6
           fprintf('Converged.\n');
          break
        end
      end

    elseif strcmp(method, 'self-diffusion')
      assert(isfield(aux, 'maxiter'))

      Q = eye(n);
      for i = 1:aux.maxiter
        Q_new = eye(n) + P * Q;
         fprintf('Iter %d. Frobenius norm: %f\n', i, norm(renorm(Q) - renorm(Q_new), 'fro'));
        Q = Q_new;
      end

    else
      error(['Unknown method: ', method])
    end
    Q = bsxfun(@rdivide, Q, sum(Q));

end
