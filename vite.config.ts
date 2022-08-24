import { defineConfig } from 'vite';
import preact from '@preact/preset-vite';
import * as path from 'path';
import alias from '@rollup/plugin-alias';
import resolve from '@rollup/plugin-node-resolve';
import fg from 'fast-glob';

const customResolver = resolve({
  extensions: ['.mjs', '.js', '.jsx', '.json', '.sass', '.scss', '.ts', '.tsx'],
});

export default defineConfig({
  css: {
    devSourcemap: true,
  },
  build: {
    outDir: path.resolve(__dirname, 'app/assets/builds'),
    rollupOptions: {
      input: fg.sync(['app/javascript/packs/**/*.js', 'app/javascript/packs/**/*.ts']),
      output: {
        entryFileNames: '[name].js',
        assetFileNames: '[name][extname]',
      },
      plugins: [
        alias({
          entries: [
            {
              find: 'js',
              replacement: path.resolve(__dirname, 'app/javascript/js'),
            },
          ],
          // eslint-disable-next-line @typescript-eslint/ban-ts-comment
          // @ts-ignore
          customResolver,
        }),
        resolve(),
      ],
    },
  },
  publicDir: false,
  plugins: [preact()],
});
