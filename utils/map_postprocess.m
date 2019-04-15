function    final_map   = map_postprocess(map, r, c, type)

    if strcmpi(type, 'sigmoid')
        final_map   = map;
        final_map   = 1./(1 + exp(-final_map));
        final_map   = permute(final_map, [2,1,3]);
        final_map   = imresize(final_map,[r,c]);
    elseif strcmpi(type, 'noneed')
        final_map   = map;
        final_map   = permute(final_map, [2,1,3]);
        final_map   = imresize(final_map,[r,c]);
    end