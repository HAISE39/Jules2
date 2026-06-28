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
    // Basic options for better reliability
    const options: ytdl.downloadOptions = {
      filter: 'audioonly',
      quality: 'highestaudio',
      // Adding some headers might help with certain restrictions
      requestOptions: {
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        }
      }
    };

    const stream = ytdl(url, options);

    // Convert the stream to a ReadableStream for the Response object
    const readable = new ReadableStream({
      start(controller) {
        stream.on('data', (chunk) => {
          controller.enqueue(chunk);
        });
        stream.on('end', () => {
          controller.close();
        });
        stream.on('error', (err) => {
          console.error('ytdl stream error:', err);
          controller.error(err);
        });
      },
      cancel() {
        stream.destroy();
      },
    });

    return new Response(readable, {
      headers: {
        'Content-Type': 'audio/mpeg',
        'Content-Disposition': 'attachment; filename="audio.mp3"',
        // Ensure no-cache to avoid issues with repeated downloads
        'Cache-Control': 'no-store',
      },
    });
  } catch (error: any) {
    console.error('Error streaming audio:', error);
    return NextResponse.json({
      error: 'Failed to stream audio',
      details: error.message
    }, { status: 500 });
  }
}
