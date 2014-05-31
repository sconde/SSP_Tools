close all;clear all;clc


N = 40;
cfl = 0.2;
testmethod = '~/Dropbox/Research/ssp/sandbox/implicit/Methods/P2/S2/Downwindings2p2_r2.954950e+01.mat';
dudx = SSP_Tools.Discretizers.WenoCore('kernel', 'WENO5', 'epsilon', 1e-16, 'p', 2);
dudt = SSP_Tools.Integrators.DWRK('coefficients', testmethod);


problem = SSP_Tools.TestProblems.Advection('domain', [-1, 1], ...
    'initial_condition', @(x)[ones(size(x(x<0))),zeros(size(x(x>=0)))],...
    'discretizer', dudx, ...
    'integrator', dudt, ...
    'N', N , 'a',1);

t_end = 1.0;
dt = cfl* min(diff(problem.x));

t_remaining = t_end - problem.t;

while t_remaining > 0
    if t_remaining > dt
        dt_step = dt;
    else
        dt_step = t_remaining;
    end
    %plot(problem.x,problem.u')
    %title(sprintf('T=%f %3.2f%% complete\r', problem.t, problem.t / t_end * 100))
    problem.plot
    hold on
    pause(0.01)
    problem.step(dt_step);
    t_remaining = t_end - problem.t;
    hold off
end

