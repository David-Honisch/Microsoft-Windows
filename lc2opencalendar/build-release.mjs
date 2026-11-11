import { cp, mkdir, readFile, readdir, rm, stat, writeFile } from 'node:fs/promises';
import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const frontendDir = path.join(root, 'frontend');
const backendDir = path.join(root, 'backend');
const desktopDir = path.join(root, 'desktop');
const npm = process.platform === 'win32' ? 'npm.cmd' : 'npm';

function run(command, args, cwd) {
  const result = spawnSync(command, args, {
    cwd,
    stdio: 'inherit',
    shell: process.platform === 'win32' && command === npm,
  });
  if (result.error) throw result.error;
  if (result.status !== 0) {
    throw new Error(`${command} ${args.join(' ')} failed with exit code ${result.status ?? 1}`);
  }
}

const { version } = JSON.parse(
  await readFile(path.join(desktopDir, 'package.json'), 'utf8'),
);
const imageTagVersion = version.replace(/[^A-Za-z0-9_.-]/g, '-');
const startedAt = Date.now();
const platformName = `${process.platform}-${process.arch}`;
const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
const releaseDir = path.join(root, 'release', `lc2opencalendar-${version}-${platformName}-${timestamp}`);
const desktopDist = path.join(releaseDir, 'desktop');
const desktopOutput = path.relative(desktopDir, desktopDist);
await mkdir(desktopDist, { recursive: true });

run(npm, ['ci'], frontendDir);
run(npm, ['run', 'build:app'], frontendDir);
run('go', ['test', './...'], backendDir);

run(npm, ['ci'], desktopDir);
run(npm, ['run', 'dist', '--', `--config.directories.output=${desktopOutput}`], desktopDir);

const backendBinary = path.join(
  backendDir,
  `backend${process.platform === 'win32' ? '.exe' : ''}`,
);
await cp(backendBinary, path.join(releaseDir, path.basename(backendBinary)));
await cp(path.join(backendDir, 'backend.config.json'), path.join(releaseDir, 'backend.config.json'));

const installerExtensions = new Set(
  process.platform === 'win32' ? ['.exe'] :
    process.platform === 'darwin' ? ['.dmg'] :
      process.platform === 'linux' ? ['.AppImage'] : [],
);
if (installerExtensions.size === 0) {
  throw new Error(`Unsupported desktop installer platform: ${process.platform}`);
}

const desktopOutputs = await readdir(desktopDist, { withFileTypes: true });
const installers = [];
for (const output of desktopOutputs) {
  if (!output.isFile() || ![...installerExtensions].some(
    (extension) => output.name.endsWith(extension),
  )) continue;
  const outputPath = path.join(desktopDist, output.name);
  if ((await stat(outputPath)).mtimeMs < startedAt) continue;
  installers.push(outputPath);
}
if (installers.length === 0) {
  throw new Error(`No new desktop installer found in ${desktopDist}`);
}
for (const installer of installers) {
  await cp(installer, path.join(releaseDir, path.basename(installer)));
}
console.log(`Desktop installer created in ${path.relative(root, desktopDist)}`);
await rm(desktopDist, { recursive: true, force: true });
await rm(path.join(releaseDir, 'builder-debug.yml'), { force: true });

run('docker', ['build', '-t', `lc2opencalendar:${imageTagVersion}`, '.'], root);
const dockerArchive = path.join(releaseDir, `lc2opencalendar-${version}-docker-image.tar`);
run('docker', ['save', '-o', dockerArchive, `lc2opencalendar:${imageTagVersion}`], root);

await cp(path.join(root, 'LICENSE'), path.join(releaseDir, 'LICENSE'));
await cp(path.join(root, 'README.md'), path.join(releaseDir, 'README.md'));
await writeFile(
  path.join(releaseDir, 'BUILD.txt'),
  [
    `lc2opencalendar ${version}`,
    `Platform: ${platformName}`,
    `Docker image: lc2opencalendar:${imageTagVersion}`,
    'The backend binary includes the built frontend.',
    '',
  ].join('\n'),
);

console.log(`Release artifacts created in ${path.relative(root, releaseDir)}`);
