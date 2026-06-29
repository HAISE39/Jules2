"use client";

import React from 'react';
import { TrackItem } from './TrackItem';
import { Reorder } from 'framer-motion';

interface Track {
  id: string;
  title: string;
  thumbnail: string;
  duration: number;
  author: string;
  url: string;
}

interface TrackListProps {
  tracks: Track[];
  onRemove: (id: string) => void;
  onReorder: (newTracks: Track[]) => void;
}

export const TrackList: React.FC<TrackListProps> = ({ tracks, onRemove, onReorder }) => {
  if (tracks.length === 0) {
    return (
      <div className="text-center py-12 border-2 border-dashed border-gray-800 rounded-xl">
        <p className="text-gray-500">No tracks added yet. Add a YouTube link to start.</p>
      </div>
    );
  }

  return (
    <Reorder.Group
      axis="y"
      values={tracks}
      onReorder={onReorder}
      className="space-y-3"
    >
      {tracks.map((track, index) => (
        <Reorder.Item
          key={track.id}
          value={track}
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.95 }}
        >
          <TrackItem
            track={track}
            index={index}
            onRemove={onRemove}
          />
        </Reorder.Item>
      ))}
    </Reorder.Group>
  );
};
