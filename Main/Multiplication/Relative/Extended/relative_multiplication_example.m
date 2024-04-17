%% Relative Multiplication Subnetwork Example.

% Clear Everything.
clear, close('all'), clc


%% Define Simulation Parameters.

% Set the level of verbosity.
b_verbose = true;                                                                                               % [T/F] Verbosity Flag.

% Define the network integration step size.
network_dt = 1e-4;                                                                                              % [s] Network Integration Timestep.
% network_dt = 1e-5;                                                                                            % [s] Network Integration Timestep.

% Define network simulation duration.
network_tf = 3;                                                                                                 % [s] Network Simulation Duration.


%% Define Basic Relative Multiplication Subnetwork Parameters.

% Define neuron maximum membrane voltages.
R1 = 20e-3;                                                                                                     % [V] Maximum Membrane Voltage (Neuron 1).
R2 = 20e-3;                                                                                                     % [V] Maximum Membrane Voltage (Neuron 2).
R3 = 20e-3;                                                                                                     % [V] Maximum Membrane Voltage (Neuron 3).
R4 = 20e-3;                                                                                                     % [V] Maximum Membrane Voltage (Neuron 4).

% Define the membrane conductances.
Gm1 = 1e-6;                                                                                                     % [S] Membrane Conductance (Neuron 1).
Gm2 = 1e-6;                                                                                                     % [S] Membrane Conductance (Neuron 2).
Gm3 = 1e-6;                                                                                                     % [S] Membrane Conductance (Neuron 3).
Gm4 = 1e-6;                                                                                                     % [S] Membrane Conductance (Neuron 4).

% Define the membrane capacitances.
Cm1 = 5e-9;                                                                                                     % [F] Membrance Conductance (Neuron 1).
Cm2 = 5e-9;                                                                                                     % [F] Membrance Conductance (Neuron 2).
Cm3 = 5e-9;                                                                                                 	% [F] Membrance Conductance (Neuron 3).
Cm4 = 5e-9;                                                                                                 	% [F] Membrance Conductance (Neuron 4).

% Define the sodium channel conductances.
Gna1 = 0;                                                                                                       % [S] Sodium Channel Conductance (Neuron 1).
Gna2 = 0;                                                                                                   	% [S] Sodium Channel Conductance (Neuron 2).
Gna3 = 0;                                                                                                       % [S] Sodium Channel Conductance (Neuron 3).
Gna4 = 0;                                                                                                       % [S] Sodium Channel Conductance (Neuron 4).

% Define the synaptic reversal potential.
dEs32 = 0;                                                                                                      % [V] Synaptic Reversal Potential (Synapse 32).
dEs41 = 194e-3;                                                                                                 % [V] Synaptic Reversal Potential (Synapse 41).
dEs43 = 0;                                                                                                      % [V] Synaptic Reversal Potential (Synapse 43).

% Define the applied currents.
Ia1 = R1*Gm1;                                                                                                   % [A] Applied Current (Neuron 1).
Ia2 = R2*Gm2;                                                                                                   % [A] Applied Current (Neuron 2).
Ia3 = R3*Gm3;                                                                                                   % [A] Applied Current (Neuron 3).
Ia4 = 0;                                                                                                        % [A] Applied Current (Neuron 4).

% Define the input current states.
% current_state1 = 0;                                                                                        	% [%] Applied Current Activity Percentage (Neuron 1). 
current_state1 = 1;                                                                                             % [%] Applied Current Activity Percentage (Neuron 1). 
% current_state2 = 0;                                                                                          	% [%] Applied Current Activity Percentage (Neuron 2). 
current_state2 = 1;                                                                                         	% [%] Applied Current Activity Percentage (Neuron 2). 

% Define the subnetwork voltage offsets.
delta1 = 1e-3;                                                                                                  % [V] Inversion Membrane Voltage Offset.
delta2 = 2e-3;                                                                                                  % [V] Division Membrane Voltage Offset.

% Define subnetwork design constants.
c3 = 1e-6;                                                                                                      % [-] Relative Multiplication Parameter 3 (Relative Inversion Parameter 3).
c6 = 1e-6;                                                                                                      % [S] Relative Multiplication Parameter 6 (Relative Division After Inversion Parameter 3).


%% Compute Derived Relative Multiplication Subnetwork Parameters.

% Compute the network design parameters.
c1 = c3;                                                                                                        % [-] Relative Multiplication Parameter 1 (Relative Inversion Parameter 1).
c2 = ( ( R3 - delta1 )*c3 )/( delta1 );                                                                         % [-] Relative Multiplication Parameter 2 (Relative Inversion Parameter 2).
c4 = ( ( R3 - delta1 )*c6*delta2 )/( R3*delta2 - R4*delta1 );                                               	% [S] Relative Multiplication Parameter 4 (Relative Division After Inversion Parameter 1).
c5 = ( ( R4 - delta2 )*c6*R3 )/( R3*delta2 - R4*delta1 );                                                   	% [S] Relative Multiplication Parameter 5 (Relative Division After Inversion Parameter 2).

