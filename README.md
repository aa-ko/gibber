# gibber

#### gibber helps you convert all your favorite plain text files from any encoding to another!
Just call it using the following three parameters:
1. the path you want to search files in
2. a filter enclosed in quotes, e.g. _"*.js"_
3. the target encoding, e.g. _utf-8_

### Dependencies
- bash
- find
- sed
- iconv

### Usage example
```bash
$ ./gibber.sh . "*.js" utf-8
```

That's it...