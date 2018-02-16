#!/bin/bash
echo "clean deploy folder"
rm -rf deploy-stuff

git clone --depth 10 -b gh-pages "https://${GITHUB_TOKEN}@github.com/VoxelGamesLib/VoxelGamesLibv2.git" deploy-stuff

# config
echo "setup git"
git config --global user.email "vglbot@minidigger.me"
git config --global user.name "VoxelGamesLibBot"

# copy over stuff we want to deploy
echo "copy stuff to deploy"
cp -R build/dependencyUpdates/. deploy-stuff/chatmenuapi
cp -R build/docs/javadoc/. deploy-stuff/chatmenuapi/javadoc
cp -R build/reports/. deploy-stuff/chatmenuapi
cp -R build/libs/. deploy-stuff/chatmenuapi

# create mvn repo
mkdir deploy-stuff/mvn-repo/
mvn deploy:deploy-file -Dfile=build/libs/chatmenuapi-1.0-SNAPSHOT-all.jar -DpomFile=pom.xml  -Durl=file://${TRAVIS_BUILD_DIR}/deploy-stuff/mvn-repo

# create index
sudo pip install mako
python scripts/make_index.py --header "VGL Deployments" deploy-stuff

# deploy
echo "commit repo"
cd deploy-stuff
git add .
echo "commit"
git commit -m "Deploy to Github Pages (chatmenuapi)"
echo "push"
git push --force "https://${GITHUB_TOKEN}@github.com/VoxelGamesLib/VoxelGamesLibv2.git" gh-pages:gh-pages