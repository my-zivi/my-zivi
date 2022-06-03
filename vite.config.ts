import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import preact from '@preact/preset-vite';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    preact(),
  ],
});
