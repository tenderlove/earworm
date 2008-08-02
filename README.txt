= earworm

* http://earworm.rubyforge.org

== DESCRIPTION:

Earworm can identify unknown music using MusicDNS and libofa.

== FEATURES/PROBLEMS:

* Identifies mp3, ogg, and wav files.

== SYNOPSIS:

Identify an unknown audio file:

  ew = Earworm::Client.new('MY Music DNS Key')
  info = ew.identify(:file => '/home/aaron/unknown.wav')
  puts "#{info.artist_name} - #{info.title}"

Fetch info for a PUID:

  ew = Earworm::Client.new('MY Music DNS Key')
  info = ew.identify(:puid => 'f39d4c68-ab2d-5067-9a1a-c6b45a367906')
  puts "#{info.artist_name} - #{info.title}"

== REQUIREMENTS:

* {MusicDNS key}[https://secure.musicip.com/dns/index.jsp]
* libofa
* icanhasaudio

== INSTALL:

OS X:
* sudo port install libogg libvorbis lame libofa
* gem install earworm

Linux:
* sudo yum install libogg-devel libvorbis-devel lame-devel libofa
* gem install earworm

== LICENSE:

(The MIT License)

Copyright (c) 2008 {Aaron Patterson}[http://tenderlovemaking.com/]

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
