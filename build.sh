#! /bin/bash

set -e

DEPLOY_REPO="https://${DEPLOY_TOKEN}@github.com/hoanganhduc/hoanganhduc.github.io.git"

function build_jekyll_site () {
	bundle exec jekyll build --config _config.yml
}

function deploy () {
	find ./docs -type f -name "*.html" -exec sed -i 's,/>,>,g' {} \; && sed -i 's,Duc A. Hoang,<u>Duc A. Hoang</u>,g' ./docs/publications/index.html && bundle clean && rm -rf .jekyll-cache .bundler vendor && git clone $DEPLOY_REPO site && rsync -arv --delete --exclude "site" * site && cd site && find ./ -type f -exec chmod 644 {} \; && find ./ -type d -exec chmod 755 {} \; && git add --all . && git commit -S -m "Travis CI Build $TRAVIS_BUILD_NUMBER @ $(date +'%Y-%m-%d  %H:%M:%S %Z') [skip travis]" && git push -u origin master && cd ..
}

function clean () {
	rm -rf *
}

main () {
	build_jekyll_site
	deploy
	clean
}

main "$@"
