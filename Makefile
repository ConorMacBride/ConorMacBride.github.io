LOCAL= _site
LIVE= _live
RM= rm -rf

help:
	@echo "install -- install the Gemfile"
	@echo "upgrade -- update ignoring Gemfile.lock"
	@echo "build   -- build a one-off localhost version at '${LOCAL}'"
	@echo "serve   -- serve at 0.0.0.0:80 from '${LOCAL}'"
	@echo "publish -- build a one-off production version at '${LIVE}'"
	@echo "clean   -- remove '${LOCAL}'"

install:
	bundle config set --local path "vendor/bundle"
	bundle install

upgrade:
	bundle update --all

build:
	bundle exec jekyll build --destination $(LOCAL)

serve:
	bundle exec jekyll serve --destination $(LOCAL) -P 80 -H 0.0.0.0 --livereload

publish:
	JEKYLL_ENV=production bundle exec jekyll build --destination $(LIVE)

clean :
	$(RM) $(LOCAL)
