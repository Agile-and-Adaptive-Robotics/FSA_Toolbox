classdef applied_voltage_class
    
    % This class contains properties and methods related to applied voltages.
    
    
    %% APPLIED VOLTAGE PROPERTIES
    
    % Define the class properties.
    properties
        
        ID
        name
        neuron_ID
        
        ts
        V_apps
        
        num_timesteps
        dt
        tf
        
        b_enabled
        
        array_utilities
        applied_voltage_utilities
        
    end
    
    
    %% APPLIED VOLTAGE METHODS SETUP
    
    % Define the class methods.
    methods
        
        % Implement the class constructor.
        function self = applied_voltage_class( ID, name, neuron_ID, ts, V_apps, b_enabled )
            
            % Create an instance of the array manager class.
            self.array_utilities = array_utilities_class(  );
            
            % Create an instance of the array manager class.
            self.applied_voltage_utilities = applied_voltage_utilities_class(  );
            
            % Set the default properties.
            if nargin < 6, self.b_enabled = true; else, self.b_enabled = b_enabled; end
            if nargin < 5, self.V_apps = { [  ] }; else, self.V_apps = V_apps; end
            if nargin < 4, self.ts = 0; else, self.ts = ts; end
            if nargin < 3, self.neuron_ID = 0; else, self.neuron_ID = neuron_ID; end
            if nargin < 2, self.name = ''; else, self.name = name; end
            if nargin < 1, self.ID = 0; else, self.ID = ID; end
            
            % Validate the applied voltage.
            self.validate_applied_voltage(  )
            
            % Compute the number of timesteps.
            self = self.compute_set_num_timesteps(  );
            
            % Compute and set the step size.
            self = self.compute_set_dt(  );
            
            % Compute and set the final time.
            self = self.compute_set_tf(  );
            
        end
        
        
        %% Get & Set Functions
        
        % Implement a function to set the applied voltage vector.
        function self = set_applied_voltage( self, ts, V_apps )
            
            % Set the default input arugments.
            if nargin < 3, V_apps = 0; end
            if nargin < 2, ts = 0; end
            
            % Ensure that there are the same number of time steps as applied voltages.
            assert( length( ts ) == length( V_apps ), 'The lengths of the time vector and applied voltage vectors must be equal.' )
            
            % Set the time vector.
            self.ts = ts;
            
            % Set the applied voltages.
            self.V_apps;
            
            % Set the number of time steps.
            self.num_timesteps = length( self.ts );    
            
        end
        
        
        %% Validation Functions
        
        % Implement a function to validate the applied voltage.
        function validate_applied_voltage( self )
           
            % Validate the applied voltage.
            assert( length( self.ts ) == length( self.V_apps ), 'The lengths of the time vector and applied voltage vectors must be equal.' )
            
        end
        
        
        %% Compute Functions
        
        % Implement a function to compute the number of time steps.
        function num_timesteps = compute_num_timesteps( self )
           
            % Compute the number of time steps.
            num_timesteps = length( self.ts );
            
        end
        
        
        % Implement a function to compute the time step.
        function dt = compute_dt( self )
            
            % Compute the step size.
            dt = self.array_utilities.compute_step_size( self.ts );
            
        end
        
        
        % Implement a function to compute the final time.
        function tf = compute_tf( self )
            
            % Compute the final time.
           tf = max( self.ts ); 
            
        end
        
        
                
        %% Compute-Set Functions
        
        % Implement a function to compute and set the number of time steps.
        function self = compute_set_num_timesteps( self )
           
            % Compute and set the number of time steps.
            self.num_timesteps = self.compute_num_timesteps(  );
            
        end
        
        
        % Implement a function to compute and set the step size.
        function self = compute_set_dt( self )
            
            % Compute the step size.
            self.dt = self.compute_dt(  );
            
        end
        
        
        % Implement a function to compute and set the final time.
        function self = compute_set_tf( self )
            
            % Compute and set the final time.
            self.tf = self.compute_tf(  );
            
        end
        
        
        %% Sampling Functions
        
        % Implement a function to sample an applied voltage.
        function [ V_apps_sample, ts_sample ] = sample_Vapp( self, dt, tf )
            
            % Set the default input arguments.
            if nargin < 3, tf = max( self.ts ); end
            if nargin < 2, dt = [  ]; end
            
            % Determine how to sample the applied voltage.
            if ~isempty( dt ) && ( self.num_timesteps > 0 )                          % If the sample spacing and existing applied voltage data is not empty...
                
                % Create the sampled time vector.
                ts_sample = ( 0:dt:tf )';
                
                % Determine how to sample the applied voltage.
                if self.num_timesteps == 1                                           % If the number of timesteps is one.. ( The applied voltage is constant. )
                    
                    % Create the applied voltage sample as a constant vector.
                    V_apps_sample = repmat( self.V_apps, [ self.num_timesteps, 1 ] );
                    
                else                                                                % Otherwise...
                    
                    % Create the applied voltage sample via interpolation.
                    V_apps_sample = self.array_utilities.interp1_cell( self.ts, self.V_apps, ts_sample );
                    
                end
                
            else                                                                    % Otherwise...
                
                % Set the sampled time vector to be the existing time vector (perhaps empty, perhaps a complete time vector).
                ts_sample = self.ts;
                
                % Set the sampled applied voltage vector to be the existing time vector (perhaps empty, perhaps a complete time vector).
                V_apps_sample = self.V_apps;
                
            end
            
        end
        
        
        %% Enable & Disable Functions
        
        % Implement a function to toogle whether this applied voltage is enabled.
        function self = toggle_enabled( self )
            
            % Toggle whether the applied voltage is enabled.
            self.b_enabled = ~self.b_enabled;
            
        end
        
        
        % Implement a function to enable this applied voltage.
        function self = enable( self )
            
            % Enable this applied voltage.
            self.b_enabled = true;
            
        end
        
        
        % Implement a function to disable this applied voltage.
        function self = disable( self )
            
            % Disable this applied voltage.
            self.b_enabled = false;
            
        end
        
        
        %% Save & Load Functions
        
        % Implement a function to save applied voltage data as a matlab object.
        function save( self, directory, file_name )
            
            % Set the default input arguments.
            if nargin < 3, file_name = 'Applied_Voltage.mat'; end
            if nargin < 2, directory = '.'; end
            
            % Create the full path to the file of interest.
            full_path = [ directory, '\', file_name ];
            
            % Save the neuron data.
            save( full_path, self )
            
        end
        
        
        % Implement a function to load applied voltage data as a matlab object.
        function self = load( ~, directory, file_name )
            
            % Set the default input arguments.
            if nargin < 3, file_name = 'Applied_Voltage.mat'; end
            if nargin < 2, directory = '.'; end
            
            % Create the full path to the file of interest.
            full_path = [ directory, '\', file_name ];
            
            % Load the data.
            data = load( full_path );
            
            % Retrieve the desired variable from the loaded data structure.
            self = data.self;
            
        end
        
        
    end
end

