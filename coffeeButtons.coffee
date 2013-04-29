$ = jQuery

phpProxyUrl = './php/proxy.php?url='

Colors =
    # rgb <-> hsl algorithms from
    # http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript
    #
    # Converts an RGB color value to HSL. Conversion formula
    # adapted from http://en.wikipedia.org/wiki/HSL_color_space.
    # Assumes r, g, and b are contained in the set [0, 255] and
    # returns h, s, and l in the set [0, 1].
    #
    # @param    Number  red             The red color value
    # @param    Number  g   The green color value
    # @param    Number  b   The blue color value
    # @return   Array       The HSL representation
    #
    rgbToHsl: (r, g, b) ->
        r /= 255
        g /= 255
        b /= 255
        max = Math.max(r, g, b)
        min = Math.min(r, g, b)
        l = (max + min) / 2

        if max == min
            h = s = 0 # achromatic
        else
            d = max - min
            s = if l > 0.5 then d / (2 - max - min) else d / (max + min)

            switch max
                when r
                    h = (g - b) / d + (if g < b then 6 else 0)
                when g
                    h = (b - r) / d + 2
                when b
                    h = (r - g) / d + 4

            h /= 6

        [h, s, l]

    #
    # Converts an HSL color value to RGB. Conversion formula
    # adapted from http://en.wikipedia.org/wiki/HSL_color_space.
    # Assumes h, s, and l are contained in the set [0, 1] and
    # returns r, g, and b in the set [0, 255].
    #
    # @param    Number  h   The hue
    # @param    Number  s   The saturation
    # @param    Number  l   The lightness
    # @return   Array       The RGB representation
    #
    hslToRgb: (h, s, l) ->
        if s == 0
            r = g = b = l # achromatic
        else
            hue2rgb = (p, q, t) ->
                if t < 0 then t += 1
                if t > 1 then t -= 1
                if t < 1/6 then return p + (q - p) * 6 * t
                if t < 1/2 then return q
                if t < 2/3 then return p + (q - p) * (2/3 - t) * 6
                return p

            q = if l < 0.5 then l * (1 + s) else l + s - l * s
            p = 2 * l - q
            r = hue2rgb(p, q, h + 1/3)
            g = hue2rgb(p, q, h)
            b = hue2rgb(p, q, h - 1/3)

        [r * 255, g * 255, b * 255]

    # turn a CSS compatible hex string to an rgb triple.
    #
    # @param    String  colr    A hex color value. With or without leading "#".
    # @return   Array   rgb     An RGB triple with values in the set [0, 255].
    #
    rgbify: (colr) ->
        colr = colr.replace /#/, ''
        if colr.length is 3
            [
                parseInt(colr.slice(0,1) + colr.slice(0, 1), 16)
                parseInt(colr.slice(1,2) + colr.slice(1, 1), 16)
                parseInt(colr.slice(2,3) + colr.slice(2, 1), 16)
            ]
        else if colr.length is 6
            [
                parseInt(colr.slice(0,2), 16)
                parseInt(colr.slice(2,4), 16)
                parseInt(colr.slice(4,6), 16)
            ]
        else
            # just return black
            [0, 0, 0]

    # rgb to css compatible hex color string.
    #
    # @param    Array   rgb     An RGB color triple.
    # @return   String  rgb     The color in CSS style hex with leading "#"
    #
    hexify: (rgb) ->
        red = Math.floor(rgb[0]).toString(16)
        if (red.length < 2)
            red = '0' + red

        blue = Math.floor(rgb[1]).toString(16)
        if (blue.length < 2)
            blue = '0' + blue

        green = Math.floor(rgb[2]).toString(16)
        if (green.length < 2)
            green = '0' + green

        colr = '#'
        colr += red
        colr += blue
        colr += green
        colr

    # lighten color by percent of its current lightness. NOTE: this means colors that
    # start darker will need a much higher `percent` value to make them appear brighter.
    #
    # @param    Array or String     rgb         An RGB color description.
    # @param    Float               percent     A percentage value >= 0
    # @return   String              hex         A hex string of the new color.
    #
    lighten: (rgb, percent) ->
        rgb = @rgbify(rgb) if typeof rgb == 'string'

        hsl = @rgbToHsl.apply this, rgb
        lightness = hsl[2] + (hsl[2] * percent)
        lightness = Math.min 1.0, lightness
        str = @hexify( @hslToRgb( hsl[0], hsl[1], lightness ) )

        str


formatBytes = (bytes) ->
    # Define the byte suffix
    sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
    # If bytes is 0, skip everything
    if bytes == 0
        return 'n/a'
    # Parse the bytes
    i = parseInt( Math.floor( Math.log( bytes ) / Math.log( 1024 ) ) )
    # Return the bytes
    (bytes / Math.pow(1024, i)).toFixed(2) + ' ' + sizes[i]

doTheme = (obj, options) ->
    bot = options.buttonColour
    top = Colors.lighten(bot, 0.35)

    # Multiple same keys in an arraymap doesnt work :(
    # Horrible but it works...
    #
    # PS: I'm sorry for doing it like this
    $( 'a', obj ).css( { background: bot })
    $( 'a', obj ).css( { background: "linear-gradient( top, #{top} 0%, #{bot} 100%)" })
    $( 'a', obj ).css( { background: "-o-linear-gradient( top, #{top} 0%, #{bot} 100%)" })
    $( 'a', obj ).css( { background: "-ms-linear-gradient( top, #{top} 0%, #{bot} 100%)" })
    $( 'a', obj ).css( { background: "-moz-linear-gradient( top, #{top} 0%, #{bot} 100%)" })
    $( 'a', obj ).css( { background: "-webkit-linear-gradient( top, #{top} 0%, #{bot} 100%)" })
    $( 'a', obj ).css( { color:      options.buttonTextColour })
    $( 'p', obj ).css( { background: options.tabColour })
    $( 'p', obj ).css( { color:      options.tabTextColour })

$.fn.jButton = (options) ->
    defaults =
        buttonColour:     '#009ec3'
        tabColour:        '#222222'
        tabTextColour:    '#ffffff'
        buttonTextColour: '#ffffff'

    options = $.extend( defaults, options )
    @each ->
        button = $( this )

        file   = button.data( 'file' )

        button.addClass('jbutton')

        button.append(
            $('<a>').attr('href', file).text('Download')
        ).append(
            $('<p>').attr('class', 'top')
        ).append(
            $('<p>').attr( 'class', 'bottom')
        )

        doTheme( button, options )

        $.ajax({
            type: 'GET',
            url: phpProxyUrl + file,
            dataType: 'json'
            success: (data) ->
                if parseInt(data['httpCode']) == 200
                    $('.top', button).text('Type: ' + data['Content-Type'] )
                    $('.bottom', button).text('Size: ' + formatBytes( data['Content-Length'] ) )
                else
                    $('.top', button).text('Error: ' + data['httpCode'] )
                    $('.bottom', button).text( data['httpResp'] )
            error: (x, t, m) ->
        })
