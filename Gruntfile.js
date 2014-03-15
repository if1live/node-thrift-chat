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
    }
  });

  grunt.loadNpmTasks('grunt-bowercopy');

  grunt.registerTask('default', ['bowercopy']);
};
