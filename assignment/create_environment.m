function ENV_DATA = create_environment(environment_size, colony_count)

    for i = 1:1:colony_count
        % Randomly place the colonies
        ENV_DATA.colonies(i) = Colony([],0,0,i);
    end

    ENV_DATA.shape='square';
    ENV_DATA.units='kilometres';
    ENV_DATA.bm_size=environment_size;

    for i = 1:1:environment_size
        for j = 1:1:environment_size
            ENV_DATA.environment(i,j) = TerrainTile(0);
        end
    end

    

end