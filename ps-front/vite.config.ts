import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
const { resolve } = require('path')
// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  build: {
    outDir: "../public"
  }
})
