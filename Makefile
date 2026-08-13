COBC ?= cobc
CFLAGS ?= -x -free -Wall

.PHONY: all clean check

all: artists-club

artists-club: artists-club.cob
	$(COBC) $(CFLAGS) -o $@ $<

check:
	@grep -q 'VERIFIED_ARTIST' artists-club.cob
	@grep -q 'PORTFOLIO' artists-club.cob
	@grep -q 'DRAWING-TITLE' artists-club.cob
	@grep -q 'PAINTING-TITLE' artists-club.cob
	@grep -q 'COMPOSITION-TITLE' artists-club.cob
	@grep -q 'MEDIA-TYPE' artists-club.cob
	@echo 'COBOL source smoke checks passed.'

clean:
	rm -f artists-club applications.dat reviews.dat
