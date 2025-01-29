# lapfox radio epg
a little script to generate an xmltv/epg file for use in iptv programs <br>
i would love to make this a public resource, but i have no fucking clue how to push to github with lua, so.. host it yourself lol <br>
its not even a megabyte..

## what does this do?
every 30 seconds, itll ping the lapfox radio api to get whats playing, and whats up next, then generate an xml file for use with iptv programs <br>
you can probably adapt this to work with most [azuracast](https://azuracast.com/) based radios, assuming they all function the same idk ive never used any others

## how do i run this?
- install [luvit](https://luvit.io/) (this was written for v2.14)
  - place the binaries in the same directory as `index.lua`, or place them in your PATH
- run the bot with `luvit index.lua`

if your implementation requires a web server, please use the `web-server` branch

## hardware requirements
- any 32+ bit cpu thats clocked in the mhz range (sorry 6502 users, arm probably works i havent checked)
- some cpu cache worth of memory (~2mb or something)
- a floppy disc of storage (not even a megabyte)
- hopefully broadband internet, but dial-up will work too
