%% Absolute Transmission Subnetwork Error.

% Clear Everything.
clear, close('all'), clc


%% Define Simulation Parameters.

% Define the save and load directories.
save_directory = '.\Save';                              % [str] Save Directory.
load_directory = '.\Load';                              % [str] Load Directory.

% Set a flag to determine whether to simulate.
% b_simulate = true;                                  	% [T/F] Simulation Flag. (Determines whether to create a new simulation of the steady state error or to load a previous simulation.)
b_simulate = false;                                     % [T/F] Simulation Flag. (Determines whether to create a new simulation of the steady state error or to load a previous simulation.)

% Set the level of verbosity.
b_verbose = true;                                       % [T/F] Printing Flag. (Determines whether to print out information.)

% Define the network simulation timestep.
% network_dt = 1e-3;                                    % [s] Simulation Timestep.
network_dt = 1e-4;                                      % [s] Simulation Timestep.
% network_dt = 1e-5;                                    % [s] Simulation Timestep.

% Define the network simulation duration.
network_tf = 3;                                         % [s] Simulation Duration.

% Define the number of neurons.
num_neurons = 2;                                        % [#] Number of Neurons.


%% Define Absolute Transmission Subnetwork Parameters.

% Define the maximum membrane voltages.
R1 = 20e-3;                                         % [V] Maximum Membrane Voltage (Neuron 1).

% Define the membrane conductances.
Gm1 = 1e-6;                                       	% [S] Membrane Conductance (Neuron 1)
Gm2 = 1e-6;                                      	% [S] Membrane Conductance (Neuron 2) 

% Define the membrane capacitance.
Cm1 = 5e-9;                                     	% [F] Membrane Capacitance (Neuron 1)
Cm2 = 5e-9;                                      	% [F] Membrane Capacitance (Neuron 2)

% Define the sodium channel conductance.
Gna1 = 0;                                           % [S] Sodium Channel Conductance (Neuron 1).
Gna2 = 0;                                           % [S] Sodium Channel Conductance (Neuron 2).

% Define the synaptic conductances.
dEs21 = 194e-3;                                   	% [V] Synaptic Reversal Potential (Synapse 21).

% Define the applied currents.
Ia1 = R1*Gm1;                                      	% [A] Applied Current (Neuron 1)
Ia2 = 0;                                            % [A] Applied Current (Neuron 2).

% Define the current state.
current_state1 = 1;                                 % [-] Current State (Neuron 1). (Specified as a ratio of the total applied current that is active.)

% Define the network design parameters.
c = 2;                                              % [-] Design Constant.

% Define the decoding operation.
f_decode = @( x ) x*( 10^3 );


%% Compute the Derived Absolute Transmission Subnetwork Parameters.

% Compute the maximum membrane voltages.
R2 = c*R1;                                          % [V] Maximum Membrane Voltage (Neuron 2).

% Compute the synaptic conductances.
gs21 = ( R2*Gm2 - Ia2 )/( dEs21 - R2 );             % [S] Synaptic Conductance (Synapse 21).


%% Print Absolute Transmission Subnetwork Parameters.

% Print out a header.
fprintf( '\n------------------------------------------------------------\n' )
fprintf( '------------------------------------------------------------\n' )
fprintf( 'ABSOLUTE TRANSMISSION SUBNETWORK PARAMETERS:\n' )
fprintf( '------------------------------------------------------------\n' )

% Print out neuron information.
fprintf( 'Neuron Parameters:\n' )
fprintf( 'R1 \t\t= \t%0.2f \t[mV]\n', R1*( 10^3 ) )
fprintf( 'R2 \t\t= \t%0.2f \t[mV]\n', R2*( 10^3 ) )

fprintf( 'Gm1 \t= \t%0.2f \t[muS]\n', Gm1*( 10^6 ) )
fprintf( 'Gm2 \t= \t%0.2f \t[muS]\n', Gm2*( 10^6 ) )

fprintf( 'Cm1 \t= \t%0.2f \t[nF]\n', Cm1*( 10^9 ) )
fprintf( 'Cm2 \t= \t%0.2f \t[nF]\n', Cm2*( 10^9 ) )

fprintf( 'Gna1 \t= \t%0.2f \t[muS]\n', Gna1*( 10^6 ) )
fprintf( 'Gna2 \t= \t%0.2f \t[muS]\n', Gna2*( 10^6 ) )
fprintf( '\n' )

% Print out the synapse information.
fprintf( 'Synapse Parameters:\n' )
fprintf( 'dEs21 \t= \t%0.2f \t[mV]\n', dEs21*( 10^3 ) )
fprintf( 'gs21 \t= \t%0.2f \t[muS]\n', gs21*( 10^6 ) )
fprintf( '\n' )

% Print out the applied current information.
fprintf( 'Applied Curent Parameters:\n' )
fprintf( 'Ia1 \t= \t%0.2f \t[nA]\n', current_state1*Ia1*( 10^9 ) )
fprintf( '\n' )

% Print out the network design parameters.
fprintf( 'Network Design Parameters:\n' )
fprintf( 'c \t\t= \t%0.2f \t[-]\n', c )

% Print out ending information.
fprintf( '------------------------------------------------------------\n' )
fprintf( '------------------------------------------------------------\n' )


%% Create the Absolute Transmission Subnetwork.

% Create an instance of the network class.
network = network_class( network_dt, network_tf );

% Create the network components.
[ network.neuron_manager, neuron_IDs ] = network.neuron_manager.create_neurons( 2 );
[ network.synapse_manager, synapse_IDs ] = network.synapse_manager.create_synapses( 1 );
[ network.applied_current_manager, applied_current_IDs ] = network.applied_current_manager.create_applied_currents( 2 );

% Set the neuron parameters.
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs, [ Gna1, Gna2 ], 'Gna' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs, [ R1, R2 ], 'R' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs, [ Gm1, Gm2 ], 'Gm' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs, [ Cm1, Cm2 ], 'Cm' );

