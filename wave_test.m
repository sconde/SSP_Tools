close all;clear all;clc


N = 64;
cfl = 0.01;
testmethod = '~/Dropbox/Research/ssp/sandbox/implicit/Methods/P2/S2/Downwindings2p2_r2.954950e+01.mat';
dudx = SSP_Tools.Discretizers.WenoCore('kernel', 'WENO5', 'epsilon', 1e-16, 'p', 2);
dudt = SSP_Tools.Integrators.DWRK('coefficients', testmethod);
%dudx = SSP_Tools.Discretizers.FiniteDifference();

%test = 'square_wave';
test = 'sine_wave';
switch test
    case 'square_wave'
        % spquare wave
        problem = SSP_Tools.TestProblems.Advection('domain', [-1, 1], ...
            'initial_condition', @(x)[ones(size(x(x<0))),zeros(size(x(x>=0)))],...
            'discretizer', dudx, ...
            'integrator', dudt, ...
            'N', N , 'a',1);
        
    case 'sine_wave'
        problem = SSP_Tools.TestProblems.Advection('domain', [-1, 1], ...
            'initial_condition', @(x) sin(2*pi*x),...
            'discretizer', dudx, ...
            'integrator', dudt, ...
            'N', N , 'a',1);
        
    otherwise
        disp('not the right test')
end

t_end = 1.0;
dt = cfl* min(diff(problem.x));

t_remaining = t_end - problem.t;

tstep = 0;

clf; hold on;
axis ([-1 1 -1 1]);
plot(problem.x,problem.u','-kx','LineWidth',2)
hold on
plot(problem.x,problem.get_exact_solution,'-or','LineWidth',2)
title('Initial Start')

legend('Approximation','Exact Solution')

while t_remaining > 0
    if t_remaining > dt
        dt_step = dt;
    else
        dt_step = t_remaining;
    end
    problem.step(dt_step);
    tstep = tstep + 1;
    
    clf; hold on;
    plot(problem.x,problem.u','-kx','LineWidth',2)
    hold on
    plot(problem.x,problem.get_exact_solution,'-or','LineWidth',2)
    title(sprintf('Time Step %d',tstep))
    legend('Approximation','Exact Solution')

    drawnow;
    print(gcf,'-dpng',sprintf('results/%s%04d',test,tstep))
    
    
    t_remaining = t_end - problem.t;
    hold off
end

