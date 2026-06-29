"use client";

import React from 'react';
import { Trash2, GripVertical, Clock, AlertCircle } from 'lucide-react';

interface Track {
  id: string;
  title: string;
  thumbnail: string;
  duration: number;
  author: string;
  url: string;
  error?: string;
}

interface TrackItemProps {
  track: Track;
  index: number;
  onRemove: (id: string) => void;
}

export const TrackItem: React.FC<TrackItemProps> = ({ track, onRemove }) => {
  const formatDuration = (seconds: number) => {
    if (seconds === 0) return 'Unknown';
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className={`flex items-center gap-4 bg-gray-900/50 p-3 rounded-lg border transition-colors group ${
      track.error ? 'border-red-500/50 hover:border-red-500' : 'border-gray-800 hover:border-blue-500/50'
    }`}>
      <div className="text-gray-500 cursor-grab active:cursor-grabbing">
        <GripVertical size={20} />
      </div>

      <img
        src={track.thumbnail}
        alt={track.title}
        className="w-16 h-12 object-cover rounded bg-gray-800"
      />

      <div className="flex-1 min-w-0">
        <h3 className={`text-sm font-medium truncate ${track.error ? 'text-red-400' : 'text-white'}`}>
          {track.title}
        </h3>
        <div className="flex items-center gap-3 text-xs text-gray-400 mt-1">
          {track.error ? (
            <span className="flex items-center gap-1 text-red-500">
              <AlertCircle size={12} />
              {track.error}
            </span>
          ) : (
            <>
              <span className="truncate">{track.author}</span>
              <span className="flex items-center gap-1">
                <Clock size={12} />
                {formatDuration(track.duration)}
              </span>
            </>
          )}
        </div>
      </div>

      <button
        onClick={() => onRemove(track.id)}
        className="p-2 text-gray-400 hover:text-red-500 hover:bg-red-500/10 rounded-full transition-all"
        title="Remove track"
      >
        <Trash2 size={18} />
      </button>
    </div>
  );
};
