% MTL parser for Hyperion datasets
%
% Written in May 2013 By Nischal Mishra
% Image Processing Laboratory, South Dakota State University
%
% MAIN FUNCTIONALITY:
% Reads the information from MTL text file, which is provided with LANDSAT 8 data.
%
% USAGE:
% MTL=MTL_parser(filename) - for a single MTL file
% MTL_list=MTL_parser(filename_list) - for multiple MTL file
%                                      The list should be in a matrix form
%                                      which each of its row vector is a
%                                      string of a MTL filename
% MTL_list=MTL_parser() - Searches all MTL files in current directory and
%                         parses them all


function [MTL_list,value] = MTL_parser_hyperion(MTL_filename)



%% Begin the processing for all available MTL files
 cnt = 1;
    % File open and line string input
    fin = fopen(MTL_filename,'r');
    str_in = fgetl(fin);

    while ~strcmp(str_in,'END')
        % String parsing and refinement
        % input line refinement and processing
        
        [field value] = strtok(str_in,'=');
        
        %field name refinement
        %remove unnecessary space character from the field description
        if sum(field(1)==' ') %space character detector
                field = strtok(field,' ');
                
        end
        
        %Value refinement
        value=strtok(value,'=');
        
        %remove unnecessary space character from the field description
        while value(1,1)==' '
            value=value(1,2:size(value,2));
            
        end

        %disp(strcat(field,': ',value));
        
        if sum(value(1)=='"' && value(size(value,2))=='"') %If the value is a string wrapped by large quotation mark (")
            value = value(1,2:size(value,2)-1);
            
        elseif isempty(findstr(field,'TIME')) && isempty(findstr(field,'DATE'))
            value = str2num(value);
        
        end
        
        % Field detection and assignment routine
        switch field
            
            % GROUP=METADATA_FILE_INFO
            case 'ORIGIN'
                MTL.METADATA_FILE_INFO.ORIGIN = value;                
            case 'REQUEST_ID'
                MTL.METADATA_FILE_INFO.REQUEST_ID = value;
            case 'FILE_DATE'
                MTL.METADATA_FILE_INFO.PRODUCT_CREATION_TIME = value;
            case 'STATION_ID'
                MTL.METADATA_FILE_INFO.STATION_ID = value;
            case 'LANDSAT_SCENE_ID'
                MTL.METADATA_FILE_INFO.LANDSAT_SCENE_ID = value;
             

            % GROUP=PRODUCT_METADATA
            case 'PRODUCT_TYPE'        
                MTL.PRODUCT_METADATA.PRODUCT_TYPE = value;
            case 'ELEVATION_SOURCE'        
                MTL.PRODUCT_METADATA.ELEVATION_SOURCE = value;
            case 'PROCESSING_SOFTWARE'        
                MTL.PRODUCT_METADATA.PROCESSING_SOFTWARE_VERSION = value;
              case 'SPACECRAFT_ID'        
                MTL.PRODUCT_METADATA.SPACECRAFT_ID = value;
            case 'SENSOR_ID'        
                MTL.PRODUCT_METADATA.SENSOR_ID = value;
            case 'NADIR_OFFNADIR'        
                MTL.PRODUCT_METADATA.NADIR_OFFNADIR = value;
            case 'ACQUISITION_DATE'        
                MTL.PRODUCT_METADATA. ACQUISITION_DATE = value;
            case 'START_TIME'        
                MTL.PRODUCT_METADATA.START_TIME = value;
                 case 'END_TIME'        
                MTL.PRODUCT_METADATA.END_TIME = value;
                
            case 'WRS_PATH'        
                MTL.PRODUCT_METADATA.WRS_PATH = value;
            case 'WRS_ROW'        
                MTL.PRODUCT_METADATA.STARTING_ROW = value;
        
                % reading in the lat/lon values
            case 'PRODUCT_UL_CORNER_LAT'
                MTL.PRODUCT_METADATA.PRODUCT_UL_CORNER_LAT = value;
            case 'PRODUCT_UL_CORNER_LON'
                MTL.PRODUCT_METADATA.  PRODUCT_UL_CORNER_LON = value;
            case 'PRODUCT_UR_CORNER_LAT'
                MTL.PRODUCT_METADATA.    PRODUCT_UR_CORNER_LAT  = value;
            case 'PRODUCT_UR_CORNER_LON'
                MTL.PRODUCT_METADATA.PRODUCT_UR_CORNER_LON   = value;
            case 'PRODUCT_LL_CORNER_LAT'
                MTL.PRODUCT_METADATA.PRODUCT_LL_CORNER_LAT  = value;
            case 'PRODUCT_LL_CORNER_LON'
                MTL.PRODUCT_METADATA.PRODUCT_LL_CORNER_LON   = value;
            case 'PRODUCT_LR_CORNER_LAT'
                MTL.PRODUCT_METADATA.PRODUCT_LR_CORNER_LAT = value;
            case 'PRODUCT_LR_CORNER_LON'
                MTL.PRODUCT_METADATA.PRODUCT_LR_CORNER_LON = value;
                
                % reading in the map values
                
           case 'PRODUCT_UL_CORNER_MAPX'        
                MTL.PRODUCT_METADATA. PRODUCT_UL_CORNER_MAPX  = value;
            case 'PRODUCT_UL_CORNER_MAPY'        
                MTL.PRODUCT_METADATA.PRODUCT_UL_CORNER_MAPY = value;
            case 'PRODUCT_UR_CORNER_MAPX'        
                MTL.PRODUCT_METADATA.PRODUCT_UR_CORNER_MAPX = value;
            case 'PRODUCT_UR_CORNER_MAPY'        
                MTL.PRODUCT_METADATA. PRODUCT_UR_CORNER_MAPY = value;
            case 'PRODUCT_LL_CORNER_MAPX'        
                MTL.PRODUCT_METADATA.PRODUCT_LL_CORNER_MAPX  = value;
            case 'PRODUCT_LL_CORNER_MAPY'        
                MTL.PRODUCT_METADATA.PRODUCT_LL_CORNER_MAPY  = value;
            case 'PRODUCT_LR_CORNER_MAPX'        
                MTL.PRODUCT_METADATA.PRODUCT_LR_CORNER_MAPX = value;
            case 'PRODUCT_LR_CORNER_MAPY'                       
                MTL.PRODUCT_METADATA.PRODUCT_LR_CORNER_MAPY  = value;         
                
                % read in samples and lines
                
            case ' PANCHROMATIC_LINES'        
                MTL.PRODUCT_METADATA.PANCHROMATIC_LINES = value;     
            case 'PANCHROMATIC_LINES'        
                MTL.PRODUCT_METADATA.PANCHROMATIC_LINES = value;     
            case 'PRODUCT_LINES'        
                MTL.PRODUCT_METADATA.PRODUCT_LINES  = value;     
            case 'PRODUCT_SAMPLES'        
                MTL.PRODUCT_METADATA. PRODUCT_SAMPLES  = value;     
            case 'THERMAL_LINES'        
                MTL.PRODUCT_METADATA.THERMAL_LINES = value;     
            case '  THERMAL_SAMPLES'    
                MTL.PRODUCT_METADATA.  THERMAL_SAMPLES = value;   
                
                
              % read in the band names  
            case ' FILE_NAME_BAND_1'        
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_1 = value;     
            case ' FILE_NAME_BAND_2'        
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_2 = value;     
            case ' FILE_NAME_BAND_3'        
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_3 = value;     
            case ' FILE_NAME_BAND_4'        
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_4 = value;     
            case ' FILE_NAME_BAND_5'        
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_5 = value;     
            case ' FILE_NAME_BAND_6'        
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_6 = value;
            case ' FILE_NAME_BAND_7'        
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_7 = value;
            case ' FILE_NAME_BAND_8'
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_8 = value;
            case ' FILE_NAME_BAND_9'
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_9 = value;
                 case ' FILE_NAME_BAND_10'
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_10 = value;
            case ' FILE_NAME_BAND_11'
                MTL.PRODUCT_METADATA. FILE_NAME_BAND_11 = value;
                
                
               % Metadata files and CPF file name
                       
            case '  METADATA_FILE_NAME'
                MTL.PRODUCT_METADATA.  METADATA_FILE_NAME = value;
            case 'CPF_NAME'
                MTL.PRODUCT_METADATA.CPF_NAM = value;
            case '  BPF_NAME_OLI'
                MTL.PRODUCT_METADATA. BPF_NAME_OLI = value;
            case 'BPF_NAME_TIRS'
                MTL.PRODUCT_METADATA.BPF_NAME_TIRS = value;
                
                
                
   
            %GROUP = MIN_MAX_RADIANCE
            case 'RADIANCE_MAXIMUM_BAND_1'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_1 = value;
            case 'RADIANCE_MINIMUM_BAND_1'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_1 = value;
            case 'RADIANCE_MAXIMUM_BAND_2'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_2 = value;
            case 'RADIANCE_MINIMUM_BAND_2'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_2 = value;
            case 'RADIANCE_MAXIMUM_BAND_3'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_3 = value;
            case 'RADIANCE_MINIMUM_BAND_3'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_3 = value;
            case 'RADIANCE_MAXIMUM_BAND_4'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_4 = value;
            case 'RADIANCE_MINIMUM_BAND_4'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_4 = value;
            case 'RADIANCE_MAXIMUM_BAND_5'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_5 = value;
            case 'RADIANCE_MINIMUM_BAND_5'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_5 = value;
            case 'RADIANCE_MAXIMUM_BAND_6'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_6 = value;
            case 'RADIANCE_MINIMUM_BAND_6'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_6 = value;
            case 'RADIANCE_MAXIMUM_BAND_7'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_7 = value;
            case 'RADIANCE_MINIMUM_BAND_7'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_7 = value;
            case 'RADIANCE_MAXIMUM_BAND_8'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_8 = value;
            case 'RADIANCE_MINIMUM_BAND_8'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_8 = value;
                 case 'RADIANCE_MAXIMUM_BAND_9'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_9 = value;
            case 'RADIANCE_MINIMUM_BAND_9'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_9 = value;
                 case 'RADIANCE_MAXIMUM_BAND_10'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_10 = value;
            case 'RADIANCE_MINIMUM_BAND_10'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_10 = value;
                 case 'RADIANCE_MAXIMUM_BAND_11'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MAXIMUM_BAND_11 = value;
          case 'RADIANCE_MINIMUM_BAND_11'
                MTL.MIN_MAX_RADIANCE.RADIANCE_MINIMUM_BAND_11 = value;
                
              
                   %GROUP = MIN_MAX_REFLECTANCE
            case 'REFLECTANCE_MAXIMUM_BAND_1'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_1 = value;
            case 'REFLECTANCE_MINIMUM_BAND_1'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_1 = value;
            case 'REFLECTANCE_MAXIMUM_BAND_2'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_2 = value;
            case 'REFLECTANCE_MINIMUM_BAND_2'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_2 = value;
            case 'REFLECTANCE_MAXIMUM_BAND_3'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_3 = value;
            case 'REFLECTANCE_MINIMUM_BAND_3'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_3 = value;
            case 'REFLECTANCE_MAXIMUM_BAND_4'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_4 = value;
            case 'REFLECTANCE_MINIMUM_BAND_4'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_4 = value;
            case 'REFLECTANCE_MAXIMUM_BAND_5'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_5 = value;
            case 'REFLECTANCE_MINIMUM_BAND_5'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_5 = value;
            case 'REFLECTANCE_MAXIMUM_BAND_6'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_6 = value;
            case 'REFLECTANCE_MINIMUM_BAND_6'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_6 = value;
            case 'REFLECTANCE_MAXIMUM_BAND_7'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_7 = value;
            case 'REFLECTANCE_MINIMUM_BAND_7'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_7 = value;
            case 'REFLECTANCE_MAXIMUM_BAND_8'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_8 = value;
            case 'REFLECTANCE_MINIMUM_BAND_8'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_8 = value;
                 case 'REFLECTANCE_MAXIMUM_BAND_9'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_9 = value;
            case 'REFLECTANCE_MINIMUM_BAND_9'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_9 = value;
                 case 'REFLECTANCE_MAXIMUM_BAND_10'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_10 = value;
            case 'REFLECTANCE_MINIMUM_BAND_10'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_10 = value;
                 case 'REFLECTANCE_MAXIMUM_BAND_11'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MAXIMUM_BAND_11 = value;
          case 'REFLECTANCE_MINIMUM_BAND_11'
                MTL.MIN_MAX_REFLECTANCE.REFLECTANCE_MINIMUM_BAND_11 = value;
                
                
                
            %GROUP = MIN_MAX_PIXEL_VALUE        
            case 'QUANTIZE_CAL_MAX_BAND_1'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_1 = value;
            case 'QUANTIZE_CAL_MIN_BAND_1'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_1 = value;
                case 'QUANTIZE_CAL_MAX_BAND_2'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_2 = value;
            case 'QUANTIZE_CAL_MIN_BAND_2'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_2 = value;     
                case 'QUANTIZE_CAL_MAX_BAND_3'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_3 = value;
            case 'QUANTIZE_CAL_MIN_BAND_3'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_3 = value;
                
                 case 'QUANTIZE_CAL_MAX_BAND_4'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_4 = value;
            case 'QUANTIZE_CAL_MIN_BAND_4'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_4 = value;
                case 'QUANTIZE_CAL_MAX_BAND_5'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_5 = value;
            case 'QUANTIZE_CAL_MIN_BAND_5'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_5 = value;     
                case 'QUANTIZE_CAL_MAX_BAND_6'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_6 = value;
            case 'QUANTIZE_CAL_MIN_BAND_6'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_6 = value;
                  case 'QUANTIZE_CAL_MAX_BAND_7'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_7 = value;
            case 'QUANTIZE_CAL_MIN_BAND_7'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_7 = value;
                case 'QUANTIZE_CAL_MAX_BAND_8'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_8 = value;
            case 'QUANTIZE_CAL_MIN_BAND_8'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_8 = value;     
                case 'QUANTIZE_CAL_MAX_BAND_9'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_9 = value;
            case 'QUANTIZE_CAL_MIN_BAND_9'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_9 = value;                
                  case 'QUANTIZE_CAL_MAX_BAND_10'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_10 = value;
            case 'QUANTIZE_CAL_MIN_BAND_10'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_10 = value;     
                case 'QUANTIZE_CAL_MAX_BAND_11'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MAX_BAND_11 = value;
            case 'QUANTIZE_CAL_MIN_BAND_11'
                MTL.MIN_MAX_PIXEL_VALUE.QUANTIZE_CAL_MIN_BAND_11 = value;
               
                
        
            %GROUP = RADIOMETRIC_RESCALING
            % Radiance multiplicative factor
            case 'RADIANCE_MULT_BAND_1'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_1 = value;
            case 'RADIANCE_MULT_BAND_2'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_2 = value;
            case 'RADIANCE_MULT_BAND_3'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_3 = value;
            case 'RADIANCE_MULT_BAND_4'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_4 = value;
            case 'RADIANCE_MULT_BAND_5'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_5 = value;
            case 'RADIANCE_MULT_BAND_6'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_6 = value;
            case 'RADIANCE_MULT_BAND_7'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_7 = value;
            case 'RADIANCE_MULT_BAND_8'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_8 = value;
                case 'RADIANCE_MULT_BAND_9'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_9 = value;
            case 'RADIANCE_MULT_BAND_10'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_10 = value;
            case 'RADIANCE_MULT_BAND_11'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_MULT_BAND_11 = value;                
                
                
                %Radiance additive factor
              case 'RADIANCE_ADD_BAND_1'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_1 = value;
            case 'RADIANCE_ADD_BAND_2'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_2 = value;
            case 'RADIANCE_ADD_BAND_3'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_3 = value;
            case 'RADIANCE_ADD_BAND_4'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_4 = value;
            case 'RADIANCE_ADD_BAND_5'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_5 = value;
            case 'RADIANCE_ADD_BAND_6'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_6 = value;
            case 'RADIANCE_ADD_BAND_7'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_7 = value;
            case 'RADIANCE_ADD_BAND_8'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_8 = value;
                case 'RADIANCE_ADD_BAND_9'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_9 = value;
            case 'RADIANCE_ADD_BAND_10'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_10 = value;
            case 'RADIANCE_ADD_BAND_11'
                MTL.RADIOMETRIC_RESCALING.RADIANCE_ADD_BAND_11 = value;    
                
                % Reflectance multiplicative factor 
             case 'REFLECTANCE_MULT_BAND_1'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_1 = value;
            case 'REFLECTANCE_MULT_BAND_2'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_2 = value;
            case 'REFLECTANCE_MULT_BAND_3'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_3 = value;
            case 'REFLECTANCE_MULT_BAND_4'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_4 = value;
            case 'REFLECTANCE_MULT_BAND_5'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_5 = value;
            case 'REFLECTANCE_MULT_BAND_6'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_6 = value;
            case 'REFLECTANCE_MULT_BAND_7'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_7 = value;
            case 'REFLECTANCE_MULT_BAND_8'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_8 = value;
               case 'REFLECTANCE_MULT_BAND_9'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_9 = value;
            case 'REFLECTANCE_MULT_BAND_10'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_10 = value;
            case 'REFLECTANCE_MULT_BAND_11'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_MULT_BAND_11 = value;                
               
                
                 % Reflectance additive factor 
              case 'REFLECTANCE_ADD_BAND_1'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_1 = value;
            case 'REFLECTANCE_ADD_BAND_2'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_2 = value;
            case 'REFLECTANCE_ADD_BAND_3'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_3 = value;
            case 'REFLECTANCE_ADD_BAND_4'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_4 = value;
            case 'REFLECTANCE_ADD_BAND_5'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_5 = value;
            case 'REFLECTANCE_ADD_BAND_6'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_6 = value;
            case 'REFLECTANCE_ADD_BAND_7'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_7 = value;
            case 'REFLECTANCE_ADD_BAND_8'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_8 = value;
                case 'REFLECTANCE_ADD_BAND_9'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_9 = value;
            case 'REFLECTANCE_ADD_BAND_10'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_10 = value;
            case 'REFLECTANCE_ADD_BAND_11'
                MTL.RADIOMETRIC_RESCALING.REFLECTANCE_ADD_BAND_11 = value;       
                
             %GROUP_PRODUCT_PARAMETERS
            case 'SUN_AZIMUTH'
                MTL.PRODUCT_PARAMETERS.SUN_AZIMUTH = value;
            case 'SUN_ELEVATION'
                MTL.PRODUCT_PARAMETERS.SUN_ELEVATION = value;
            case 'SENSOR_LOOK_ANGLE'
                MTL.PRODUCT_PARAMETERS.SENSOR_LOOK_ANGLE = value;
        end
        
        str_in = fgetl(fin);
    end
    
    MTL_list(cnt,1) = MTL;
    fclose(fin);
    
