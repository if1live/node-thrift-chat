module.exports = function(grunt) {
  // Project configuration
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    bowercopy: {
      options: {
        clean: false
      },
      glob: {
        files: {
          'public/libs/socket.io': ['socket.io-client/dist/*'],
          'public/libs/jquery': ['jquery/dist/*']
        }
      }
    },
    shell: {
      thrift: {
        command: [
          'thrift -r --gen js:node shared/hello.thrift',
          'thrift -r --gen js -o public shared/hello.thrift',
        ].join('&&'),
        options: {
          stdout: true
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-bowercopy');
  grunt.loadNpmTasks('grunt-shell');

  grunt.registerTask('default', ['shell', 'bowercopy']);
};
