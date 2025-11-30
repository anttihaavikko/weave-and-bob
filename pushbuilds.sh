COLOR='\033[0;36m'
NC='\033[0m' # No Color

echo " "

echo "${COLOR}Pushing build for Windows${NC}"
butler push Builds/win anttihaavikko/weave-and-bob:win --fix-permissions

echo "${COLOR}Pushing build for OSX${NC}"
butler push Builds/macos anttihaavikko/weave-and-bob:osx --fix-permissions

echo "${COLOR}Pushing build for Linux${NC}"
butler push Builds/linux anttihaavikko/weave-and-bob:linux

# echo "${COLOR}Copying html5 files over to correct path"
# cp -a Builds/webgl/html5/Build/. Builds/html5/Build
# cp Builds/web/index_mod.html Builds/web/index.html
echo "${COLOR}Pushing build for HTML5${NC}"
butler push Builds/web anttihaavikko/weave-and-bob:html5
