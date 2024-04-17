classdef conversion_manager_class

    % This class constains properties and methods related to converting data types.
    
    %% CONVERSION MANAGER PROPERTIES
    
    % Define the class properties.
    properties ( Constant = true )
        
        MAX_UINT16_VALUE = 65535;
        LB_PER_N = 0.2248;
        N_PER_LB = 4.4482;
        PSI_PER_PA = 0.000145038;
        PA_PER_PSI = 6894.76;
        IN_PER_M = 39.3701;
        M_PER_IN = 0.0254;
        RAD_PER_DEG = pi/180;
        DEG_PER_RAD = 180/pi;
        FTLB_PER_NM = 0.7375621493;
        NM_PER_FTLB = 1.3558179483;
        
    end
    
    
    %% CONVERSION MANAGER SETUP FUNCTIONS
    
    % Define the class methods.
    methods
        
        % Implement the class constructor.
        function self = conversion_manager_class(  )

            
        end
        
        
        %% DATA TYPE CONVERSION FUNCTIONS
        
        % Implement a function to convert a double to a uint16.
        function uint16_value = double2uint16( self, double_value, double_domain )
            
            % Compute the uint16 value.
            uint16_value = uint16( interp1( double_domain, [0 self.MAX_UINT16_VALUE], double_value ) );
            
        end
        
        % Implement a function to convert a uint16 to double.
        function double_value = uint162double( self, uint16_value, double_domain )
            
            % Compute the double value.
            double_value = interp1( [0 self.MAX_UINT16_VALUE], double_domain, double( uint16_value ) );
            
        end
        
        
        %% FORCE CONVERSION FUNCTIONS
        
        % Implement a function to convert a force in newtons to a force in pounds.
        function force_pounds = n2lb( self, force_newtons )
            
            % Convert the given force from newtons to pounds.
            force_pounds = self.LB_PER_N*force_newtons;
            
        end
        
        
        % Implement a function to convert a force in pounds to a force in newtons.
        function force_newtons = lb2n( self, force_pounds )
            
           % Convert the given force from pounds to newtons.
            force_newtons = self.N_PER_LB*force_pounds;
            
        end
        
        
        %% PRESSURE CONVERSION FUNCTIONS
        
        % Implement a function to convert a pressure in pascals to a pressure in psi.
        function pressure_psi = pa2psi( self, pressure_pa )
            
           % Convert the given pressure from pa to psi.
           pressure_psi = self.PSI_PER_PA*pressure_pa;
            
        end
        
        % Implement a function to convert a pressure in psi to a pressure in pascals.
        function pressure_pa = psi2pa( self, pressure_psi )
            
           % Convert the given pressure from psi to pa.
           pressure_pa = self.PA_PER_PSI*pressure_psi;
            
        end
        
        
        %% LENGTH CONVERSION FUNCTIONS
        
        % Implement a function to convert a length in meters to a length in inches.
        function length_in = m2in( self, length_m )
            
            % Convert the given length from m to in.
            length_in = self.IN_PER_M*length_m;
            
        end
        
        
        % Implement a function to convert a length in inches to a length in meters.
        function length_m = in2m( self, length_in )
           
            % Convert the given length from in to m.
            length_m = self.M_PER_IN*length_in;
            
        end
        
        %% ANGLE CONVERSION FUNCTIONS
        
        % Implement a function to convert an angle in radians to an angle in degrees.
        function angle_deg = rad2deg( self, angle_rad )
        
            % Convert the given angle from rad to deg.
            angle_deg = self.DEG_PER_RAD*angle_rad;
            
        end
        
        
        % Implement a function to convert an angle in radians to an angle in degrees.
        function angle_rad = deg2rad( self, angle_deg )
        
            % Convert the given angle from deg to rad.
            angle_rad = self.RAD_PER_DEG*angle_deg;
            
        end
        
        
        %% TORQUE CONVERSION FUNCTIONS
        
        % Implement a function to convert a torque in newton-meters to a torque in foot-pounds.
        function torque_ftlb = nm2ftlb( self, torque_nm )
        
            % Convert the given angle from newton-meters to foot-pounds.
            torque_ftlb = self.FTLB_PER_NM*torque_nm;
            
        end
        
        
        % Implement a function to convert a torque in foot-pounds to a torque in newton-meters.
        function torque_nm = ftlb2nm( self, torque_ftlb )
        
            % Convert the given angle from foot-pounds to newton-meters.
            torque_nm = self.NM_PER_FTLB*torque_ftlb;
            
        end
        
            
    end
end

