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
    onProgress(progress * 100);
  });

  const inputFiles: string[] = [];

  // Download and write files to FFmpeg virtual FS
  for (let i = 0; i < urls.length; i++) {
    const filename = `input${i}.mp3`;
    const response = await fetch(`/api/download?url=${encodeURIComponent(urls[i])}`);
    if (!response.ok) throw new Error(`Failed to download track ${i + 1}`);

    const arrayBuffer = await response.arrayBuffer();
    await ffmpeg.writeFile(filename, new Uint8Array(arrayBuffer));
    inputFiles.push(filename);
  }

  // Create a complex filter for concatenation
  // or use the concat demuxer if they are all same format.
  // Using concat demuxer approach:
  const concatList = inputFiles.map(file => `file '${file}'`).join('\n');
  await ffmpeg.writeFile('concat.txt', concatList);

  await ffmpeg.exec([
    '-f', 'concat',
    '-safe', '0',
    '-i', 'concat.txt',
    '-c', 'copy',
    'output.mp3'
  ]);

  const data = await ffmpeg.readFile('output.mp3');

  // Convert Uint8Array to Blob safely, bypassing the SharedArrayBuffer type issue if it occurs
  const blob = new Blob([(data as Uint8Array) as any], { type: 'audio/mp3' });

  // Cleanup
  for (const file of inputFiles) {
    await ffmpeg.deleteFile(file);
  }
  await ffmpeg.deleteFile('concat.txt');
  await ffmpeg.deleteFile('output.mp3');

  return blob;
};
