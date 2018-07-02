exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js"
    },
    stylesheets: {
      joinTo: "css/app.css"
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    assets: /^(static)/
  },

  paths: {
    watched: ["static", "css", "js", "vendor", "elm"],
    public: "../priv/static"
  },

  plugins: {
    babel: {
      ignore: [/vendor/]
    },
    elmBrunch: {
      elmFolder: 'elm',
      executablePath: '../node_modules/elm/binwrappers',
      mainModules: ["Main.elm"],
      makeParameters: ["--debug"],
      outputFolder: "../vendor/",
      outputFile: "elm.js"
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"]
    }
  },

  npm: {
    enabled: true
  }
};
