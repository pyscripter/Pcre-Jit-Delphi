$addPath = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin'
$regexAddPath = [regex]::Escape($addPath)
$arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
$env:Path = ($arrPath + $addPath) -join ';'

$pcrePath = 'pcre-8.44'
Remove-Item –path $pcrePath –recurse
Expand-Archive -LiteralPath $pcrePath'.Zip' -DestinationPath .
copy CMakeLists.txt $pcrePath

pushd $pcrePath
cmake . -G "Visual Studio 16 2019" -A Win32 -DBUILD_SHARED_LIBS=OFF -DPCRE_BUILD_PCRE16=ON -DPCRE_BUILD_PCRE8=OFF -DPCRE_SUPPORT_UNICODE_PROPERTIES=ON -DPCRE_SUPPORT_JIT=ON -DPCRE_STATIC_RUNTIME=ON -DCMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH=OFF
cmake --build . --config Release
..\objconv "-ns:@4:" "-ns:@8:" "-ns:@12" "-ns:@16:" .\pcre16.dir\Release\pcre16_jit_compile.obj .\pcre16.dir\Release\pcre16_jit_compile.new
del .\pcre16.dir\Release\pcre16_jit_compile.obj
ren .\pcre16.dir\Release\pcre16_jit_compile.new pcre16_jit_compile.obj
copy .\pcre16.dir\Release\*.obj ..\Source\obj\pcre\win32\
popd


