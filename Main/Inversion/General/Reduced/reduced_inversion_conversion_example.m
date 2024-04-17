%% Reduced Inversion Subnetwork Conversion Example.

% Clear everything.
clear, close( 'all' ), clc


%% Set the Simulation Parameters.

% Define the network integration step size.
network_dt = 1.3e-4;                                                                                    % [s] Simulation Step Size.

% Define the network simulation duration.
network_tf = 3;                                                                                         % [s] Simulation Duration.

% Define the applied current state.
% current_state = 0;                                                                                    % [0-1] Current Activation Ratio (0 = Input Current Completely Off, 1 = Input Current Completely On).
% current_state = 0.25;                                                                              	% [0-1] Current Activation Ratio (0 = Input Current Completely Off, 1 = Input Current Completely On).
current_state = 1;                                                                                      % [0-1] Current Activation Ratio (0 = Input Current Completely Off, 1 = Input Current Completely On).


%% Define the Fundamental Parameters of a Relative Inversion Subnetwork.

% Define the maximum membrane voltages.
R1_relative = 20e-3;                                                                                    % [V] Maximum Voltage (Neuron 1).
R2_relative = 20e-3;                                                                                    % [V] Maximum Voltage (Neuron 2).

% Define the membrane conductances.
Gm1_relative = 1e-6;                                                                                    % [S] Membrane Conductance (Neuron 1).
Gm2_relative = 1e-6;                                                                                    % [S] Membrane Conductance (Neuron 2).

% Define the membrane capacitance.
Cm1_relative = 5e-9;                                                                                    % [F] Membrane Capacitance (Neuron 1).
Cm2_relative = 5e-9;                                                                                    % [F] Membrane Capacitance (Neuron 2).

% Define the applied currents.
% Ia1_relative = 0;                                                                                     % [A] Applied Current (Neuron 1).
Ia1_relative = R1_relative*Gm1_relative;                                                                % [A] Applied Current (Neuron 1).

% Define the sodium channel conductance.
Gna1_relative = 0;                                                                                      % [S] Sodium Channel Conductance (Neuron 1).
Gna2_relative = 0;                                                                                      % [S] Sodium Channel Conductance (Neuron 2).

% Define the network design parameters.
delta_relative = 1e-3;                                                                                  % [V] Membrane Voltage Offset.


%% Compute the Derived Parameters of a Relative Inversion Subnetwork.

% Compute the network properties.
c1_relative = delta_relative/( R2_relative - delta_relative );                                          % [-] Design Constant 1.
c2_relative = c1_relative;                                                                           	% [-] Design Constant 2.
Ia2_relative = R2_relative*Gm2_relative;                                                               	% [A] Applied Current (Neuron 2).
dEs21_relative = 0;                                                                                    	% [V] Synaptic Reversal Potential (Synapse 21).
gs21_relative = ( Ia2_relative - delta_relative*Gm2_relative )/( delta_relative - dEs21_relative );    	% [S] Synaptic Conductance (Synapse 21).


%% Print Reduced Relative Subnetwork Parameters.

% Print out a header.
fprintf( '\n------------------------------------------------------------\n' )
fprintf( '------------------------------------------------------------\n' )
fprintf( 'REDUCED RELATIVE INVERSION SUBNETWORK PARAMETERS:\n' )
fprintf( '------------------------------------------------------------\n' )

% Print out neuron information.
fprintf( 'Neuron Parameters:\n' )
fprintf( 'R1 \t\t= \t%0.2f \t[mV]\n', R1_relative*( 10^3 ) )
fprintf( 'R2 \t\t= \t%0.2f \t[mV]\n', R2_relative*( 10^3 ) )

fprintf( 'Gm1 \t= \t%0.2f \t[muS]\n', Gm1_relative*( 10^6 ) )
fprintf( 'Gm2 \t= \t%0.2f \t[muS]\n', Gm2_relative*( 10^6 ) )

fprintf( 'Cm1 \t= \t%0.2f \t[nF]\n', Cm1_relative*( 10^9 ) )
fprintf( 'Cm2 \t= \t%0.2f \t[nF]\n', Cm2_relative*( 10^9 ) )

fprintf( 'Gna1 \t= \t%0.2f \t[muS]\n', Gna1_relative*( 10^6 ) )
fprintf( 'Gna2 \t= \t%0.2f \t[muS]\n', Gna2_relative*( 10^6 ) )
fprintf( '\n' )

