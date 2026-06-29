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

  // Attempt 1: Cobalt API (more reliable for bypassing YouTube's bot detection)
  try {
    const cobaltResponse = await axios.post('https://api.cobalt.tools/', {
      url: url,
      downloadMode: 'audio',
      audioFormat: 'mp3',
      audioBitrate: '128',
    }, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    });

    if (cobaltResponse.data && cobaltResponse.data.url) {
      const audioUrl = cobaltResponse.data.url;

      // Fetch the audio as an ArrayBuffer to be safe with Web-standard Response
      const streamResponse = await axios.get(audioUrl, { responseType: 'arraybuffer' });

      return new Response(streamResponse.data, {
        headers: {
          'Content-Type': 'audio/mpeg',
          'Content-Disposition': 'attachment; filename="audio.mp3"',
          'Cache-Control': 'no-store',
        },
      });
    }
  } catch (err: any) {
    console.warn('Cobalt download failed, falling back to ytdl-core:', err.message);
  }

  // Attempt 2: ytdl-core (as fallback)
  try {
    const stream = ytdl(url, {
      filter: 'audioonly',
      quality: 'highestaudio',
      requestOptions: {
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        }
      }
    });

    const readable = new ReadableStream({
      start(controller) {
        stream.on('data', (chunk) => controller.enqueue(chunk));
        stream.on('end', () => controller.close());
        stream.on('error', (err) => controller.error(err));
      },
      cancel() {
        stream.destroy();
      },
    });

    return new Response(readable, {
      headers: {
        'Content-Type': 'audio/mpeg',
        'Content-Disposition': 'attachment; filename="audio.mp3"',
        'Cache-Control': 'no-store',
      },
    });
  } catch (error: any) {
    console.error('Error streaming audio from all sources:', error);
    return NextResponse.json({
      error: 'Failed to stream audio',
      details: error.message
    }, { status: 500 });
  }
}
