    
map_obst = ReadYaml(mapPath);
hold on
[~,N1] = size(map_obst.obstacles);
for i = 1:N1
    obst = map_obst.obstacles{i};
    obsx = [obst{1:length(obst)}];
    obsy = [obst{length(obst)+1:2*length(obst)}];
    patch(obsx,obsy,'black', 'faceAlpha', 0.3);
end