% Print out the synapse information.
fprintf( 'Synapse Parameters:\n' )
fprintf( 'dEs21 \t= \t%0.2f \t[mV]\n', dEs21_relative*( 10^3 ) )
fprintf( 'gs21 \t= \t%0.2f \t[muS]\n', gs21_relative*( 10^6 ) )
fprintf( '\n' )

% Print out the applied current information.
fprintf( 'Applied Curent Parameters:\n' )
fprintf( 'Ia1 \t= \t%0.2f \t[nA]\n', current_state*Ia1_relative*( 10^9 ) )
fprintf( 'Ia2 \t= \t%0.2f \t[nA]\n', Ia2_relative*( 10^9 ) )
fprintf( '\n' )

% Print out the network design parameters.
fprintf( 'Network Design Parameters:\n' )
fprintf( 'c1 \t\t= \t%0.2e \t[-]\n', c1_relative )
fprintf( 'c2 \t\t= \t%0.2e \t[-]\n', c2_relative )
fprintf( 'delta \t= \t%0.2f \t[mV]\n', delta_relative*( 10^3 ) )

% Print out ending information.
fprintf( '------------------------------------------------------------\n' )
fprintf( '------------------------------------------------------------\n' )


%% Create the Relative Inversion Subnetwork.

% Create an instance of the network class.
network_relative = network_class( network_dt, network_tf );

% Create the relative network components.
[ network_relative.neuron_manager, neuron_IDs_relative ] = network_relative.neuron_manager.create_neurons( 2 );
[ network_relative.synapse_manager, synapse_IDs_relative ] = network_relative.synapse_manager.create_synapses( 1 );
[ network_relative.applied_current_manager, applied_current_IDs_relative ] = network_relative.applied_current_manager.create_applied_currents( 2 );

% Set the relative network neuron parameters.
network_relative.neuron_manager = network_relative.neuron_manager.set_neuron_property( neuron_IDs_relative, [ Gna1_relative, Gna2_relative ], 'Gna' );
network_relative.neuron_manager = network_relative.neuron_manager.set_neuron_property( neuron_IDs_relative, [ R1_relative, R2_relative ], 'R' );
network_relative.neuron_manager = network_relative.neuron_manager.set_neuron_property( neuron_IDs_relative, [ Gm1_relative, Gm2_relative ], 'Gm' );
network_relative.neuron_manager = network_relative.neuron_manager.set_neuron_property( neuron_IDs_relative, [ Cm1_relative, Cm2_relative ], 'Cm' );

% Set the relative network synapse parameters.
network_relative.synapse_manager = network_relative.synapse_manager.set_synapse_property( synapse_IDs_relative, 1, 'from_neuron_ID' );
network_relative.synapse_manager = network_relative.synapse_manager.set_synapse_property( synapse_IDs_relative, 2, 'to_neuron_ID' );
network_relative.synapse_manager = network_relative.synapse_manager.set_synapse_property( synapse_IDs_relative, gs21_relative, 'g_syn_max' );
network_relative.synapse_manager = network_relative.synapse_manager.set_synapse_property( synapse_IDs_relative, dEs21_relative, 'dE_syn' );

% Set the relative network applied current parameters.
network_relative.applied_current_manager = network_relative.applied_current_manager.set_applied_current_property( applied_current_IDs_relative, [ 1, 2 ], 'neuron_ID' );
network_relative.applied_current_manager = network_relative.applied_current_manager.set_applied_current_property( applied_current_IDs_relative, [ current_state*Ia1_relative, Ia2_relative ], 'I_apps' );


%% Convert the Relative Inversion Parameters to Fundamental Absolute Inversion Parameters.

% Convert the maximum membrane voltages.
R1_absolute = R1_relative;                                                                                      % [V] Maximum Membrane Voltage (Neuron 1).

% Convert the membrane conductances.
Gm1_absolute = Gm1_relative;                                                                                    % [S] Membrane Conductance (Neuron 1).
Gm2_absolute = Gm2_relative;                                                                                    % [S] Membrane Conductance (Neuron 2).

% Convert the membrane capacitances.
Cm1_absolute = Cm1_relative;                                                                                    % [F] Membrane Capacitance (Neuron 1).
Cm2_absolute = Cm2_relative;                                                                                    % [F] Membrane Capacitance (Neuron 2).