% Set the synapse parameters.
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs, 1, 'from_neuron_ID' );
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs, 2, 'to_neuron_ID' );
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs, gs21, 'g_syn_max' );
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs, dEs21, 'dE_syn' );

% Set the applied current parameters.
network.applied_current_manager = network.applied_current_manager.set_applied_current_property( applied_current_IDs, [ 1, 2 ], 'neuron_ID' );
network.applied_current_manager = network.applied_current_manager.set_applied_current_property( applied_current_IDs, [ current_state1*Ia1, Ia2 ], 'I_apps' );


%% Compute Desired & Achieved Absolute Transmission Formulations.

% Retrieve the maximum membrane voltages.
Rs = cell2mat( network.neuron_manager.get_neuron_property( 'all', 'R' ) );                      % [V] Maximum Membrane Voltages.

% Retrieve the membrane capacitances.
Cms = cell2mat( network.neuron_manager.get_neuron_property( 'all', 'Cm' ) );                    % [F] Membrane Capacitances.

% Retrieve the membrane conductances.
Gms = cell2mat( network.neuron_manager.get_neuron_property( 'all', 'Gm' ) );                    % [S] Membrane Conductances.

% Retrieve the applied currents.
Ias = cell2mat( network.neuron_manager.get_neuron_property( 'all', 'I_tonic' ) );               % [A] Applied Currents.

% Retrieve the synaptic conductances.
gs = network.get_gsynmaxs( 'all' );                                                             % [S] Synaptic Conductances.

% Retrieve the synaptic reversal potentials.
dEs = network.get_dEsyns( 'all' );                                                              % [V] Synaptic Reversal Potential.

% Define the numerical stability timestep.
dt0 = 1e-6;                                                                                     % [s] Numerical Stability Time Step.

% Define the transmission subnetwork inputs.
U1s = linspace( 0, Rs( 1 ), 100  );

% Create the input points.
U1s_flat = reshape( U1s, [ numel( U1s ), 1 ] );

% Compute the desired and achieved absolute transmission steady state output.
U2s_flat_desired = network.compute_desired_absolute_transmission_steady_state_output( U1s_flat, c );
[ U2s_flat_achieved_theoretical, As, dts, condition_numbers ] = network.achieved_transmission_RK4_stability_analysis( U1s_flat, Cms, Gms, Rs, Ias, gs, dEs, dt0 );

% Store the desired and theoretically achieved absolute transmission steady state results in arrays.
Us_flat_desired = [ U1s_flat, U2s_flat_desired ];
Us_flat_achieved_theoretical = [ U1s_flat, U2s_flat_achieved_theoretical ];

% Retrieve the maximum RK4 step size and condition number.
[ dt_max, indexes_dt ] = max( dts );
[ condition_number_max, indexes_condition_number ] = max( condition_numbers );


%% Print the Desired and Achieved Absolute Transmission Formulation Results.

% Print out the stability information.
fprintf( 'STABILITY SUMMARY:\n' )
fprintf( 'Linearized System Matrix: A =\n\n' ), disp( As( :, :, indexes_condition_number ) )
fprintf( 'Max RK4 Step Size: \t\tdt_max = %0.3e [s] @ %0.2f [mV]\n', dt_max, U1s_flat( indexes_dt )*( 10^3 ) )
fprintf( 'Proposed Step Size: \tdt = %0.3e [s]\n', network_dt )
fprintf( 'Condition Number: \t\tcond( A ) = %0.3e [-] @ %0.2f [mV]\n', condition_number_max, U1s_flat( indexes_condition_number )*( 10^3 ) )
fprintf( '\n' )


