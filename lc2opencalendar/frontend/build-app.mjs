import { cp, mkdir, readdir, rm } from 'node:fs/promises';
import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const frontendDir = path.dirname(fileURLToPath(import.meta.url));
const repositoryDir = path.resolve(frontendDir, '..');
const frontendDist = path.join(frontendDir, 'dist');
const backendDir = path.join(repositoryDir, 'backend');
const embedDir = path.join(backendDir, 'web', 'dist');

await mkdir(embedDir, { recursive: true });
for (const entry of await readdir(embedDir)) {
  if (entry !== '.gitkeep') {
    await rm(path.join(embedDir, entry), { recursive: true, force: true });
  }
}
await cp(frontendDist, embedDir, { recursive: true });

const binaryName = `backend${process.platform === 'win32' ? '.exe' : ''}`;
const result = spawnSync('go', ['build', '-o', binaryName, '.'], {
  cwd: backendDir,
  stdio: 'inherit',
});

if (result.error) throw result.error;
if (result.status !== 0) process.exitCode = result.status ?? 1;
