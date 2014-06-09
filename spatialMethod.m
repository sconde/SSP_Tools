switch spacemethod
    case 'finiteDifference'
        dudx = SSP_Tools.Discretizers.FiniteDifference();
        cc = zeros(N+1,1); cc([1 2]) = [-1 1];
        rr = zeros(N+1,1); rr([1 N]) = [-1 1];
        D = toeplitz(cc,rr);
        Dt = -D';
    case 'weno5'
        dudx = SSP_Tools.Discretizers.WenoCore('kernel', 'WENO5', 'epsilon', 1e-16, 'p', 2);
    otherwise
        disp('not right')
end