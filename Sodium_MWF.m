function Sodium_MWF(app)

app.Lamp.Color = [0 1 0];
drawnow;

%---------------------------------------------------------
% Healthy white matter weight (gram / gram WM)
%---------------------------------------------------------
WCNM = app.RelativeWaterContentInNonMyelinByWeight.Value;                   % = 0.82 (gram H20 / gram non-myelin) - from Laule 2004, Table 2 
WCM = app.RelativeWaterContentInMyelinByWeight.Value;                       % = 0.369 (gram H20 / gram myelin) - from Laule 2004, Table 2 
MWF = app.MWF.Value;

NonMyelinTissueWeight = WCM*(1-MWF) / (WCM*(1-MWF) + WCNM*MWF);
MyelinTissueWeight = 1 - NonMyelinTissueWeight;
NonMyelinWaterWeight = NonMyelinTissueWeight * WCNM;                        % = 0.638 (gram / gram WM) for MWF = 0.114 (also listed in Laule 2004, Figure 6a) 
MyelinWaterWeight = MyelinTissueWeight * WCM;                               % = 0.082 (gram / gram WM) for MWF = 0.114 (also listed in Laule 2004, Figure 6a) 
NonMyelinDryWeight = NonMyelinTissueWeight * (1 - WCNM);                    % = 0.14 (gram / gram WM) for MWF = 0.114 (also listed in Laule 2004, Figure 6a) 
MyelinDryWeight = MyelinTissueWeight * (1 - WCM);                           % = 0.14 (gram / gram WM) for MWF = 0.114 (also listed in Laule 2004, Figure 6a) 
TotalWaterWeight = NonMyelinWaterWeight + MyelinWaterWeight;                % = 0.72 (gram / gram WM) for MWF = 0.114 (also listed in Laule 2004, Figure 6a)         

%---------------------------------------------------------
% Healthy white matter volume (mL / gram WM)
%---------------------------------------------------------
DDNM = app.DensityofDryNonMyelin.Value;                                     % = 1.33 (g/mL) - from Laule 2004, Table 2 
DDM = app.DensityofDryMyelin.Value;                                         % = 1.08 (g/mL) - from Laule 2004, Table 2 
ECVF = app.ExtracellularVolumeFraction.Value;                               % = 0.2 - from Sykova 2008 

MyelinWaterVolume = MyelinWaterWeight;                                      
MyelinDryVolume = MyelinDryWeight / DDM;                                    
TotalMyelinVolume = MyelinWaterVolume + MyelinDryVolume;            
NonMyelinWaterVolume = NonMyelinWaterWeight;                                
NonMyelinDryVolume = NonMyelinDryWeight / DDNM;                             
TotalNonMyelinVolume = NonMyelinWaterVolume + NonMyelinDryVolume;   
TotalVolume = NonMyelinWaterVolume + MyelinWaterVolume + ...                % = 0.955 (mL / gram WM) for MWF = 0.114 (also listed in Laule 2004, Figure 6a)
                      NonMyelinDryVolume + MyelinDryVolume;  
TotalWaterVolume = MyelinWaterVolume + NonMyelinWaterVolume;
                  
WaterVolumeFracNonMyelin = NonMyelinWaterVolume / (NonMyelinWaterVolume + NonMyelinDryVolume);  % = 0.86 for MWF = 0.114 (listed in section paper supplemental 4.4.1)
                  
TotalExtracellularVolume = ECVF * TotalVolume;
ExtracellularWaterVolume = TotalExtracellularVolume * WaterVolumeFracNonMyelin;                  
ExtracellularDryVolume = TotalExtracellularVolume * (1 - WaterVolumeFracNonMyelin);   
TotalIntracellularVolume = TotalNonMyelinVolume - TotalExtracellularVolume;
IntracellularWaterVolume = TotalIntracellularVolume * WaterVolumeFracNonMyelin;                  
IntracellularDryVolume = TotalIntracellularVolume * (1 - WaterVolumeFracNonMyelin);   

