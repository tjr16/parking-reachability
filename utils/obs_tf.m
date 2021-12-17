%% Modified
% get marker poses
PLOT_PARKING_SPOT = true;

%% plot example parking spot etc.
if PLOT_PARKING_SPOT
    hold on
%     [~,N] = size(map_obst.obstacles);
%     for i = 1:N
%         obst = map_obst.obstacles{i};
%         obsx = [obst{1:length(obst)}];
%         obsy = [obst{length(obst)+1:2*length(obst)}];
%         patch(obsx,obsy,'black');
%     end

    fn = fieldnames(parking_spots);
    for j = 1:length(fn)
        obstacles = parking_spots.(fn{j});

        [~,N] = size(obstacles.park_obs);
        for i = 1:N
            obs = obstacles.park_obs{i};
            obsx = [obs{1:length(obs)}];
            obsy = [obs{length(obs)+1:2*length(obs)}];
            patch(obsx,obsy,'g');
        end

    end   
    grid on
end

%% Get parking spots' data from yaml

fn = fieldnames(parking_spots);
ps = {};
type = {};
marker = {};
spot_dim = {};
for j = 1:length(fn)
    tf_ps = {};
    obstacles = parking_spots.(fn{j});

    [~,N] = size(obstacles.park_obs);
    type{j} = string(obstacles.type);
    marker{j} = obstacles.marker_pose;
    spot_dim{j} = obstacles.spot_dim;
    
    for i = 1:N
        transposed_ps = cell2mat([obstacles.park_obs{i}]');
        tf_ps{i} = transposed_ps;
    end
    ps{j} =tf_ps;
end

%% Get map obstacles
% mapObs = map_obst.obstacles;
% for i = 1:numel(mapObs)
%     mapObs{i} = cell2mat(mapObs{i})';
% end
