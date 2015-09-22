# css-snippets

Generate file form template and list files.

[![asciicast](https://asciinema.org/a/c34uoakjgnmqsbi9h1rjwp69m.png)](https://asciinema.org/a/c34uoakjgnmqsbi9h1rjwp69m)

Container snippets:

```js
{
    "w": ["width"],
    "h": ["height"],
    "miw": ["min-width"],
    "mih": ["min-height"],
    "maw": ["max-width"],
    "mah": ["max-height"],
    "lh": ["line-height"],
    "w1": ["width", "100%"],
    "h1": ["height", "100%"],
    "lh1": ["line-height", "1"],


    "p": ["padding"],
    "pt": ["padding-top"],
    "pr": ["padding-right"],
    "pb": ["padding-bottom"],
    "pl": ["padding-left"],
    "m": ["margin"],
    "mt": ["margin-top"],
    "mr": ["margin-right"],
    "mb": ["margin-bottom"],
    "ml": ["margin-left"],
    "p0": ["padding", "0"],
    "m0": ["margin", "0"],
    "m0a": ["margin", "0 auto"],
    "bd": ["border"],
    "bdt": ["border-top"],
    "bdr": ["border-right"],
    "bdb": ["border-bottom"],
    "bdl": ["border-left"],
    "bd1": ["border", "1px solid #ddd"],
    "bd1d": ["border", "1px dotted #ddd"],


    "pos": ["posistion"],
    "posr": ["posistion", "relative"],
    "posa": ["posistion", "absolute"],
    "posf": ["posistion", "fixed"],
    "t": ["top"],
    "r": ["right"],
    "b": ["bottom"],
    "l": ["left"],
    "t0": ["top", "0"],
    "r0": ["right", "0"],
    "b0": ["bottom", "0"],
    "l0": ["left", "0"],
    "z": ["z-index"],
    "z9": ["z-index", "9999"],
    "z8": ["z-index", "8888"],
    "fl": ["float"],
    "fll": ["float", "left"],
    "flr": ["float", "right"],
    "db": ["display", "block"],
    "dib": ["display", "inline-block"],


    "ta": ["text-align", "left"],
    "tac": ["text-align", "center"],
    "tar": ["text-align", "right"],
    "vam": ["vertical-align", "top"],
    "vat": ["vertical-align", "middle"],
    "vab": ["vertical-align", "bottom"],


    "bg": ["background"],
    "bgc": ["background-color"],
    "bgi": ["background-image", "url(\"\")"],
    "bgr": ["background-repeat"],
    "bgrn": ["background-repeat", "no-repeat"],
    "bgs": ["background-size"],
    "c": ["color"],
    "bdc": ["border-color"],
    "op": ["opacity"],
    "op1": ["opacity", "1"],
    "op0": ["opacity", "0"],


    "fz": ["font-size"],
    "fz+": ["font-size", "1.125em"],
    "fz-": ["font-size", "0.875em"],
    "fw": ["font-weight"],
    "fwb": ["font-weight", "bolder"],
    "fwn": ["font-weight", "normal"],
    "fs": ["font-style"],
    "fsi": ["font-style", "italic"],
    "fsn": ["font-style", "normal"],
    "td": ["text-decoration"],
    "tdn": ["text-decoration", "none"],
    "tdu": ["text-decoration", "normal"],
    "ls": ["letter-space"],
    "ws": ["white-space"],
    "wsn": ["white-space", "nowrap"],


    "bdn": ["border", "none"],
    "bgn": ["background", "transparent"],
    "box": [ "box-sizing", "border-box"],
    "o0": ["outline", "0"],


    "ov": ["overflow"],
    "ovh": ["overflow", "hidden"],
    "ovs": [ "overflow", "scroll"],
    "cu": ["cursor"],
    "cup": ["cursor", "pointer"],
    "cud": ["cursor", "default"],
    "cun": ["cursor", "not-allow"],
    "pen": ["pointer-events", "none"]

}
```

Add or modifie your own custom snippets to ./resources/snippets.json tail.

And modifie the template file at ./resources/form.hbs.

## Usage

	$ cp -r ./resources/ /path/to/example-path/
	$ cp ./target/css-snippets-0.1.0-standalone.jar /path/to/example-path/
	$ java -jar css-snippets-0.1.0-standalone.jar [dir-path]
	

## Example

	$ mkdir ~/emacs.d/snippets/css-mode
	$ java -jar css-snippets-0.1.0-standalone.jar ~/emacs.d/snippets/css-mode

## License

The MIT License (MIT)

Copyright © 2015 Yufi

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
“Software”), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
