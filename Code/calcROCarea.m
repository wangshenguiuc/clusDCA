function [Areas, nPos, nNeg] = calcROCarea(Scores, Labels)
%function [Areas, nPos, nNeg] = calcROCarea(Scores, Labels)
%
%  Datapoints are the rows, labelling categories are the columns
%
%  Positives are labelled with ones, negatives are labelled with zeros.

% Ensure that Labels is a column vector (if it is a vector)
% this code is from GeneMANIA software package: 
if prod(size(Labels)) == length(Labels)
  Labels = Labels(:); 
end

% Ensure that Scores is a column vector (if it is a vector)
if prod(size(Scores)) == length(Scores)
  Scores = Scores(:); 
end

mScores = -Scores;
[junk, RowIx1] = sort(mScores, 1);
[junk, RowIx2] = sort(mScores(end:-1:1, :), 1);
RowIx2 = length(RowIx2)-RowIx2+1;
vec = [1:size(RowIx1,1)]';
for cc = 1:size(RowIx1, 2)
  Ranks(RowIx1(:,cc),cc) = vec;
  Ranks(RowIx2(:,cc),cc) = (Ranks(RowIx2(:,cc),cc) + vec)/2;
end

if prod(size(Scores)) == length(Scores)
  [rr, cc, ss] = find(Labels);
  PosRanks = sparse(rr,cc,Ranks(rr) .* ss, size(Labels,1), size(Labels,2));
elseif size(Scores,2) ~= size(Labels, 2)
  error('Score/Label mismatch');
else
  PosRanks = Labels .* Ranks;
end
nPos = full(sum(Labels, 1));
%nNeg = size(Labels,1) - nPos;
nNeg = size(Labels,1) - full(sum(Labels > 0, 1));

Areas = 1 - (full(sum(PosRanks, 1))./nPos - (nPos + 1)/2) ./ nNeg;
