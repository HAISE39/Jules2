import { NextRequest, NextResponse } from 'next/server';
import ytdl from '@distube/ytdl-core';
import axios from 'axios';

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const url = searchParams.get('url');

  if (!url) {
    return NextResponse.json({ error: 'URL is required' }, { status: 400 });
  }

  // Use a more robust ID extraction like in the user's script
  const extractVideoId = (url: string) => {
    const patterns = [
      /(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/|youtube\.com\/v\/|youtube\.com\/shorts\/)([^&\n?#]+)/,
      /youtube\.com\/watch\?.*v=([^&\n?#]+)/
    ];
    for (let pattern of patterns) {
      const match = url.match(pattern);
      if (match) return match[1];
    }
    return null;
  };

  const videoId = extractVideoId(url);
  if (!videoId) {
    return NextResponse.json({ error: 'Invalid YouTube URL' }, { status: 400 });
  }

  // Attempt 1: YouTube oEmbed (Very reliable for metadata, doesn't get blocked like scraping)
  try {
    const oembedUrl = `https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=${videoId}&format=json`;
    const response = await axios.get(oembedUrl);
    const data = response.data;

    return NextResponse.json({
      title: data.title || 'YouTube Track',
      duration: 0, // oEmbed doesn't provide duration
      thumbnail: data.thumbnail_url || `https://img.youtube.com/vi/${videoId}/0.jpg`,
      author: data.author_name || 'YouTube',
      url: `https://www.youtube.com/watch?v=${videoId}`,
    });
  } catch (err: any) {
    console.warn('oEmbed failed, attempting ytdl-core fallback:', err.message);
  }

  // Attempt 2: Try ytdl-core (prone to blocking but gives duration)
  try {
    const info = await ytdl.getInfo(url);
    return NextResponse.json({
      title: info.videoDetails.title,
      duration: parseInt(info.videoDetails.lengthSeconds),
      thumbnail: info.videoDetails.thumbnails[0].url,
      author: info.videoDetails.author.name,
      url: url,
    });
  } catch (err: any) {
    console.warn('ytdl-core failed:', err.message);
  }

  return NextResponse.json({ error: 'Failed to fetch video info from all sources' }, { status: 500 });
}
