function [possible_task, possible_task_idx] = ...
    feasibilityTest(parking_task, LENGTH, WIDTH)
    % Feasibility check:
    % Checks if the car can fit into the parking spot.
    % Input:
    %   parking_task: struct, from yaml file
    % Return:
    %   possible_task: 1 X n cell: names of feasible tasks
    %   possible_task_idx: indices of feasible tasks, following the
    %       order in the yaml file
    % last modified: Dec5, from Anna's script

    N = length(fieldnames(parking_task)); %Number of parking tasks
    park_tasks = fieldnames(parking_task);
    possible_task = {};
    possible_task_idx = [];
    for i = 1:N
        park_task = parking_task.(park_tasks{i});
        [WIDTH_SPOT, LENGTH_SPOT]= CheckDimensions(park_task.type,park_task.spot_dim);
        if LENGTH_SPOT > LENGTH && WIDTH_SPOT> WIDTH
            disp(append('Car fits inside parking spot ', park_tasks{i}));
%             possible_task = [possible_task, park_tasks{i}];
            possible_task{i} = park_tasks{i};
            possible_task_idx = [possible_task_idx, i];
            % Here, run the reachability analysis for that spot?
        else
             disp(append('Car does not fit into parking spot ', park_tasks{i}));     
        end
    end

end

% return the indices 