% Convert the applied currents.
Ia1_absolute = Ia1_relative;                                                                                    % [A] Applied Current (Neuron 1).

% Convert the sodium channel conductances.
Gna1_absolute = Gna1_relative;                                                                                  % [S] Sodium Channel Conductance (Neuron 1).
Gna2_absolute = Gna2_relative;                                                                                  % [S] Sodium Channel Conductance (Neuron 2).

% Convert design constants.
delta_absolute = delta_relative;                                                                                % [V] Membrane Voltage Offset.
c1_absolute = ( R1_relative*R2_relative*delta_relative )/( R2_relative - delta_relative );                      % [V^2] Design Constant 1.


%% Compute the Derived Parameters of the Absolute Inversion Subnetwork.

% Compute the network_absolute properties.
c2_absolute = ( c1_absolute - delta_absolute*R1_absolute )/delta_absolute;                                      % [V] Design Constant 2.
R2_absolute = c1_absolute/c2_absolute;                                                                          % [V] Maximum Membrane Voltage
Ia2_absolute = R2_absolute*Gm2_absolute;                                                                        % [A] Applied Current (Neuron 2).
dEs21_absolute = 0;                                                                                             % [V] Synaptic Reversal Potential (Synapse 21).
gs21_absolute = ( R1_absolute*Ia2_absolute )/( c1_absolute - c2_absolute*dEs21_absolute );                      % [S] Synaptic Conductance (Synapse 21).


%% Print the Reduced Absolute Inversion Subnetwork Parameters.

% Print out a header.
fprintf( '\n------------------------------------------------------------\n' )
fprintf( '------------------------------------------------------------\n' )
fprintf( 'REDUCED ABSOLUTE INVERSION SUBNETWORK PARAMETERS:\n' )
fprintf( '------------------------------------------------------------\n' )

% Print out neuron information.
fprintf( 'Neuron Parameters:\n' )
fprintf( 'R1 \t\t= \t%0.2f \t[mV]\n', R1_absolute*( 10^3 ) )
fprintf( 'R2 \t\t= \t%0.2f \t[mV]\n', R2_absolute*( 10^3 ) )

fprintf( 'Gm1 \t= \t%0.2f \t[muS]\n', Gm1_absolute*( 10^6 ) )
fprintf( 'Gm2 \t= \t%0.2f \t[muS]\n', Gm2_absolute*( 10^6 ) )

fprintf( 'Cm1 \t= \t%0.2f \t[nF]\n', Cm1_absolute*( 10^9 ) )
fprintf( 'Cm2 \t= \t%0.2f \t[nF]\n', Cm2_absolute*( 10^9 ) )

fprintf( 'Gna1 \t= \t%0.2f \t[muS]\n', Gna1_absolute*( 10^6 ) )
fprintf( 'Gna2 \t= \t%0.2f \t[muS]\n', Gna2_absolute*( 10^6 ) )
fprintf( '\n' )

% Print out the synapse information.
fprintf( 'Synapse Parameters:\n' )
fprintf( 'dEs21 \t= \t%0.2f \t[mV]\n', dEs21_absolute*( 10^3 ) )
fprintf( 'gs21 \t= \t%0.2f \t[muS]\n', gs21_absolute*( 10^6 ) )
fprintf( '\n' )

% Print out the applied current information.
fprintf( 'Applied Curent Parameters:\n' )
fprintf( 'Ia1 \t= \t%0.2f \t[nA]\n', current_state*Ia1_absolute*( 10^9 ) )
fprintf( 'Ia2 \t= \t%0.2f \t[nA]\n', Ia2_absolute*( 10^9 ) )
fprintf( '\n' )

% Print out the network design parameters.
fprintf( 'Network Design Parameters:\n' )
fprintf( 'c1 \t\t= \t%0.2f \t[mV^2]\n', c1_absolute*( 10^6 ) )
fprintf( 'c2 \t\t= \t%0.2f \t[mV]\n', c2_absolute*( 10^3 ) )
fprintf( 'delta \t= \t%0.2f \t[mV]\n', delta_absolute*( 10^3 ) )

% Print out ending information.
fprintf( '------------------------------------------------------------\n' )
fprintf( '------------------------------------------------------------\n' )


%% Create the Reduced Absolute Inversion Subnetwork.

% Create an instance of the network_absolute class.
network_absolute = network_class( network_dt, network_tf );

