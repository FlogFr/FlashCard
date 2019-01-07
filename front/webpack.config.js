const path = require("path");

module.exports = {
    entry: "./main.js",
    output: {
        path: path.join(__dirname, "/dist"),
        filename: "izidict.js"
    },
    module: {
        rules: [{
            test: /\.jsx?$/,
            exclude: /node_modules/,
            use: [{
                loader: "babel-loader"
            }]
        }]
    }
};