% Compute the synaptic conductances.
gs32 = ( ( R3 - delta1 )*c3 )/( delta1 );                                                                       % [S] Synaptic Conductance (Synapse 32).
gs41 = ( ( delta1 - R3 )*delta2*R4*Gm4 )/( ( R3 - delta1 )*delta2*R4 + ( R4*delta1 - R3*delta2 )*dEs41 );       % [S] Maximum Synaptic Conductance (Synapse 41).
gs43 = ( ( delta2 - R4 )*dEs41*R3*Gm4 )/( ( R3 - delta1 )*delta2*R4 + ( R4*delta1 - R3*delta2 )*dEs41 );        % [S] Maximum Synaptic Conductance (Synapse 43).


%% Print Relative Multiplication Subnetwork Parameters.

% Print out a header.
fprintf( '\n------------------------------------------------------------\n' )
fprintf( '------------------------------------------------------------\n' )
fprintf( 'RELATIVE MULTIPLICATION SUBNETWORK PARAMETERS:\n' )
fprintf( '------------------------------------------------------------\n' )

% Print out neuron information.
fprintf( 'Neuron Parameters:\n' )
fprintf( 'R1 \t\t= \t%0.2f \t[mV]\n', R1*( 10^3 ) )
fprintf( 'R2 \t\t= \t%0.2f \t[mV]\n', R2*( 10^3 ) )
fprintf( 'R3 \t\t= \t%0.2f \t[mV]\n', R3*( 10^3 ) )
fprintf( 'R4 \t\t= \t%0.2f \t[mV]\n', R4*( 10^3 ) )
fprintf( '\n' )

fprintf( 'Gm1 \t= \t%0.2f \t[muS]\n', Gm1*( 10^6 ) )
fprintf( 'Gm2 \t= \t%0.2f \t[muS]\n', Gm2*( 10^6 ) )
fprintf( 'Gm3 \t= \t%0.2f \t[muS]\n', Gm3*( 10^6 ) )
fprintf( 'Gm4 \t= \t%0.2f \t[muS]\n', Gm4*( 10^6 ) )
fprintf( '\n' )

fprintf( 'Cm1 \t= \t%0.2f \t[nF]\n', Cm1*( 10^9 ) )
fprintf( 'Cm2 \t= \t%0.2f \t[nF]\n', Cm2*( 10^9 ) )
fprintf( 'Cm3 \t= \t%0.2f \t[nF]\n', Cm3*( 10^9 ) )
fprintf( 'Cm4 \t= \t%0.2f \t[nF]\n', Cm4*( 10^9 ) )
fprintf( '\n' )

fprintf( 'Gna1 \t= \t%0.2f \t[muS]\n', Gna1*( 10^6 ) )
fprintf( 'Gna2 \t= \t%0.2f \t[muS]\n', Gna2*( 10^6 ) )
fprintf( 'Gna3 \t= \t%0.2f \t[muS]\n', Gna3*( 10^6 ) )
fprintf( 'Gna4 \t= \t%0.2f \t[muS]\n', Gna4*( 10^6 ) )
fprintf( '\n' )

% Print out the synapse information.
fprintf( 'Synapse Parameters:\n' )
fprintf( 'dEs32 \t= \t%0.2f \t[mV]\n', dEs32*( 10^3 ) )
fprintf( 'dEs41 \t= \t%0.2f \t[mV]\n', dEs41*( 10^3 ) )
fprintf( 'dEs43 \t= \t%0.2f \t[mV]\n', dEs43*( 10^3 ) )
fprintf( '\n' )

fprintf( 'gs32 \t= \t%0.2f \t[muS]\n', gs32*( 10^6 ) )
fprintf( 'gs41 \t= \t%0.2f \t[muS]\n', gs41*( 10^6 ) )
fprintf( 'gs43 \t= \t%0.2f \t[muS]\n', gs43*( 10^6 ) )
fprintf( '\n' )

% Print out the applied current information.
fprintf( 'Applied Curent Parameters:\n' )
fprintf( 'Ia1 \t= \t%0.2f \t[nA]\n', Ia1*( 10^9 ) )
fprintf( 'Ia2 \t= \t%0.2f \t[nA]\n', Ia2*( 10^9 ) )
fprintf( 'Ia3 \t= \t%0.2f \t[nA]\n', Ia3*( 10^9 ) )
fprintf( 'Ia4 \t= \t%0.2f \t[nA]\n', Ia4*( 10^9 ) )
fprintf( '\n' )

