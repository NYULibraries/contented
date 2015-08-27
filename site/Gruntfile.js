function js(filename){
  return 'assets/js/src/' + filename + '.js';
}

function jsArray(filenames){
  return filenames.split(',').map(function(filename){
    return js(filename.trim());
  });
}

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    /*sass: {
      dist: {
        files: [{
          expand: true,
          cwd: 'src/scss',
          src: ['*.scss'],
          dest: ['build/css', '_site/build/css'],
          ext: '.css'
        }]
      },
      options: {
        style: 'compressed'
      }
    },*/
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n',
        sourceMap: true
      },
      global: {
        src: jsArray('polyfills/classList, plugins/debounce-throttle, plugins/bowser.min, plugins/equalize, plugins/imagesLoaded.min, plugins/load, plugins/tablesaw.stackonly, global, rss'),
        dest: 'assets/js/dist/global.min.js'
      },
      stretchy: {
        src: js('plugins/stretchy'),
        dest: 'assets/js/dist/plugins/stretchy.min.js'
      },
      collection: {
        src: jsArray('plugins/jquery.deserialize.min, search'),
        dest: 'assets/js/dist/collection.min.js'
      },
      ie: {
        src: jsArray('polyfills/ie, polyfills/respond'),
        dest: 'assets/js/dist/polyfills/ie.js'
      }
    },
    watch: {
      /*css: {
        files: 'src/scss/*.scss',
        tasks: ['sass']
      },*/
      scripts: {
        files: 'assets/js/src/**/*.js',
        tasks: ['uglify'],
        options: {
          livereload: true,
        }
      },
      site_css: {
        files: '_site/assets/css/*.css',
        options: {
          livereload: true,
        }
      }
    }
  });

  // Load the plugins:
  grunt.loadNpmTasks('grunt-contrib-sass');   // $ grunt sass
  grunt.loadNpmTasks('grunt-contrib-uglify'); // $ grunt uglify
  grunt.loadNpmTasks('grunt-contrib-watch');  // $ grunt watch

  // Default task:
  grunt.registerTask('default', ['watch']);   // $ grunt

};