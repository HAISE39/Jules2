"use client";

import React, { useState } from 'react';
import axios from 'axios';
import { Plus, Download, Loader2, Music } from 'lucide-react';
import { TrackList } from '@/components/TrackList';
import { mergeAudioFiles } from '@/lib/audio-utils';

interface Track {
  id: string;
  title: string;
  thumbnail: string;
  duration: number;
  author: string;
  url: string;
}

export default function Home() {
  const [url, setUrl] = useState('');
  const [tracks, setTracks] = useState<Track[]>([]);
  const [loading, setLoading] = useState(false);
  const [merging, setMerging] = useState(false);
  const [progress, setProgress] = useState(0);

  const addTrack = async () => {
    if (!url) return;
    setLoading(true);
    try {
      const response = await axios.get(`/api/info?url=${encodeURIComponent(url)}`);
      const newTrack: Track = {
        ...response.data,
        id: Math.random().toString(36).substr(2, 9),
      };
      setTracks([...tracks, newTrack]);
      setUrl('');
    } catch (error) {
      alert('Failed to fetch video info. Make sure the URL is valid.');
    } finally {
      setLoading(false);
    }
  };

  const removeTrack = (id: string) => {
    setTracks(tracks.filter(t => t.id !== id));
  };

  const handleMerge = async () => {
    if (tracks.length === 0) return;
    setMerging(true);
    setProgress(0);
    try {
      const urls = tracks.map(t => t.url);
      const blob = await mergeAudioFiles(urls, (p) => setProgress(p));

      const downloadUrl = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = downloadUrl;
      a.download = 'merged-album.mp3';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(downloadUrl);
    } catch (error) {
      console.error(error);
      alert('Error merging tracks. Please try again.');
    } finally {
      setMerging(false);
    }
  };

  return (
    <main className="min-h-screen bg-black text-white p-4 md:p-8">
      <div className="max-w-3xl mx-auto">
        <header className="mb-12 text-center">
          <div className="inline-flex items-center justify-center p-3 bg-blue-600 rounded-2xl mb-4">
            <Music size={32} />
          </div>
          <h1 className="text-4xl font-bold mb-2 bg-gradient-to-r from-blue-400 to-purple-500 bg-clip-text text-transparent">
            Album Meler
          </h1>
          <p className="text-gray-400">Combine your favorite YouTube tracks into a single MP3 album</p>
        </header>

        <div className="bg-gray-900 border border-gray-800 rounded-2xl p-6 mb-8 shadow-xl">
          <div className="flex gap-2">
            <input
              type="text"
              value={url}
              onChange={(e) => setUrl(e.target.value)}
              placeholder="Paste YouTube link here..."
              className="flex-1 bg-black border border-gray-700 rounded-xl px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all text-sm"
              onKeyPress={(e) => e.key === 'Enter' && addTrack()}
            />
            <button
              onClick={addTrack}
              disabled={loading || !url}
              className="bg-blue-600 hover:bg-blue-700 disabled:bg-gray-700 disabled:cursor-not-allowed text-white px-6 py-3 rounded-xl font-medium flex items-center gap-2 transition-all"
            >
              {loading ? <Loader2 className="animate-spin" size={20} /> : <Plus size={20} />}
              <span className="hidden sm:inline">Add Track</span>
            </button>
          </div>
        </div>

        <div className="space-y-6">
          <div className="flex items-center justify-between">
            <h2 className="text-xl font-semibold">Your Album ({tracks.length} tracks)</h2>
            {tracks.length > 0 && (
              <button
                onClick={handleMerge}
                disabled={merging}
                className="bg-green-600 hover:bg-green-700 disabled:bg-gray-700 text-white px-6 py-2 rounded-xl font-medium flex items-center gap-2 transition-all shadow-lg shadow-green-900/20"
              >
                {merging ? <Loader2 className="animate-spin" size={20} /> : <Download size={20} />}
                {merging ? `Merging ${Math.round(progress)}%` : 'Download MP3 Album'}
              </button>
            )}
          </div>

          <TrackList
            tracks={tracks}
            onRemove={removeTrack}
            onReorder={setTracks}
          />
        </div>
      </div>
    </main>
  );
}