%---------------------------------------------------------
% Healthy white matter volume percentages
%---------------------------------------------------------
app.PercentMyelinTotalVolume.Value = 100*TotalMyelinVolume / TotalVolume;
app.PercentNonMyelinWaterByVolume.Value = 100*NonMyelinWaterVolume / TotalVolume;
app.PercentMyelinWaterByVolume.Value = 100*MyelinWaterVolume / TotalVolume;
app.PercentNonMyelinTotalVolume.Value = 100*TotalNonMyelinVolume / TotalVolume; 
app.PercentNonMyelinDryByVolume.Value = 100*NonMyelinDryVolume / TotalVolume; 
app.PercentMyelinDryByVolume.Value = 100*MyelinDryVolume / TotalVolume;
app.PercentIntracellularWaterByVolume.Value = 100*IntracellularWaterVolume / TotalVolume;
app.PercentExtracellularWaterByVolume.Value = 100*ExtracellularWaterVolume / TotalVolume;
app.PercentIntracellularDryByVolume.Value = 100*IntracellularDryVolume / TotalVolume;
app.PercentExtracellularDryByVolume.Value = 100*ExtracellularDryVolume / TotalVolume;
app.PercentIntracellularTotalByVolume.Value = 100*TotalIntracellularVolume / TotalVolume;
app.PercentExtracellularTotalByVolume.Value = 100*TotalExtracellularVolume / TotalVolume;
app.PercentTotalWaterByVolume.Value = 100*TotalWaterVolume / TotalVolume;

%---------------------------------------------------------
% Healthy sodium concentrations
%---------------------------------------------------------
app.MyelinSodiumByVolume.Value = app.MyelinSodiumConcentration.Value * app.PercentMyelinWaterByVolume.Value/100;
app.IntracellularSodiumByVolume.Value = app.IntracellularSodiumConcentration.Value * app.PercentIntracellularWaterByVolume.Value/100;
app.ExtracellularSodiumByVolume.Value = app.ExtracellularSodiumConcentration.Value * app.PercentExtracellularWaterByVolume.Value/100;
app.TotalSodiumByVolume.Value = app.MyelinSodiumByVolume.Value + app.IntracellularSodiumByVolume.Value + app.ExtracellularSodiumByVolume.Value;

%---------------------------------------------------------
% Healthy relative sodium MRI value
%---------------------------------------------------------
app.MyelinRelativeSignal.Value = app.MyelinRelativeWeighting.Value * app.MyelinSodiumByVolume.Value;
app.IntracellularRelativeSignal.Value = app.IntracellularRelativeWeighting.Value * app.IntracellularSodiumByVolume.Value;
app.ExtracellularRelativeSignal.Value = app.ExtracellularRelativeWeighting.Value * app.ExtracellularSodiumByVolume.Value;
app.TotalRelativeSignal.Value = app.MyelinRelativeSignal.Value + app.IntracellularRelativeSignal.Value + app.ExtracellularRelativeSignal.Value; 

%=================================================================================
% Disorder
%=================================================================================

%---------------------------------------------------------
% Use the same sodium MRI sequence weighting for disorder
%---------------------------------------------------------
app.MyelinRelativeWeighting_2.Value = app.MyelinRelativeWeighting.Value;
app.IntracellularRelativeWeighting_2.Value = app.IntracellularRelativeWeighting.Value;
app.ExtracellularRelativeWeighting_2.Value = app.ExtracellularRelativeWeighting.Value;


