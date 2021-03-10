function imgn = clear_background(img)
imgn = 255 - mode(img(:)) + img + 5;