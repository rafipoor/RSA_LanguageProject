function Perm = RandpermWithFixedPoints(N,MovingPoints)
Perm = 1:N;
Perm(MovingPoints) = MovingPoints(randperm(numel(MovingPoints)));
end