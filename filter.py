#!/usr/bin/python3
from panflute import *

def simple_id(filename):
    return ''.join((c for c in filename if c.isdigit()))

def my_filter(elem, doc):
    # demotes headers to prevent first-level headers
    # also prepends a per-file identifer
    if isinstance(elem, Header):
        elem.level += 1
        prefix = simple_id(str(doc.metadata['title']))
        elem.identifier = prefix + ':' + elem.identifier

def main(doc=None):
    return run_filter(my_filter, doc=doc)

if __name__ == '__main__':
    main()
