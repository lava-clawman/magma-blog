/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        magma: {
          dark: '#0a0a0a',
          red: '#ff4500',
          light: '#ededed'
        }
      },
      fontFamily: {
        mono: ['"Fira Code"', 'monospace']
      }
    },
  },
  plugins: [],
}