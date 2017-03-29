%%function [dates, x, t] = getNumericData()
    [dataTable, ~, ~, ~] = getDataTable();
    %dataTable = test1Table;
    
    dates = dataTable{:,{'Date'}}';
    
    d1 = weekday(dates);
    d1(d1<2) = 7;
    d1(d1<7) = 0;
    d1(d1>2) = 1;
    
    d2 = dates.Hour*3600 + dates.Minute*60 + dates.Second;

    x = dataTable{:,{'Temperature','Humidity','Light','CO2','HumidityRatio'}}';
    x = [x; d1; d2];
    
    t = dataTable{:, {'Occupancy'}}';
    
    clear d1;
    clear d2;
    
    
    
    
    
    
%%end