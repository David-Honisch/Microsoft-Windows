import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    // During development, send API calls to the Go server.
    proxy: { '/api': 'http://localhost:10085' },
  },
});
