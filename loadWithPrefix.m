function loadWithPrefix(matFileName, prefix)
    load(matFileName)
    allVariables = who;
    for i = 1:length(allVariables)
        if (strcmp(allVariables{i}, 'prefix') || strcmp(allVariables{i}, 'matFileName'))
            %
        else
            disp([allVariables{i} ' -> ' prefix allVariables{i}]);
            %evalin('base', ['global ' prefix allVariables{i}]);
            eval(['assignin(''base'', [prefix allVariables{i}] ,' allVariables{i} ');']);
            %eval(['clear ' allVariables{i}]);
        end
    end