% Create the network_absolute components.
[ network_absolute.neuron_manager, neuron_IDs_absolute ] = network_absolute.neuron_manager.create_neurons( 2 );
[ network_absolute.synapse_manager, synapse_IDs_absolute ] = network_absolute.synapse_manager.create_synapses( 1 );
[ network_absolute.applied_current_manager, applied_current_IDs_absolute ] = network_absolute.applied_current_manager.create_applied_currents( 2 );

% Set the absolute network neuron parameters.
network_absolute.neuron_manager = network_absolute.neuron_manager.set_neuron_property( neuron_IDs_absolute, [ Gna1_absolute, Gna2_absolute ], 'Gna' );
network_absolute.neuron_manager = network_absolute.neuron_manager.set_neuron_property( neuron_IDs_absolute, [ R1_absolute, R2_absolute ], 'R' );
network_absolute.neuron_manager = network_absolute.neuron_manager.set_neuron_property( neuron_IDs_absolute, [ Gm1_absolute, Gm2_absolute ], 'Gm' );

% Set the absolute network synapse parameters.
network_absolute.synapse_manager = network_absolute.synapse_manager.set_synapse_property( synapse_IDs_absolute, 1, 'from_neuron_ID' );
network_absolute.synapse_manager = network_absolute.synapse_manager.set_synapse_property( synapse_IDs_absolute, 2, 'to_neuron_ID' );
network_absolute.synapse_manager = network_absolute.synapse_manager.set_synapse_property( synapse_IDs_absolute, gs21_absolute, 'g_syn_max' );
network_absolute.synapse_manager = network_absolute.synapse_manager.set_synapse_property( synapse_IDs_absolute, dEs21_absolute, 'dE_syn' );

% Set the absolute network applied current parameters.
network_absolute.applied_current_manager = network_absolute.applied_current_manager.set_applied_current_property( applied_current_IDs_absolute, [ 1, 2 ], 'neuron_ID' );
network_absolute.applied_current_manager = network_absolute.applied_current_manager.set_applied_current_property( applied_current_IDs_absolute, [ current_state*Ia1_absolute, Ia2_absolute ], 'I_apps' );


%% Simulate the Reduced Relative Inversion Subnetwork.

% Start the timer.
tic

% Simulate the network.
[ network_relative, ts_relative, Us_relative, hs_relative, dUs_relative, dhs_relative, G_syns_relative, I_leaks_relative, I_syns_relative, I_nas_relative, I_apps_relative, I_totals_relative, m_infs_relative, h_infs_relative, tauhs_relative, neuron_IDs_relative ] = network_relative.compute_set_simulation(  );

% End the timer.
relative_simulation_duration = toc;


%% Simulate the Reduced Absolute Inversion Subnetwork.

% Start the timer.
tic

% Simulate the network.
[ network_absolute, ts_absolute, Us_absolute, hs_absolute, dUs_absolute, dhs_absolute, G_syns_absolute, I_leaks_absolute, I_syns_absolute, I_nas_absolute, I_apps_absolute, I_totals_absolute, m_infs_absolute, h_infs_absolute, tauhs_absolute, neuron_IDs_absolute ] = network_absolute.compute_set_simulation(  );

% End the timer.
absolute_simulation_duration = toc;


%% Plot the Reduced Inversion Subnetwork Results.

% Plot the network currents over time.
fig_relative_network_currents = network_relative.network_utilities.plot_network_currents( ts_relative, I_leaks_relative, I_syns_relative, I_nas_relative, I_apps_relative, I_totals_relative, neuron_IDs_relative );
fig_absolute_network_currents = network_absolute.network_utilities.plot_network_currents( ts_absolute, I_leaks_absolute, I_syns_absolute, I_nas_absolute, I_apps_absolute, I_totals_absolute, neuron_IDs_absolute );

% Plot the network states over time.
fig_relative_network_states = network_relative.network_utilities.plot_network_states( ts_relative, Us_relative, hs_relative, neuron_IDs_relative );
fig_absolute_network_states = network_absolute.network_utilities.plot_network_states( ts_absolute, Us_absolute, hs_absolute, neuron_IDs_absolute );

% Animate the network states over time.
fig_relative_network_animation = network_relative.network_utilities.animate_network_states( Us_relative, hs_relative, neuron_IDs_relative );
fig_absolute_network_animation = network_absolute.network_utilities.animate_network_states( Us_absolute, hs_absolute, neuron_IDs_absolute );

