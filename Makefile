.PHONY : book
book :
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

.PHONY : clean
clean :
	#rm -r docs/
	#rm -r _bookdown_files/
	Rscript -e "bookdown::clean_book()"
	Rscript -e "bookdown::clean_book(TRUE)"
