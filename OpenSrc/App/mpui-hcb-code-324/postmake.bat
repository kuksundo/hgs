del *.dcu
del *.~*
del *.ddp
upx.exe --best -v --compress-resources=1 --compress-exports=1 --compress-icons=2 --strip-relocs=1 --all-methods MPUI.exe
upx.exe -v --best --crp-ms=999999 mplayer.exe