fprintf( 'p1 \t\t= \t%0.0f \t\t[-]\n', current_state1 )
fprintf( 'p2 \t\t= \t%0.0f \t\t[-]\n', current_state2 )
fprintf( '\n' )

% Print out the network design parameters.
fprintf( 'Network Design Parameters:\n' )
fprintf( 'c1 \t\t= \t%0.2f \t[nW]\n', c1*( 10^9 ) )
fprintf( 'c2 \t\t= \t%0.2f \t[muS]\n', c2*( 10^6 ) )
fprintf( 'c3 \t\t= \t%0.2f \t[nA]\n', c3*( 10^9 ) )
fprintf( 'c4 \t\t= \t%0.2f \t[nW]\n', c4*( 10^9 ) )
fprintf( 'c5 \t\t= \t%0.2f \t[nA]\n', c5*( 10^9 ) )
fprintf( 'c6 \t\t= \t%0.2f \t[nW]\n', c6*( 10^9 ) )
fprintf( '\n' )

fprintf( 'delta1 \t= \t%0.2f \t[mV]\n', delta1*( 10^3 ) )
fprintf( 'delta2 \t= \t%0.2f \t[mV]\n', delta2*( 10^3 ) )

% Print out ending information.
fprintf( '------------------------------------------------------------\n' )
fprintf( '------------------------------------------------------------\n' )


%% Create a Relative Multiplication Subnetwork.

% Create an instance of the network class.
network = network_class( network_dt, network_tf );

% Create the network components.
[ network.neuron_manager, neuron_IDs ] = network.neuron_manager.create_neurons( 4 );
[ network.synapse_manager, synapse_IDs ] = network.synapse_manager.create_synapses( 3 );
[ network.applied_current_manager, applied_current_IDs ] = network.applied_current_manager.create_applied_currents( 4 );

% Set the neuron parameters.
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs, [ R1, R2, R3, R4 ], 'R' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs, [ Gm1, Gm2, Gm3, Gm4 ], 'Gm' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs, [ Cm1, Cm2, Cm3, Cm4 ], 'Cm' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs, [ Gna1, Gna2, Gna3, Gna4 ], 'Gna' );

% Set the synapse parameters.
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs, [ 2, 1, 3 ], 'from_neuron_ID' );
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs, [ 3, 4, 4 ], 'to_neuron_ID' );
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs, [ gs32, gs41, gs43 ], 'g_syn_max' );
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs, [ dEs32, dEs41, dEs43 ], 'dE_syn' );

% Set the applied current parameters.
network.applied_current_manager = network.applied_current_manager.set_applied_current_property( applied_current_IDs, [ 1, 2, 3, 4 ], 'neuron_ID' );
network.applied_current_manager = network.applied_current_manager.set_applied_current_property( applied_current_IDs, [ current_state1*Ia1, current_state2*Ia2, Ia3, Ia4 ], 'I_apps' );


%% Compute the Relative Multiplication Numerical Stability Analysis Parameters.

% Compute the maximum RK4 step size and condition number.
[ A, dt_max, condition_number ] = network.RK4_stability_analysis( cell2mat( network.neuron_manager.get_neuron_property( 'all', 'Cm' ) ), cell2mat( network.neuron_manager.get_neuron_property( 'all', 'Gm' ) ), cell2mat( network.neuron_manager.get_neuron_property( 'all', 'R' ) ), network.get_gsynmaxs( 'all' ), network.get_dEsyns( 'all' ), zeros( network.neuron_manager.num_neurons, 1 ), 1e-6 );

% Print out the stability information.
fprintf( '\nSTABILITY SUMMARY:\n' )
fprintf( 'Linearized System Matrix: A =\n\n' ), disp( A )
fprintf( 'Max RK4 Step Size: \tdt_max = %0.3e [s]\n', dt_max )
fprintf( 'Proposed Step Size: \tdt = %0.3e [s]\n', network_dt )
fprintf( 'Condition Number: \tcond( A ) = %0.3e [-]\n', condition_number )


%% Simulate the Relative Multiplication Subnetwork Results.

% Start the timer.
tic

% Simulate the network.
[ network, ts, Us, hs, dUs, dhs, G_syns, I_leaks, I_syns, I_nas, I_apps, I_totals, m_infs, h_infs, tauhs, neuron_IDs ] = network.compute_set_simulation(  );

% End the timer.
toc


%% Plot the Relative Multiplication Subnetwork Results.

% Plot the network currents over time.
fig_network_currents = network.network_utilities.plot_network_currents( ts, I_leaks, I_syns, I_nas, I_apps, I_totals, neuron_IDs );

% Plot the network states over time.
fig_network_states = network.network_utilities.plot_network_states( ts, Us, hs, neuron_IDs );

% Animate the network states over time.
fig_network_animation = network.network_utilities.animate_network_states( Us, hs, neuron_IDs );