%% Plot the Desired and Achieved Absolute Transmission Formulation Results.

% Decode the input and output membrane voltages.
Us_flat_desired_decoded = f_decode( Us_flat_desired );
Us_flat_achieved_theoretical_decoded = f_decode( Us_flat_achieved_theoretical );

% Plot the desired and achieved absolute transmission formulation results.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Theory' ); hold on, grid on, xlabel( 'Membrane Voltage 1 (Input), U1 [mV]' ), ylabel( 'Membrane Voltage 2 (Output), U2 [mV]' ), title( 'Absolute Transmission Theory' )
plot( Us_flat_desired( :, 1 )*( 10^3 ), Us_flat_desired( :, 2 )*( 10^3 ), '-', 'Linewidth', 3 )
plot( Us_flat_achieved_theoretical( :, 1 )*( 10^3 ), Us_flat_achieved_theoretical( :, 2 )*( 10^3 ), '--', 'Linewidth', 3 )
legend( 'Desired', 'Achieved (Theory)' )
saveas( fig, [ save_directory, '\', 'absolute_transmission_theory' ] )

% Plot the decoded desired and achieved absolute transmission formulation results.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Theory Decoded' ); hold on, grid on, xlabel( 'Input, x [-]' ), ylabel( 'Output, y [-]' ), title( 'Absolute Transmission Theory Decoded' )
plot( Us_flat_desired_decoded( :, 1 ), Us_flat_desired_decoded( :, 2 ), '-', 'Linewidth', 3 )
plot( Us_flat_achieved_theoretical_decoded( :, 1 ), Us_flat_achieved_theoretical_decoded( :, 2 ), '--', 'Linewidth', 3 )
legend( 'Desired', 'Achieved (Theory)' )
saveas( fig, [ save_directory, '\', 'absolute_transmission_theory_decoded' ] )

% Plot the RK4 maximum timestep.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission RK4 Maximum Timestep' ); hold on, grid on, xlabel( 'Membrane Voltage 1 (Input), U1 [mV]' ), ylabel( 'RK4 Maximum Timestep, dt [s]' ), title( 'Absolute Transmission RK4 Maximum Timestep' )
plot( Us_flat_desired( :, 1 )*( 10^3 ), dts, '-', 'Linewidth', 3 )
saveas( fig, [ save_directory, '\', 'absolute_transmission_rk4_maximum_timestep' ] )

% Plot the linearized system condition numbers.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Condition Numbers' ); hold on, grid on, xlabel( 'Membrane Voltage 1 (Input), U1 [mV]' ), ylabel( 'Condition Number [-]' ), title( 'Absolute Transmission Condition Number' )
plot( Us_flat_desired( :, 1 )*( 10^3 ), condition_numbers, '-', 'Linewidth', 3 )
saveas( fig, [ save_directory, '\', 'absolute_transmission_condition_numbers' ] )


%% Simulate the Absolute Transmission Network.

% Determine whether to simulate the network.
if b_simulate               % If we want to simulate the network....
    
    % Define the number of applied currents to use.
    n_applied_currents = 20;                                    % [#] Number of Applied Currents.
    
    % Create the applied currents.
    applied_currents = linspace( 0, network.neuron_manager.neurons( 1 ).R*network.neuron_manager.neurons( 1 ).Gm, n_applied_currents );

    % Create a matrix to store the membrane voltages.
    Us_achieved_numerical = zeros( n_applied_currents, num_neurons );
    
    % Simulate the network for each of the applied current combinations.
    for k = 1:n_applied_currents                          % Iterate through each of the currents applied to the input neuron...
            
            % Create applied currents.
            network.applied_current_manager = network.applied_current_manager.set_applied_current_property( applied_current_IDs( 1 ), applied_currents( k ), 'I_apps' );

            % Simulate the network.
            [ network, ts, Us, hs, dUs, dhs, G_syns, I_leaks, I_syns, I_nas, I_apps, I_totals, m_infs, h_infs, tauhs, neuron_IDs ] = network.compute_set_simulation(  );
            
            % Retrieve the final membrane voltages.
            Us_achieved_numerical( k, : ) = Us( :, end );
            
    end

    % Save the simulation results.
    save( [ save_directory, '\', 'absolute_transmission_subnetwork_error' ], 'applied_currents', 'Us_achieved_numerical' )
    
else                % Otherwise... ( We must want to load data from an existing simulation... )
    
    % Load the simulation results.
    data = load( [ load_directory, '\', 'absolute_transmission_subnetwork_error' ] );
    
    % Store the simulation results in separate variables.
    applied_currents = data.applied_currents;
    Us_achieved_numerical = data.Us_achieved_numerical;

end


%% Compute the Absolute Transmission Network Error.

% Compute the desired membrane voltage output.
Us_desired_output = network.compute_desired_absolute_transmission_steady_state_output( Us_achieved_numerical( :, 1 ), c );
Us_achieved_theoretical_output = network.compute_achieved_transmission_steady_state_output( Us_achieved_numerical( :, 1 ), Rs( 1 ), Gms( 2 ), Ias( 2 ), gs( 2, 1 ), dEs( 2, 1 ) );

% Compute the desired membrane voltage output.
Us_desired = Us_achieved_numerical; Us_desired( :, end ) = Us_desired_output;
Us_achieved_theoretical = Us_achieved_numerical; Us_achieved_theoretical( :, end ) = Us_achieved_theoretical_output;

% Decode the achieved and desired decoded membrane voltage output.
R2_decoded = f_decode( R2 );
Us_desired_decoded = f_decode( Us_desired );
Us_achieved_theoretical_decoded = f_decode( Us_achieved_theoretical );
Us_achieved_numerical_decoded = f_decode( Us_achieved_numerical );

% Compute the error between the achieved and desired results.
errors_theoretical = Us_achieved_theoretical( :, end ) - Us_desired( :, end );
errors_numerical = Us_achieved_numerical( :, end ) - Us_desired( :, end );

% Compute the error between the decoded achieved and desired results.
errors_theoretical_decoded = Us_achieved_theoretical_decoded( :, end ) - Us_desired_decoded( :, end );
errors_numerical_decoded = Us_achieved_numerical_decoded( :, end ) - Us_desired_decoded( :, end );

% Compute the error percentage between the achieved and desired results.
error_percentages_theoretical = 100*( errors_theoretical/R2 );
error_percentages_numerical = 100*( errors_numerical/R2 );

% Compute the error percentage between the decoded achieved and desired results.
error_percentages_theoretical_decoded = 100*( errors_theoretical_decoded/R2_decoded );
error_percentages_numerical_decoded = 100*( errors_numerical_decoded/R2_decoded );

% Compute the root mean squared error.
error_rmse_theoretical = sqrt( ( 1/( numel( errors_theoretical ) ) )*sum( errors_theoretical.^2, 'all' ) );
error_rmse_numerical = sqrt( ( 1/( numel( errors_numerical ) ) )*sum( errors_numerical.^2, 'all' ) );

% Compute the decoded root mean squared error.
error_rmse_theoretical_decoded = sqrt( ( 1/( numel( errors_theoretical_decoded ) ) )*sum( errors_theoretical_decoded.^2, 'all' ) );
error_rmse_numerical_decoded = sqrt( ( 1/( numel( errors_numerical_decoded ) ) )*sum( errors_numerical_decoded.^2, 'all' ) );

% Compute the root mean squared error percentage.
error_rmse_percentage_theoretical = 100*( error_rmse_theoretical/R2 );
error_rmse_percentage_numerical = 100*( error_rmse_numerical/R2 );

% Compute the decoded root mean squared error percentage.
error_rmse_percentage_theoretical_decoded = 100*( error_rmse_theoretical_decoded/R2_decoded );
error_rmse_percentage_numerical_decoded = 100*( error_rmse_numerical_decoded/R2_decoded );

% Compute the standard deviation of the error.
error_std_theoretical = std( errors_theoretical, 0, 'all' );
error_std_numerical = std( errors_numerical, 0, 'all' );

% Compute the standard deviation of the decoded error.
error_std_theoretical_decoded = std( errors_theoretical_decoded, 0, 'all' );
error_std_numerical_decoded = std( errors_numerical_decoded, 0, 'all' );

% Compute the standard deviation of the error percentage.
error_std_percentage_theoretical = 100*( error_std_theoretical/R2 );
error_std_percentage_numerical = 100*( error_std_numerical/R2 );

% Compute the standard deviation of the decoded error percentage.
error_std_percentage_theoretical_decoded = 100*( error_std_theoretical_decoded/R2_decoded );
error_std_percentage_numerical_decoded = 100*( error_std_numerical_decoded/R2_decoded );

% Compute the minimum and maximum error.
[ error_min_theoretical, index_min_theoretical ] = min( errors_theoretical, [  ], 'all', 'linear' );
[ error_min_numerical, index_min_numerical ] = min( errors_numerical, [  ], 'all', 'linear' );
[ error_max_theoretical, index_max_theoretical ] = max( errors_theoretical, [  ], 'all', 'linear' );
[ error_max_numerical, index_max_numerical ] = max( errors_numerical, [  ], 'all', 'linear' );

% Compute the minimum and maximum decoded error.
[ error_min_theoretical_decoded, index_min_theoretical_decoded ] = min( errors_theoretical_decoded, [  ], 'all', 'linear' );
[ error_min_numerical_decoded, index_min_numerical_decoded ] = min( errors_numerical_decoded, [  ], 'all', 'linear' );
[ error_max_theoretical_decoded, index_max_theoretical_decoded ] = max( errors_theoretical_decoded, [  ], 'all', 'linear' );
[ error_max_numerical_decoded, index_max_numerical_decoded ] = max( errors_numerical_decoded, [  ], 'all', 'linear' );

% Compute the minimum and maximum error percentages.
error_min_percentage_theoretical = 100*( error_min_theoretical/R2 );
error_min_percentage_numerical = 100*( error_min_numerical/R2 );
error_max_percentage_theoretical = 100*( error_max_theoretical/R2 );
error_max_percentage_numerical = 100*( error_max_numerical/R2 );

% Compute the minimum and maximum decoded error percentages.
error_min_percentage_theoretical_decoded = 100*( error_min_theoretical_decoded/R2_decoded );
error_min_percentage_numerical_decoded = 100*( error_min_numerical_decoded/R2_decoded );
error_max_percentage_theoretical_decoded = 100*( error_max_theoretical_decoded/R2_decoded );
error_max_percentage_numerical_decoded = 100*( error_max_numerical_decoded/R2_decoded );

% Compute the error range.
error_range_theoretical = range( errors_theoretical, 'all' );
error_range_numerical = range( errors_numerical, 'all' );

% Compute the decoded error range.
error_range_theoretical_decoded = range( errors_theoretical_decoded, 'all' );
error_range_numerical_decoded = range( errors_numerical_decoded, 'all' );

% Compute the error range percentage.
error_range_percentage_theoretical = 100*( error_range_theoretical/R2 );
error_range_percentage_numerical = 100*( error_range_numerical/R2 );

% Compute the decoded error range percentage.
error_range_percentage_theoretical_decoded = 100*( error_range_theoretical_decoded/R2_decoded );
error_range_percentage_numerical_decoded = 100*( error_range_numerical_decoded/R2_decoded );


%% Print the Absolute Tranmission Summary Statistics.

% Print the absolute transmission summary statistics.
fprintf( '\n' )
fprintf( 'Absolute Transmission Summary Statistics (Membrane Voltages)\n' )
fprintf( '\n' )

fprintf( 'RMSE:\n' )
fprintf( '\tTheoretical: \t%9.3f \t[mV] \t(%6.2f [%%])\n', error_rmse_theoretical*( 10^3 ), error_rmse_percentage_theoretical )
fprintf( '\tNumerical: \t\t%9.3f \t[mV] \t(%6.2f [%%])\n', error_rmse_numerical*( 10^3 ), error_rmse_percentage_numerical )
fprintf( '\tDifference: \t%9.3e \t[mV] \t(%6.2f [%%])\n', ( error_rmse_numerical - error_rmse_theoretical )*( 10^3 ), error_rmse_percentage_numerical - error_rmse_percentage_theoretical )
fprintf( '\n' )

fprintf( 'STD:\n' )
fprintf( '\tTheoretical: \t%9.3f \t[mV] \t(%6.2f [%%])\n', error_std_theoretical*( 10^3 ), error_std_percentage_theoretical )
fprintf( '\tNumerical: \t\t%9.3f \t[mV] \t(%6.2f [%%])\n', error_std_numerical*( 10^3 ), error_std_percentage_numerical )
fprintf( '\tDifference: \t%9.3e \t[mV] \t(%6.2f [%%])\n', ( error_std_numerical - error_std_theoretical )*( 10^3 ), error_std_percentage_numerical - error_std_percentage_theoretical )
fprintf( '\n' )

fprintf( 'Min:\n' )
fprintf( '\tTheoretical: \t%9.3f \t[mV] \t(%6.2f [%%]) \t@ \t(%9.3f [mV], %9.3f [mV])\n', error_min_theoretical*( 10^3 ), error_min_percentage_theoretical, Us_achieved_theoretical( index_min_theoretical, 1 )*( 10^3 ), Us_achieved_theoretical( index_min_theoretical, 2 )*( 10^3 ) )
fprintf( '\tNumerical: \t\t%9.3e \t[mV] \t(%6.2f [%%]) \t@ \t(%9.3f [mV], %9.3f [mV])\n', error_min_numerical*( 10^3 ), error_min_percentage_numerical, Us_achieved_numerical( index_min_numerical, 1 )*( 10^3 ), Us_achieved_numerical( index_min_numerical, 2 )*( 10^3 ) )
fprintf( '\tDifference: \t%9.3e \t[mV] \t(%6.2f [%%])\n', ( error_min_numerical - error_min_theoretical )*( 10^3 ), error_min_percentage_numerical - error_min_percentage_theoretical )
fprintf( '\n' )

fprintf( 'Max:\n' )
fprintf( '\tTheoretical: \t%9.3f \t[mV] \t(%6.2f [%%]) \t@ \t(%9.3f [mV], %9.3f [mV])\n', error_max_theoretical*( 10^3 ), error_max_percentage_theoretical, Us_achieved_theoretical( index_max_theoretical, 1 )*( 10^3 ), Us_achieved_theoretical( index_max_theoretical, 2 )*( 10^3 ) )
fprintf( '\tNumerical: \t\t%9.3f \t[mV] \t(%6.2f [%%]) \t@ \t(%9.3f [mV], %9.3f [mV])\n', error_max_numerical*( 10^3 ), error_max_percentage_numerical, Us_achieved_numerical( index_max_numerical, 1 )*( 10^3 ), Us_achieved_numerical( index_max_numerical, 2 )*( 10^3 ) )
fprintf( '\tDifference: \t%9.3e \t[mV] \t(%6.2f [%%])\n', ( error_max_numerical - error_max_theoretical )*( 10^3 ), error_max_percentage_numerical - error_max_percentage_theoretical )
fprintf( '\n' )

fprintf( 'Range:\n' )
fprintf( '\tTheoretical: \t%9.3f \t[mV] \t(%6.2f [%%])\n', error_range_theoretical*( 10^3 ), error_range_percentage_theoretical )
fprintf( '\tNumerical: \t\t%9.3f \t[mV] \t(%6.2f [%%])\n', error_range_numerical*( 10^3 ), error_range_percentage_numerical )
fprintf( '\tDifference: \t%9.3e \t[mV] \t(%6.2f [%%])\n', ( error_range_numerical - error_range_theoretical )*( 10^3 ), error_range_percentage_numerical - error_range_percentage_theoretical )
fprintf( '\n' )

% Print the decoded absolute transmission summary statistics.
fprintf( '\n' )
fprintf( 'Absolute Transmission Summary Statistics (Decoded Outputs)\n' )
fprintf( '\n' )

fprintf( 'RMSE:\n' )
fprintf( '\tTheoretical: \t%9.3f \t[-] \t(%6.2f [%%])\n', error_rmse_theoretical_decoded, error_rmse_percentage_theoretical_decoded )
fprintf( '\tNumerical: \t\t%9.3f \t[-] \t(%6.2f [%%])\n', error_rmse_numerical_decoded, error_rmse_percentage_numerical_decoded )
fprintf( '\tDifference: \t%9.3e \t[-] \t(%6.2f [%%])\n', error_rmse_numerical_decoded - error_rmse_theoretical_decoded, error_rmse_percentage_numerical_decoded - error_rmse_percentage_theoretical_decoded )
fprintf( '\n' )

fprintf( 'STD:\n' )
fprintf( '\tTheoretical: \t%9.3f \t[-] \t(%6.2f [%%])\n', error_std_theoretical_decoded, error_std_percentage_theoretical_decoded )
fprintf( '\tNumerical: \t\t%9.3f \t[-] \t(%6.2f [%%])\n', error_std_numerical_decoded, error_std_percentage_numerical_decoded )
fprintf( '\tDifference: \t%9.3e \t[-] \t(%6.2f [%%])\n', error_std_numerical_decoded - error_std_theoretical_decoded, error_std_percentage_numerical_decoded - error_std_percentage_theoretical_decoded )
fprintf( '\n' )

fprintf( 'Min:\n' )
fprintf( '\tTheoretical: \t%9.3f \t[-] \t(%6.2f [%%]) \t@ \t(%9.3f [-], %9.3f [-])\n', error_min_theoretical_decoded, error_min_percentage_theoretical_decoded, Us_achieved_theoretical_decoded( index_min_theoretical_decoded, 1 ), Us_achieved_theoretical_decoded( index_min_theoretical_decoded, 2 ) )
fprintf( '\tNumerical: \t\t%9.3e \t[-] \t(%6.2f [%%]) \t@ \t(%9.3f [-], %9.3f [-])\n', error_min_numerical_decoded, error_min_percentage_numerical_decoded, Us_achieved_numerical_decoded( index_min_numerical_decoded, 1 ), Us_achieved_numerical_decoded( index_min_numerical_decoded, 2 ) )
fprintf( '\tDifference: \t%9.3e \t[-] \t(%6.2f [%%])\n', error_min_numerical_decoded - error_min_theoretical_decoded, error_min_percentage_numerical_decoded - error_min_percentage_theoretical_decoded )
fprintf( '\n' )

fprintf( 'Max:\n' )
fprintf( '\tTheoretical: \t%9.3f \t[-] \t(%6.2f [%%]) \t@ \t(%9.3f [-], %9.3f [-])\n', error_max_theoretical_decoded, error_max_percentage_theoretical_decoded, Us_achieved_theoretical_decoded( index_max_theoretical_decoded, 1 ), Us_achieved_theoretical_decoded( index_max_theoretical_decoded, 2 ) )
fprintf( '\tNumerical: \t\t%9.3f \t[-] \t(%6.2f [%%]) \t@ \t(%9.3f [-], %9.3f [-])\n', error_max_numerical_decoded, error_max_percentage_numerical_decoded, Us_achieved_numerical_decoded( index_max_numerical_decoded, 1 ), Us_achieved_numerical_decoded( index_max_numerical_decoded, 2 ) )
fprintf( '\tDifference: \t%9.3e \t[-] \t(%6.2f [%%])\n', error_max_numerical_decoded - error_max_theoretical_decoded, error_max_percentage_numerical_decoded - error_max_percentage_theoretical_decoded )
fprintf( '\n' )

fprintf( 'Range:\n' )
fprintf( '\tTheoretical: \t%9.3f \t[-] \t(%6.2f [%%])\n', error_range_theoretical_decoded, error_range_percentage_theoretical_decoded )
fprintf( '\tNumerical: \t\t%9.3f \t[-] \t(%6.2f [%%])\n', error_range_numerical_decoded, error_range_percentage_numerical_decoded )
fprintf( '\tDifference: \t%9.3e \t[-] \t(%6.2f [%%])\n', error_range_numerical_decoded - error_range_theoretical_decoded, error_range_percentage_numerical_decoded - error_range_percentage_theoretical_decoded )
fprintf( '\n' )


%% Plot the Absolute Transmission Network Results.

% Create a plot of the desired membrane voltage output.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Steady State Response (Desired)' ); hold on, grid on, xlabel( 'Input Neuron Membrane Voltage, U1 [mV]' ), ylabel( 'Output Neuron Membrane Voltage, U2 [mV]' ), title( 'Absolute Transmission Steady State Response (Desired)' )
plot( Us_desired( :, 1 )*( 10^3 ), Us_desired( :, 2 )*( 10^3 ), '-', 'Linewidth', 3 )
saveas( fig, [ save_directory, '\', 'absolute_transmission_ss_response_desired' ] )

% Create a plot of the achieved numerical membrane voltage output.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Steady State Response (Achieved Theoretical)' ); hold on, grid on, xlabel( 'Input Neuron Membrane Voltage, U1 [mV]' ), ylabel( 'Output Neuron Membrane Voltage, U2 [mV]' ), title( 'Absolute Transmission Steady State Response (Achieved Theoretical)' )
plot( Us_achieved_theoretical( :, 1 )*( 10^3 ), Us_achieved_theoretical( :, 2 )*( 10^3 ), '-', 'Linewidth', 3 )
saveas( fig, [ save_directory, '\', 'absolute_transmission_ss_response_achieved_theoretical' ] )

% Create a plot of the achieved numerical membrane voltage output.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Steady State Response (Achieved Numerical)' ); hold on, grid on, xlabel( 'Input Neuron Membrane Voltage, U1 [mV]' ), ylabel( 'Output Neuron Membrane Voltage, U2 [mV]' ), title( 'Absolute Transmission Steady State Response (Achieved Numerical)' )
plot( Us_achieved_numerical( :, 1 )*( 10^3 ), Us_achieved_numerical( :, 2 )*( 10^3 ), '-', 'Linewidth', 3 )
saveas( fig, [ save_directory, '\', 'absolute_transmission_ss_response_achieved_numerical' ] )

% Create a plot of the desired and achieved membrane voltage outputs.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Steady State Response (Comparison)' ); hold on, grid on, xlabel( 'Input Neuron Membrane Voltage, U1 [mV]' ), ylabel( 'Output Neuron Membrane Voltage, U2 [mV]' ), title( 'Absolute Transmission Steady State Response (Comparison)' )
h1 = plot( Us_desired( :, 1 )*( 10^3 ), Us_desired( :, 2 )*( 10^3 ), '-', 'Linewidth', 3 );
h2 = plot( Us_achieved_theoretical( :, 1 )*( 10^3 ), Us_achieved_theoretical( :, 2 )*( 10^3 ), '-.', 'Linewidth', 3 );
h3 = plot( Us_achieved_numerical( :, 1 )*( 10^3 ), Us_achieved_numerical( :, 2 )*( 10^3 ), '--', 'Linewidth', 3 );
legend( [ h1, h2, h3 ], { 'Desired', 'Achieved (Theoretical)', 'Achieved (Numerical)' }, 'Location', 'Best' )
saveas( fig, [ save_directory, '\', 'absolute_transmission_ss_response_comparison' ] )

% Create a plot of the desired and achieved membrane voltage outputs.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Steady State Decoding (Comparison)' ); hold on, grid on, xlabel( 'Input, x [-]' ), ylabel( 'Output, y [-]' ), title( 'Absolute Transmission Steady State Decoding (Comparison)' )
h1 = plot( Us_desired_decoded( :, 1 ), Us_desired_decoded( :, 2 ), '-', 'Linewidth', 3 );
h2 = plot( Us_achieved_theoretical_decoded( :, 1 ), Us_achieved_theoretical_decoded( :, 2 ), '-.', 'Linewidth', 3 );
h3 = plot( Us_achieved_numerical_decoded( :, 1 ), Us_achieved_numerical_decoded( :, 2 ), '--', 'Linewidth', 3 );
legend( [ h1, h2, h3 ], { 'Desired', 'Achieved (Theoretical)', 'Achieved (Numerical)' }, 'Location', 'Best' )
saveas( fig, [ save_directory, '\', 'absolute_transmission_ss_decoding_comparison' ] )

% Create a surface that shows the membrane voltage error.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Steady State Error' ); hold on, grid on, xlabel( 'Input Neuron Membrane Voltage, U1 [mV]' ), ylabel( 'Membrane Voltage Error, E [mV]' ), title( 'Absolute Transmission Steady State Error' )
plot( Us_achieved_theoretical( :, 1 )*( 10^3 ), errors_theoretical*( 10^3 ), '-', 'Linewidth', 3 )
plot( Us_achieved_numerical( :, 1 )*( 10^3 ), errors_numerical*( 10^3 ), '--', 'Linewidth', 3 )
legend( { 'Theoretical', 'Numerical' }, 'Location', 'Best', 'Orientation', 'Horizontal' )
saveas( fig, [ save_directory, '\', 'absolute_transmission_ss_response_error' ] )

% Create a surface that shows the decoding error.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Steady State Decoding Error' ); hold on, grid on, xlabel( 'Input, x [-]' ), ylabel( 'Decoding Error, E [-]' ), title( 'Absolute Transmission Steady State Decoding Error' )
plot( Us_achieved_theoretical_decoded( :, 1 ), errors_theoretical_decoded, '-', 'Linewidth', 3 )
plot( Us_achieved_numerical_decoded( :, 1 ), errors_numerical_decoded, '--', 'Linewidth', 3 )
legend( { 'Theoretical', 'Numerical' }, 'Location', 'Best', 'Orientation', 'Horizontal' )
saveas( fig, [ save_directory, '\', 'absolute_transmission_ss_response_decoding_error' ] )

% Create a surface that shows the decoding error.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Steady State Error Percentage' ); hold on, grid on, xlabel( 'Input, x [-]' ), ylabel( 'Membrane Voltage Error Percentage, E [%]' ), title( 'Absolute Transmission Steady State Error Percentage' )
plot( Us_achieved_theoretical( :, 1 ), error_percentages_theoretical, '-', 'Linewidth', 3 )
plot( Us_achieved_numerical( :, 1 ), error_percentages_numerical, '--', 'Linewidth', 3 )
legend( { 'Theoretical', 'Numerical' }, 'Location', 'Best', 'Orientation', 'Horizontal' )
saveas( fig, [ save_directory, '\', 'absolute_transmission_ss_response_error_percentage' ] )

% Create a surface that shows the decoding error.
fig = figure( 'Color', 'w', 'Name', 'Absolute Transmission Steady State Decoding Error Percentage' ); hold on, grid on, xlabel( 'Input, x [-]' ), ylabel( 'Membrane Voltage Decoding Error Percentage, E [%]' ), title( 'Absolute Transmission Steady State Decoding Error Percentage' )
plot( Us_achieved_theoretical_decoded( :, 1 ), error_percentages_theoretical_decoded, '-', 'Linewidth', 3 )
plot( Us_achieved_numerical_decoded( :, 1 ), error_percentages_numerical_decoded, '--', 'Linewidth', 3 )
legend( { 'Theoretical', 'Numerical' }, 'Location', 'Best', 'Orientation', 'Horizontal' )
saveas( fig, [ save_directory, '\', 'absolute_transmission_ss_response_decoding_error_percentage' ] )

