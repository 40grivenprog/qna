const { environment } = require('@rails/webpacker')
    const webpack = require('webpack')
    environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery'
    })
    )
const HbsLoader = {
    test: /\.hbs$/,
    loader: 'handlebars-loader'
}
environment.loaders.append('hbs', HbsLoader)
    module.exports = environment
