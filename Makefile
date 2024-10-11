# adjust this to your system

PATHDIR="/usr/local/bin"
SRCDIR="src/"

install: src/misc/*.bash
	chmod +x $(SRCDIR)/baur
	cp -r $(SRCDIR)/misc .
	cp -r $(SRCDIR)/git .
	mv misc/ /usr/include/baur/
	mv git/ /usr/include/baur/
	cp $(SRCDIR)/baur $(PATHDIR)

clean:
	rm -rf /usr/include/baur
	rm -rf $(PATHDIR)/baur
