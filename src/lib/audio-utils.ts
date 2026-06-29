import { FFmpeg } from '@ffmpeg/ffmpeg';
import { toBlobURL } from '@ffmpeg/util';

let ffmpeg: FFmpeg | null = null;

export const loadFFmpeg = async () => {
  if (ffmpeg) return ffmpeg;

  ffmpeg = new FFmpeg();

  const baseURL = 'https://unpkg.com/@ffmpeg/core@0.12.6/dist/umd';

  await ffmpeg.load({
    coreURL: await toBlobURL(`${baseURL}/ffmpeg-core.js`, 'text/javascript'),
    wasmURL: await toBlobURL(`${baseURL}/ffmpeg-core.wasm`, 'application/wasm'),
  });

  return ffmpeg;
};

export const mergeAudioFiles = async (
  urls: string[],
  onProgress: (progress: number) => void
): Promise<Blob> => {
  const ffmpeg = await loadFFmpeg();

  ffmpeg.on('log', ({ message }) => {
    console.log(message);
  });

  ffmpeg.on('progress', ({ progress }) => {
    // We'll have multiple steps, so we scale the progress accordingly
    // However, FFmpeg progress is per-command.
  });

  const rawFiles: string[] = [];
  const processedFiles: string[] = [];

  try {
    // 1. Download and transcode each file to a standardized format
    for (let i = 0; i < urls.length; i++) {
      const rawFilename = `raw${i}.mp3`;
      const processedFilename = `processed${i}.mp3`;

      const response = await fetch(`/api/download?url=${encodeURIComponent(urls[i])}`);
      if (!response.ok) throw new Error(`Failed to download track ${i + 1}`);

      const arrayBuffer = await response.arrayBuffer();
      await ffmpeg.writeFile(rawFilename, new Uint8Array(arrayBuffer));
      rawFiles.push(rawFilename);

      // Transcode to standard format to ensure compatibility for concatenation
      // 44.1kHz, Stereo, 128k bitrate
      await ffmpeg.exec([
        '-i', rawFilename,
        '-ar', '44100',
        '-ac', '2',
        '-b:a', '128k',
        processedFilename
      ]);
      processedFiles.push(processedFilename);

      // Update progress manually for the download/transcode part (0-80%)
      onProgress(((i + 1) / urls.length) * 80);
    }

    // 2. Concatenate the standardized files
    const concatList = processedFiles.map(file => `file '${file}'`).join('\n');
    await ffmpeg.writeFile('concat.txt', concatList);

    await ffmpeg.exec([
      '-f', 'concat',
      '-safe', '0',
      '-i', 'concat.txt',
      '-c', 'copy',
      'output.mp3'
    ]);

    onProgress(100);

    const data = await ffmpeg.readFile('output.mp3');

    // Convert Uint8Array to Blob safely
    const blob = new Blob([(data as Uint8Array) as any], { type: 'audio/mp3' });

    return blob;
  } finally {
    // Cleanup
    for (const file of rawFiles) {
      try { await ffmpeg.deleteFile(file); } catch (e) {}
    }
    for (const file of processedFiles) {
      try { await ffmpeg.deleteFile(file); } catch (e) {}
    }
    try { await ffmpeg.deleteFile('concat.txt'); } catch (e) {}
    try { await ffmpeg.deleteFile('output.mp3'); } catch (e) {}
  }
};
