/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/presenters/**/*.rb',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
  // Enable RTL support
  corePlugins: {
    // Enable direction utilities
    direction: true,
  },
}
