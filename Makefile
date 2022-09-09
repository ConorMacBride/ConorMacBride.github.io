BUNDLE= /opt/homebrew/opt/ruby/bin/bundle
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
	$(BUNDLE) config set --local path "vendor/bundle"
	$(BUNDLE) install

upgrade:
	$(BUNDLE) update --all

build:
	$(BUNDLE) exec jekyll build --destination $(LOCAL)

serve:
	$(BUNDLE) exec jekyll serve --destination $(LOCAL) -P 80 -H 0.0.0.0 --livereload

publish:
	JEKYLL_ENV=production $(BUNDLE) exec jekyll build --destination $(LIVE)

clean :
	$(RM) $(LOCAL)
