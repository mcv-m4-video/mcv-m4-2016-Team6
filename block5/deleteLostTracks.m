function tracks = deleteLostTracks(tracks)
    if isempty(tracks)
        return;
    end

    invisibleForTooLong = 4; %20
    ageThreshold = 8;

    % Compute the fraction of the track's age for which it was visible.
    ages = [tracks(:).age];
    totalVisibleCounts = [tracks(:).totalVisibleCount];
    visibility = totalVisibleCounts ./ ages;

    % Find the indices of 'lost' tracks.
    lostInds = (ages < ageThreshold & visibility < 0.6) | ...
        [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;
    
    % Compute mean speed of tracks to be deleted
    if sum(lostInds) > 0
        computeAndStoreSpeed(tracks(lostInds));
    end
    
    % Delete lost tracks.
    tracks = tracks(~lostInds);
end

