import { NextRequest, NextResponse } from 'next/server';
import ytdl from '@distube/ytdl-core';
import axios from 'axios';

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const url = searchParams.get('url');

  if (!url) {
    return NextResponse.json({ error: 'URL is required' }, { status: 400 });
  }

  if (!ytdl.validateURL(url)) {
    return NextResponse.json({ error: 'Invalid YouTube URL' }, { status: 400 });
  }

  // Attempt 1: Try ytdl-core (fast but prone to blocking on Vercel)
  try {
    const info = await ytdl.getInfo(url);
    const details = {
      title: info.videoDetails.title,
      duration: parseInt(info.videoDetails.lengthSeconds),
      thumbnail: info.videoDetails.thumbnails[0].url,
      author: info.videoDetails.author.name,
      url: url,
    };
    return NextResponse.json(details);
  } catch (err: any) {
    console.warn('ytdl-core failed, attempting fallback:', err.message);
  }

  // Attempt 2: Use Cobalt API as a fallback for metadata
  try {
    const response = await axios.post('https://api.cobalt.tools/', {
      url: url,
      downloadMode: 'audio',
    }, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    });

    if (response.data && response.data.status !== 'error') {
      return NextResponse.json({
        title: response.data.filename || 'YouTube Track',
        duration: 0,
        thumbnail: `https://img.youtube.com/vi/${ytdl.getVideoID(url)}/0.jpg`,
        author: 'YouTube',
        url: url,
      });
    }
  } catch (err: any) {
    console.error('Fallback failed:', err.message);
  }

  return NextResponse.json({ error: 'Failed to fetch video info from all sources' }, { status: 500 });
}
