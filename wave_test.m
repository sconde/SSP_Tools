close all;clear all;clc


N = 128;
cfl = 0.9;
testmethod = '~/Dropbox/Research/ssp/sandbox/nonLinear/implicit/Methods/P2/S2/Downwindings2p2_r2.954950e+01.mat';
dudt = SSP_Tools.Integrators.DWRK('coefficients', testmethod);
spacemethod = 'finiteDifference';
%test = 'square_wave';
test = 'sine_wave';

spatialMethod; testProblem;

t_end = 1.0;
dx = min(diff(problem.x));
dt = cfl* min(diff(problem.x));
D = D/dx; Dt = Dt/dx;

t_remaining = t_end - problem.t;

tstep = 0;

clf; hold on;
axis ([0 1 -1 1]);
plot(problem.x,problem.u','-.r','LineWidth',2)
hold on
plot(problem.x,problem.get_exact_solution,'-k','LineWidth',2)
title('Initial Start')

legend('Approximation','Exact Solution')

BE = speye(N+1)\(speye(N+1) - dt*D);
TP = speye(N+1)\(speye(N+1) - 0.5*dt*D);
TP = TP*(speye(N+1) + 0.5*dt*D);

BEu0 = problem.u;
TPu0 = problem.u;

while t_remaining > 0
    if t_remaining > dt
        dt_step = dt;
    else
        dt_step = t_remaining;
    end
    problem.step(dt_step);
    tstep = tstep + 1;
    BE_u = BE*BEu0;
    TP_u = TP*TPu0;
    
    clf; hold on;
    axis ([0 1 -1 1]);
    plot(problem.x,problem.u','-.r','LineWidth',2)
    hold on
    plot(problem.x,problem.get_exact_solution,'-k','LineWidth',2)
    plot(problem.x,BE_u,'--b','LineWidth',2)
    plot(problem.x,TP_u,'-xg','LineWidth',2)
    title(sprintf('Time Step %d',tstep))
    legend('Approximation','Exact Solution','BE','2nd order RK')
    
    drawnow;
    print(gcf,'-dpng',sprintf('results/%s%04d',test,tstep))
    
    
    t_remaining = t_end - problem.t;
    hold off
    BEu0 = BE_u;
    TPu0 = TP_u;
end