if strcmp(app.OptionsDropDown.Value,'Demyelinate - Replace By Edema')
   
    %---------------------------------------------------------
    % Iterate until MWF & water increase entered both acheived
    %   (unless this is not possible)
    %--------------------------------------------------------- 
    ReplaceRate = 0;                                % Intial rate at which volume lost is replaced by edema. 
    MwfWithEdemaExcluded = app.MWF_2.Value;         % MWF with the extra water from edema not taken into account (this is added in later).             
    while true
    
        NonMyelinWaterWeight_2 = NonMyelinWaterWeight;
        MyelinWaterWeight_2 = NonMyelinWaterWeight_2 * MwfWithEdemaExcluded / (1 - MwfWithEdemaExcluded);             
        MyelinDryWeight_2 = MyelinWaterWeight_2 / app.RelativeWaterContentInMyelinByWeight.Value - MyelinWaterWeight_2;

        MyelinWaterVolume_2 = MyelinWaterWeight_2;
        MyelinDryVolume_2 = MyelinDryWeight_2 / app.DensityofDryMyelin.Value;
        TotalMyelinVolume_2 = MyelinWaterVolume_2 + MyelinDryVolume_2;

        VolumeLost = TotalMyelinVolume - TotalMyelinVolume_2;

        WaterVolumeFracEdema = app.RelativeWaterContentInEdemaByVolume_2.Value;
        EdemaWaterVolume_2 = VolumeLost * ReplaceRate * WaterVolumeFracEdema;
        EdemaDryVolume_2 = VolumeLost * ReplaceRate * (1-WaterVolumeFracEdema);
        EdemaTotalVolume_2 = EdemaWaterVolume_2 + EdemaDryVolume_2;    

        ExtracellularWaterVolume_2 = ExtracellularWaterVolume;
        ExtracellularDryVolume_2 = ExtracellularDryVolume;
        TotalExtracellularVolume_2 = ExtracellularWaterVolume_2 + ExtracellularDryVolume_2;
        IntracellularWaterVolume_2 = IntracellularWaterVolume;
        IntracellularDryVolume_2 = IntracellularDryVolume;
        TotalIntracellularVolume_2 = TotalIntracellularVolume;
        NonMyelinWaterVolume_2 = IntracellularWaterVolume_2 + ExtracellularWaterVolume_2;
        NonMyelinDryVolume_2 = IntracellularDryVolume_2 + ExtracellularDryVolume_2;
        TotalNonMyelinVolume_2 = NonMyelinWaterVolume_2 + NonMyelinDryVolume_2;
        TotalWaterVolume_2 = MyelinWaterVolume_2 + NonMyelinWaterVolume_2 + EdemaWaterVolume_2;

        TotalVolume_2 = NonMyelinWaterVolume_2 + MyelinWaterVolume_2 + EdemaWaterVolume_2 + ... 
                                NonMyelinDryVolume_2 + MyelinDryVolume_2 + EdemaDryVolume_2;
        app.PercentMyelinTotalVolume_2.Value = 100*TotalMyelinVolume_2 / TotalVolume_2;
        app.PercentNonMyelinWaterByVolume_2.Value = 100*NonMyelinWaterVolume_2 / TotalVolume_2;
        app.PercentMyelinWaterByVolume_2.Value = 100*MyelinWaterVolume_2 / TotalVolume_2;
        app.PercentNonMyelinTotalVolume_2.Value = 100*TotalNonMyelinVolume_2 / TotalVolume_2; 
        app.PercentNonMyelinDryByVolume_2.Value = 100*NonMyelinDryVolume_2 / TotalVolume_2; 
        app.PercentMyelinDryByVolume_2.Value = 100*MyelinDryVolume_2 / TotalVolume_2;
        app.PercentIntracellularWaterByVolume_2.Value = 100*IntracellularWaterVolume_2 / TotalVolume_2;
        app.PercentExtracellularWaterByVolume_2.Value = 100*ExtracellularWaterVolume_2 / TotalVolume_2;
        app.PercentEdemaWaterByVolume_2.Value = 100*EdemaWaterVolume_2 / TotalVolume_2;
        app.PercentIntracellularDryByVolume_2.Value = 100*IntracellularDryVolume_2 / TotalVolume_2;
        app.PercentExtracellularDryByVolume_2.Value = 100*ExtracellularDryVolume_2 / TotalVolume_2;
        app.PercentEdemaDryByVolume_2.Value = 100*EdemaDryVolume_2 / TotalVolume_2;
        app.PercentIntracellularTotalByVolume_2.Value = 100*TotalIntracellularVolume_2 / TotalVolume_2;
        app.PercentExtracellularTotalByVolume_2.Value = 100*TotalExtracellularVolume_2 / TotalVolume_2;
        app.PercentEdemaTotalByVolume_2.Value = 100*EdemaTotalVolume_2 / TotalVolume_2;
        app.PercentTotalWaterByVolume_2.Value = 100*TotalWaterVolume_2 / TotalVolume_2;

        WaterIncrease = app.PercentTotalWaterByVolume_2.Value/app.PercentTotalWaterByVolume.Value;
        MWFActual = app.PercentMyelinWaterByVolume_2.Value /app.PercentTotalWaterByVolume_2.Value;

        if round(10000*MWFActual) == 10000*app.MWF_2.Value && round(100000*(WaterIncrease-1)) == 1000*app.PercentWaterIncrease.Value
            break
        end
        
        if WaterIncrease < (1 + app.PercentWaterIncrease.Value/100)
            ReplaceRate = ReplaceRate + 0.001;
        else
            if MWFActual < app.MWF_2.Value
                MwfWithEdemaExcluded = MwfWithEdemaExcluded * 1.0001;
            else
                break
            end
        end        
    end

    %---------------------------------------------------------
    % Update MWF and Water increase if they could not be simultaneously attained
    %---------------------------------------------------------
    app.MWF_2.Value = round(10000*MWFActual)/10000;
    app.PercentWaterIncrease.Value = round(100000*(WaterIncrease-1))/1000;

    app.MyelinSodiumByVolume_2.Value = app.MyelinSodiumConcentration_2.Value * app.PercentMyelinWaterByVolume_2.Value/100;
    app.IntracellularSodiumByVolume_2.Value = app.IntracellularSodiumConcentration_2.Value * app.PercentIntracellularWaterByVolume_2.Value/100;
    app.ExtracellularSodiumByVolume_2.Value = app.ExtracellularSodiumConcentration_2.Value * app.PercentExtracellularWaterByVolume_2.Value/100;
    app.EdemaSodiumByVolume_2.Value = app.ExtracellularSodiumConcentration_2.Value * app.PercentEdemaWaterByVolume_2.Value/100;
    app.TotalSodiumByVolume_2.Value = app.MyelinSodiumByVolume_2.Value + app.IntracellularSodiumByVolume_2.Value + app.ExtracellularSodiumByVolume_2.Value + app.EdemaSodiumByVolume_2.Value;  
    
    app.MyelinRelativeSignal_2.Value = app.MyelinRelativeWeighting_2.Value * app.MyelinSodiumByVolume_2.Value;
    app.IntracellularRelativeSignal_2.Value = app.IntracellularRelativeWeighting_2.Value * app.IntracellularSodiumByVolume_2.Value;
    app.ExtracellularRelativeSignal_2.Value = app.ExtracellularRelativeWeighting_2.Value * app.ExtracellularSodiumByVolume_2.Value;
    app.EdemaRelativeSignal_2.Value = app.EdemaRelativeWeighting_2.Value * app.EdemaSodiumByVolume_2.Value;
    app.TotalRelativeSignal_2.Value = app.MyelinRelativeSignal_2.Value + app.IntracellularRelativeSignal_2.Value + app.ExtracellularRelativeSignal_2.Value + app.EdemaRelativeSignal_2.Value; 
    
    app.RelativeSignalChangeOverHealthy.Value = 100*((app.TotalRelativeSignal_2.Value / app.TotalRelativeSignal.Value) - 1);
    
    app.TissueAtrophy.Value = 100*(1 - TotalVolume_2/TotalVolume);
end    

app.Lamp.Color = [1 1 1];


