import { NextRequest, NextResponse } from 'next/server';
import ytdl from '@distube/ytdl-core';

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const url = searchParams.get('url');

  if (!url) {
    return NextResponse.json({ error: 'URL is required' }, { status: 400 });
  }

  if (!ytdl.validateURL(url)) {
    return NextResponse.json({ error: 'Invalid YouTube URL' }, { status: 400 });
  }

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
  } catch (error) {
    console.error('Error fetching video info:', error);
    return NextResponse.json({ error: 'Failed to fetch video info' }, { status: 500 });
  }
}
